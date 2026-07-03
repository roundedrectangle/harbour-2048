# KibiTiles

KibiTiles is a 2048 clone for SailfishOS.

# Migrating data

Automatic data migration from the pre-3.0 version is not possible due to Sailjail. To make the process easier, a migration script is included with the app. To use it, open the Terminal application, and run the following command:

```bash
python3 /usr/share/harbour-2048/migrate.py
```

If you'd like to also delete the old data after migrating, use the `-d` flag:

```bash
python3 /usr/share/harbour-2048/migrate.py -d
```

# Credits

- BlueMagma for the original application
- roundedrectangle: the current maintainer