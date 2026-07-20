-- motor: sqlite3
-- Roteiro idempotente: pode ser executado várias vezes seguidas,
-- pois cada tabela é descartada (se existir) antes de ser recriada.

DROP TABLE IF EXISTS Artists;
CREATE TABLE Artists(
  artist_id   INTEGER PRIMARY KEY,
  artist_name TEXT NOT NULL
);

INSERT INTO Artists (artist_name) VALUES
('Ana'),
('Bob'),
('Carl');

DROP TABLE IF EXISTS Albums;
CREATE TABLE Albums(
  album_id   INTEGER PRIMARY KEY,
  album_name TEXT NOT NULL,
  artist_id INTEGER,
  FOREIGN KEY(artist_id) REFERENCES Artists(artist_id)
);

INSERT INTO Albums (album_name, artist_id) VALUES
('Analog', 1),
('Brown', 2),
('Carpinter', 3);

DROP TABLE IF EXISTS Tracks;
CREATE TABLE Tracks(
  track_id     INTEGER PRIMARY KEY,
  track_name   TEXT NOT NULL,
  album_id  INTEGER,
  FOREIGN KEY(album_id) REFERENCES Albums(album_id)
);

INSERT INTO Tracks (track_name, album_id) VALUES
('Antog', 1),
('Block', 1),
('CollorRed', 2),
('DataLog', 2),
('Elephant', 3),
('Factorial', 3);
