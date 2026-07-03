import sys
from pathlib import Path
import sqlite3
import subprocess
from argparse import ArgumentParser
import shutil

DCONF_PATH = '/apps/harbour-2048/'

CONTEXT_MAP = {}
for old_keys in [
    ['Classic', 'Adventure'],
    ['Easy', 'Normal', 'Hard'],
    ['TetraTile', 'HexaTile']
]:
    CONTEXT_MAP.update({x: str(i) for i, x in enumerate(old_keys)})

parser = ArgumentParser(description="Migrate pre-3.0 KibiTiles data")
parser.add_argument('-d', '--delete', action='store_true', help="Delete the old database after migrating")
args = parser.parse_args()

app_data_path = Path.home() / '.local/share/harbour-2048/harbour-2048'
if not app_data_path.exists():
    sys.exit("App data path doesn't exist!")

databases = app_data_path / 'QML/OfflineStorage/Databases'
if not databases.exists():
    sys.exit("Databases path doesn't exist!")

database = next(databases.rglob('*.sqlite'), None)
if not database:
    sys.exit("Database doesn't exist!")


con = sqlite3.connect(database)

def replace_last(s: str, old: str, new: str):
    if old not in s:
        return s
    start, _, end = s.rpartition(old)
    return start + new + end

try:
    for key, value in con.execute('SELECT label,value FROM memory'):
        key: str
        value: str

        new_key = key
        new_value = value
        for old_part, new_part in CONTEXT_MAP.items():
            new_key = replace_last(new_key, old_part, f':{new_part}:')
            if new_value == old_part:
                new_value = new_part

        try:
            new_value = str(int(new_value))
        except ValueError:
            new_value = repr(new_value)

        new_key = new_key.strip(':').replace('::', ':')
        parts_count = new_key.count(':')
        if parts_count > 0:
            if parts_count < 4:
                new_key += '/state'
            else:
                parts = new_key.split(':')
                new_key = ':'.join(parts[1:]) + f'/{parts[0]}'

        print("Writing:", new_key, "=", new_value, f"({key} = {value})")
        subprocess.run(['dconf', 'write', DCONF_PATH + new_key, new_value], check=True)
finally:
    con.close()


if args.delete:
    print("Deleting the old database file")
    shutil.rmtree(app_data_path)
