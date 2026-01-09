import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import ".."
import "../storage.js" as Storage;

Page {
    id: page;

    Column {
        spacing: 10;
        anchors.fill: parent;

        PageHeader {
            title: "Change Mode"
        }
        Setting {
            text: "Difficulty : " + app.difficulty;
            options: [
                ["Easy", function () {app.game.save(); app.difficulty = "Easy";}],
                ["Normal", function () {app.game.save(); app.difficulty = "Normal";}],
                ["Hard", function () {app.game.save(); app.difficulty = "Hard";}],
            ]
        }

        /*Setting {
            text: "Mode : " + app.mode;
            options: [
                ["Classic", function () {app.game.save(); app.mode = "Classic";}],
                ["Adventure", function () {app.game.save(); app.mode = "Adventure";}],
            ]
        }*/
        Setting {
            text: "Format : " + app.tileFormat;
            options: [
                ["TetraTile", function () {app.game.save(); app.tileFormat = "TetraTile";}],
                ["HexaTile", function () {app.game.save(); app.tileFormat = "HexaTile";}],
            ]
        }
        Setting {
            text: "Size : " + app.size;
            options: [
                ["2", function () {app.game.save(); app.size = 2}],
                ["3", function () {app.game.save(); app.size = 3}],
                ["4", function () {app.game.save(); app.size = 4}],
                ["5", function () {app.game.save(); app.size = 5}],
                ["6", function () {app.game.save(); app.size = 6}],
            ]
        }
    }
}
