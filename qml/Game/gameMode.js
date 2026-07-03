function addTiles(number, tiles, tileGrid, size, tileComponent, getValue, tilesCount) {
    var freeSpace = Helper.getFreeSpace(tiles, tileGrid)
    number = Math.min(number, freeSpace.length);
    for (var i = 0; i < number; i++) {
        var random = Math.floor(Math.random() * freeSpace.length);
        var index = freeSpace[random];
        if (tiles [index] === undefined) {
            tiles [index] = tileComponent.createObject (tileGrid.getSlot(index), {value: getValue()});
            tilesCount[ tiles[index].value ] = tilesCount[ tiles[index].value ] !== undefined ? tilesCount[ tiles[index].value ] + 1 : 1;
            console.debug(JSON.stringify(tilesCount));
        }
    }
}

function addTilesClassicEasy (number, tiles, tileGrid, size, tileComponent, tilesCount) {
    var getValue = function () { return 2 }
    addTiles(number, tiles, tileGrid, size, tileComponent, getValue, tilesCount);
}

function addTilesClassicNormal (number, tiles, tileGrid, size, tileComponent, tilesCount) {
    var getValue = function () { return Math.random() < 0.9 ? 2 : 4; }
    addTiles(number, tiles, tileGrid, size, tileComponent, getValue, tilesCount);
}

function addTilesClassicHard (number, tiles, tileGrid, size, tileComponent, tilesCount) {
    var getValue = function () {
        var rand = Math.random();
        return rand < 0.6 ? 2 : rand < 0.9 ? 4 : 8;
    }
    addTiles(number, tiles, tileGrid, size, tileComponent, getValue, tilesCount);
}

function addTilesAdventureNormal (number, tiles, tileGrid, size, tileComponent, tilesCount) {
    var getValue = function () {
        var howManyBrick = tilesCount["-10"] !== undefined ? tilesCount["-10"] : 0;
        var brickChance =  howManyBrick < size - 3 ? 1/30 : 0;
        var jokerChance = 1/30;
        var fourChance  = 1/10;
        var bombChance  = 0;
        var rand = Math.random();
        return rand < brickChance ? -10 :
               rand < brickChance + jokerChance ? 1 :
               rand < brickChance + jokerChance + bombChance ? -4 :
               rand < brickChance + jokerChance + bombChance + fourChance ? 4 : 2;
    }
    addTiles(number, tiles, tileGrid, size, tileComponent, getValue, tilesCount);
}
