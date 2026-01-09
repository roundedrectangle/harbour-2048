
function getDatabase() {
    return LocalStorage.openDatabaseSync("harbour-2048", "1.0", "StorageDatabase", 100000);
}

function initialize() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS memory(label TEXT UNIQUE, value TEXT)');
                });
}

function setLabel(label, value) {
    var db = getDatabase();
    var ret = false;
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO memory VALUES (?,?);', [label,value]);
        if (rs.rowsAffected > 0) {
            ret = true;
        }
        else {
            ret = false;
        }
    }
    );
    return ret;
}

function getLabel(label) {
    var db = getDatabase();
    var ret = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT value FROM memory WHERE label=?;', [label]);
        if (rs.rows.length > 0) {
            ret = rs.rows.item(0).value;
        } else {
            ret = "";
        }
    })
    return ret;
}

function destroyData() {
    var db = getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('DROP TABLE memory');
    });
}
