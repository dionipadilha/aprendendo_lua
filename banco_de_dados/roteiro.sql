-- motor: sqlite3
-- Roteiro idempotente: pode ser executado várias vezes seguidas,
-- pois cada tabela é descartada (se existir) antes de ser recriada.

-- O SQLite NÃO aplica FOREIGN KEY por padrão: a verificação é opt-in e
-- vale POR CONEXÃO (PRAGMA abaixo). Sem ele, as FKs declaradas adiante
-- seriam só documentação — um INSERT órfão (ex.: faixa apontando para um
-- album_id inexistente) seria aceito sem erro.
PRAGMA foreign_keys = ON;

-- Com as FKs ativas, a ordem dos DROPs importa: as tabelas-filhas
-- (Tracks, Albums) caem antes das tabelas-pais que elas referenciam.
DROP TABLE IF EXISTS Tracks;
DROP TABLE IF EXISTS Albums;
DROP TABLE IF EXISTS Artists;

CREATE TABLE Artists(
  artist_id   INTEGER PRIMARY KEY,
  artist_name TEXT NOT NULL
);

INSERT INTO Artists (artist_name) VALUES
('Ana'),
('Bob'),
('Carl');

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
