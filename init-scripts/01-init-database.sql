-- ============================================================================
-- DATA1500 - Oblig 1: Arbeidskrav I våren 2026
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- ======================
-- Opprett tabeller
-- ======================

CREATE TABLE Stasjon (
    stasjon_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kapasitet INT CHECK (kapasitet > 0)
);

CREATE TABLE Sykkel (
    sykkel_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY
);

CREATE TABLE Lås (
    lås_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    stasjon_id INT REFERENCES Stasjon(stasjon_id),
    sykkel_id INT REFERENCES Sykkel(sykkel_id)
);

CREATE TABLE Kunde (
    kunde_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    mobilnr VARCHAR(20) UNIQUE,
    epost VARCHAR(255) UNIQUE,
    fornavn VARCHAR(50),
    etternavn VARCHAR(50)
);

CREATE TABLE Utleie (
    utleie_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sykkel_id INT REFERENCES Sykkel(sykkel_id),
    kunde_id INT REFERENCES Kunde(kunde_id),
    tid_ut TIMESTAMP DEFAULT NOW(),
    tid_inn TIMESTAMP
);

-- ======================
-- Sett inn testdata
-- ======================

-- 5 stasjoner
INSERT INTO Stasjon (kapasitet)
SELECT 20
FROM generate_series(1,5);

-- 100 sykler (identity genereres automatisk)
INSERT INTO Sykkel
SELECT
FROM generate_series(1,100);

-- 20 låser per stasjon = 100 låser
INSERT INTO Lås (stasjon_id)
SELECT s.stasjon_id
FROM Stasjon s,
generate_series(1,20);

-- 5 kunder
INSERT INTO Kunde (mobilnr, epost, fornavn, etternavn) VALUES
('4711111111','ola@example.com','Ola','Nordmann'),
('4722222222','kari@example.com','Kari','Nordmann'),
('4733333333','per@example.com','Per','Hansen'),
('4744444444','anne@example.com','Anne','Olsen'),
('4755555555','lars@example.com','Lars','Johansen');

-- 50 utleier med tilfeldig data
INSERT INTO Utleie (sykkel_id, kunde_id, tid_ut, tid_inn)
SELECT
    (random()*99 + 1)::int,
    (random()*4 + 1)::int,
    NOW() - random()*interval '10 days',
    NOW() - random()*interval '5 days'
FROM generate_series(1,50);

-- ======================
-- Bekreftelse
-- ======================

SELECT 'Database initialisert!' AS status;
