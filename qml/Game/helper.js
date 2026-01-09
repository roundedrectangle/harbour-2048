
function getVectors(direction) {
    var vectors = []
    for (var i = 0; i < size; i++) {
        var vector = []
        for (var j = 0; j < size; j++) {
            if (direction === "left") {
                vector[j] = i * size + j;
            }
            else if (direction === "right") {
                vector[j] = (i + 1) * size - j - 1;
            }
            else if (direction === "up") {
                vector[j] = j * size + i;
            }
            else if (direction === "down") {
                vector[j] = (size - j - 1) * size + i;
            }
        }
        vectors[i] = vector;
    }
    return vectors;
}

function getHexaVectors(direction) {
    var vectors    = []
    var maxLength  = 2 * size - 1;
    var doubleSize = maxLength + 1;
    for (var i = 0; i < maxLength; i++) {
        var vector = [];
        var sizeI = i < size;
        var lineLength = size + (sizeI ? i : doubleSize - 2 - i);
        for (var j = 0; j < lineLength; j++) {
            if (direction === "left") {
                vector[j] = i * maxLength + j
            }
            else if (direction === "right") {
                vector[j] = i * maxLength + lineLength - j - 1;
            }
            else if (direction === "uleft" || direction === "dright") {
                var first       = sizeI ? size - 1 - i : (i - size + 1) * maxLength;
                var variation   = j * doubleSize;
                var adjustement = sizeI && j >= size ? j - size + 1 : (!sizeI && j + i + 1 >= doubleSize ? j + i - doubleSize + 2 : 0);
                vector[j] = first + variation - adjustement;
            }
            else if (direction === "uright" || direction === "dleft") {
                var first       = sizeI ? i : size - 1 + (i - size + 1) * doubleSize;
                var variation   = j * maxLength;
                var adjustement = sizeI && j >= size ? j - size + 1 : (!sizeI && j + i + 1 >= doubleSize ? j + i - doubleSize + 2 : 0);
                vector[j] = first + variation - adjustement;
            }
        }
        if (direction === "dleft" || direction === "dright") {
            vectors[i] = vector.reverse();
        }
        else {
            vectors[i] = vector;
        }
    }
    return vectors;
}

function dealWithVectors (vectors, tiles) {
    var moved = false;
    var bombs = [];
    for (var i in vectors) {
        var vector = vectors[i];
        //console.debug("deal with vector :", vector)
        var newVector = [];
        for (var j = 0; j < vector.length; j++) {
            var index = vector[j];
            var tile = tiles[index];
            //console.debug("deal with index :", index, ", tile is", tile);
            if (tile !== undefined) {    // the tile exist and thus has a value
                newVector.push(index);
                if (tile.value === -10) {
                    while (newVector.length < j * 2) {
                        newVector.push(0);
                        newVector.push(index);
                    }
                }
                newVector.push(tile);
            }
        }
        //console.debug("new vector :", newVector);
        var lastTile = undefined;
        var lastTileIndex = undefined;
        var merged = 0;
        for (var j = 1; j < newVector.length; j += 2) {
            var oldIndex = newVector[j - 1];
            var newIndex = vector[(j - 1) / 2 - merged];
            var tile = newVector[j];
            //console.debug("oldIndex :", oldIndex, ", newIndex :", newIndex)
            if (lastTile !== undefined && lastTile.value > 1 && (lastTile.value === tile.value || tile.value === 1 )) {
                //console.debug("merge", oldIndex);
                tiles[oldIndex] = undefined;
                tile.moveTo (slots[lastTileIndex], lastTile)
                moved = true;
                merged++;
                lastTile = undefined;
                lastTileIndex = undefined;
            }
            else if (tile !== 0){
                if (tile.value === -10) {
                    merged = 0;
                }
                else if (oldIndex !== newIndex) {
                    //console.debug("move", oldIndex, "to", newIndex);
                    tile.moveTo (slots[newIndex])
                    moved = true;
                    tiles[newIndex] = tile;
                    tiles[oldIndex] = undefined;
                }
                if (tile.value < -1 && tile.value >= -4) {
                    bombs.push(tile);
                }
                lastTile = tile;
                lastTileIndex = newIndex;
            }
        }
    }
    for (var i in bombs) {
        bombs[i].value++;
        if (bombs[i].value === -1) {
            var index = tiles.indexOf(bombs[i]);
            if (index !== -1) {
                var toDestroy = [index];
                if (index % size !== 0)        { toDestroy.push(index - 1); }
                if (index % size !== size)     { toDestroy.push(index + 1); }
                if (index  >= size)            { toDestroy.push(index - size); }
                if (index / size  <= size - 1) { toDestroy.push(index + size); }
                for (var i in toDestroy) {
                    if (tiles[toDestroy[i]] !== undefined) {
                        tiles[toDestroy[i]].destroy();
                        tiles[toDestroy[i]] = undefined;
                    }
                }
            }
        }
    }
    return moved;
}

function getFreeSpace (tiles, slots) {
    var freeSpace = [];
    for (var i = 0; i < slots.length; i++) {
        var tile = tiles[i];
        var slot = slots[i];
        if (slot !== undefined && tile === undefined) {
            freeSpace.push(i)
        }
    }
    return freeSpace;
}

function mergeAvailable(vectors, tiles) {
    for (var i in vectors) {
        var lastTileNumber = undefined;
        var vector = vectors[i];
        for (var j in vector) {
            var index = vector[j];
            var tile = tiles[index];
            if (lastTileNumber !== undefined && lastTileNumber === tile.value) {
                return true;
            }
            else {
                lastTileNumber = tile.value;
            }
        }
    }
    return false;
}
