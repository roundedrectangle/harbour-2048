import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "pages";
import "cover";
import "storage.js" as Storage;

ApplicationWindow {
    id: app;
    cover: Component { CoverPage { } }
    initialPage: Component { MainPage { } }

    Component.onCompleted: {
        Storage.initialize();

        var size       = Storage.getLabel ("size");
        var tileFormat = Storage.getLabel ("tileFormat");
        var difficulty = Storage.getLabel ("difficulty");
        var mode       = Storage.getLabel ("mode");
        var score      = Storage.getLabel ("score");

        if (size)       { app.size       = size; }
        if (tileFormat) { app.tileFormat = tileFormat }
        if (difficulty) { app.difficulty = difficulty; }
        if (mode)       { app.mode       = mode; }
        if (score)      { app.score      = score; }

        var bestBestTile      = Storage.getLabel ("bestBestTile" + app.mode + app.difficulty + app.size);
        var bestClassicScore  = Storage.getLabel ("bestClassicScore" + app.mode + app.difficulty + app.size);
        var bestMoves         = Storage.getLabel ("bestMoves" + app.mode + app.difficulty + app.size);
        var bestImprovedScore = Storage.getLabel ("bestImprovedScore" + app.mode + app.difficulty + app.size);

        if (bestBestTile)      { app.bestBestTile      = bestBestTile; }
        if (bestClassicScore)  { app.bestClassicScore  = bestClassicScore; }
        if (bestMoves)         { app.bestMoves         = bestMoves; }
        if (bestImprovedScore) { app.bestImprovedScore = bestImprovedScore; }
        app.mode = "Classic";
    }

    Component.onDestruction: {
        game.save();
        Storage.setLabel ("size",       app.size);
        Storage.setLabel ("tileFormat", app.tileFormat);
        Storage.setLabel ("difficulty", app.difficulty);
        Storage.setLabel ("mode",       app.mode);
        Storage.setLabel ("score",      app.score);
    }

    property int size           : 4;
    property string difficulty  : "Normal";
    property string mode        : "Classic";
    property string tileFormat  : "TetraTile"
    property int blizt          : 0;
    property Item game          : null;
    property int score          : 0;

    property int bestBestTile      : 2;
    property int bestClassicScore  : 0;
    property int bestMoves         : 0;
    property int bestImprovedScore : 0;
}
