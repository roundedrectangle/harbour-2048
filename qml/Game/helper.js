function getVectors(size, getIndex) {
    var vectors = []
    for (var i = 0; i < size; i++) {
        var vector = []
        for (var j = 0; j < size; j++)
            vector.push(getIndex(i, j, size))
        vectors.push(vector)
    }
    return vectors
}

var vectorFactories = {
    left: function(i, j, size) { return i*size + j },
    right: function(i, j, size) { return (i + 1) * size - j - 1 },
    top: function(i, j, size) { return j * size + i },
    bottom: function(i, j, size) { return (size - j - 1) * size + i }
}

function getHexaVectors(size, getIndex, reverse) {
    var vectors = []
    var maxLength = 2 * size - 1
    var doubleSize = maxLength + 1

    for (var i = 0; i < maxLength; i++) {
        var vector = []
        var isTop = i < size // is top half
        var lineLength = size + (isTop ? i : doubleSize - 2 - i)

        var first, variation, adjustement

        for (var j = 0; j < lineLength; j++)
            vector.push(getIndex(i, j, {size: size, maxLength: maxLength, doubleSize: doubleSize, isTop: isTop, lineLength: lineLength}))

        vectors.push(reverse ? vector.reverse() : vector)
    }
    return vectors
}

function getLeftHexaVectors(size) {
    return getHexaVectors(size, function(i, j, data) { return i * data.maxLength + j })
}
function getRightHexaVectors(size) {
    return getHexaVectors(size, function(i, j, data) { return i * data.maxLength + data.lineLength - j - 1 })
}

function getHexaVAdjustment(i, j, data) {
    var size = data.size, isTop = data.isTop, doubleSize = data.doubleSize
    return isTop && j >= size ? j - size + 1 : (!isTop && j + i + 1 >= doubleSize ? j + i - doubleSize + 2 : 0)
}

function upLeftHexaVectorsFactory(i, j, data) {
    var first = data.isTop ? data.size - 1 - i : (i - data.size + 1) * data.maxLength
    var variation = j * data.doubleSize
    return first + variation - getHexaVAdjustment(i, j, data)
}

function getUpLeftHexaVectors(size) { return getHexaVectors(size, upLeftHexaVectorsFactory) }
function getDownRightHexaVectors(size) { return getHexaVectors(size, upLeftHexaVectorsFactory, true) }

function upRightHexaVectorsFactory(i, j, data) {
    var first = data.isTop ? i : data.size - 1 + (i - data.size + 1) * data.doubleSize
    var variation = j * data.maxLength
    return first + variation - getHexaVAdjustment(i, j, data)
}

function getUpRightHexaVectors(size) { return getHexaVectors(size, upRightHexaVectorsFactory) }
function getDownLeftHexaVectors(size) { return getHexaVectors(size, upRightHexaVectorsFactory, true) }


function dealWithVectors(size, tileGrid, vectors, tiles) {
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
                tile.moveTo (tileGrid.getSlot(lastTileIndex), lastTile)
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
                    tile.moveTo (tileGrid.getSlot(newIndex))
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

function getFreeSpace(tiles, tileGrid) {
    var freeSpace = []
    for (var i = 0; i < tileGrid.slotCount; i++)
        if (tileGrid.getSlot(i) && !tiles[i])
            freeSpace.push(i)
    return freeSpace
}

function mergeAvailable(vectors, tiles) {
    for (var i in vectors) {
        var lastTileNumber
        var vector = vectors[i];
        for (var j in vector) {
            var tile = tiles[vector[j]]
            if (!tile)
                continue
            if (lastTileNumber && lastTileNumber === tile.value)
                return true
            else
                lastTileNumber = tile.value
        }
    }
    return false
}
