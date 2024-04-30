-- music_library.sql
-- engine: sqlite3

CREATE TABLE Artists(
  artist_id   INTEGER PRIMARY KEY,
  artist_name TEXT NOT NULL
);

CREATE TABLE Albums(
  album_id   INTEGER PRIMARY KEY,
  album_name TEXT NOT NULL,
  artist_id INTEGER,
  FOREIGN KEY(artist_id) REFERENCES Artists(artist_id)
);

CREATE TABLE Tracks(
  track_id     INTEGER PRIMARY KEY,
  track_name   TEXT NOT NULL,
  album_id  INTEGER,
  FOREIGN KEY(album_id) REFERENCES Albums(album_id)
);
