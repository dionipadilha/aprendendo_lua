-- insert_musics.sql
-- engine: sqlite3

INSERT INTO Artists (artist_name) VALUES
('Ana'),
('Bob'),
('Carl');

INSERT INTO Albums (album_name, artist_id) VALUES
('Analog', 1),
('Brown', 2),
('Carpinter', 3);

INSERT INTO Tracks (track_name, album_id) VALUES
('Antog', 1),
('Block', 1),
('CollorRed', 2),
('DataLog', 2),
('Elephant', 3),
('Factorial', 3);

SELECT * FROM Tracks;
