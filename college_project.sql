/* Napisati upite za kreiranje baze podataka pod nazivom Video klub, sa strukturom tabela
koja odgovara datoj relacionoj šemi. Prilikom definisanja stranih ključeva definisati akcije u
slučaju izmene i brisanja u međusobno povezanih tabelama.
/
Write queries to create a database called Video Club, with a table structure 
which corresponds to a given relational schema. When defining foreign keys, define actions in
in case of modification and deletion in interconnected tables. */

create database VIDEO_KLUB;
use VIDEO_KLUB;

create table Klijent ( --customer table
IDklijent int auto_increment not null primary key, 
ime varchar(20) not null, 
prezime varchar(20) not null
);
desc Klijent;

create table Kopija ( --movie copy table
IDkopija int auto_increment not null primary key, 
IDfilm int not null,
FOREIGN KEY (IDfilm) REFERENCES Film(IDfilm)
ON DELETE CASCADE
ON UPDATE CASCADE
);
desc Kopija;

create table Film ( --movie table
IDfilm int auto_increment not null primary key, 
ime varchar(50) not null, 
duzina_trajanja int not null
);
desc Film;

create table Distributer ( --distributor table
IDdistributer int auto_increment not null primary key, 
naziv varchar(20) not null, 
grad varchar(20) not null
);
desc Distributer;

create table Nabavka_filma ( --getting movie table
IDnabavka int auto_increment not null primary key, 
IDdistributer int not null, 
IDfilm int not null,
cena int not null,
broj_kopija int not null,
FOREIGN KEY (IDdistributer) REFERENCES Distributer(IDdistributer)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (IDfilm) REFERENCES Film(IDfilm)
ON DELETE CASCADE
ON UPDATE CASCADE
);
desc Nabavka_filma;

create table Pozajmica ( --loan table
IDklijent int not null, 
IDkopija int not null, 
datum date not null primary key,
broj_dana int not null,
FOREIGN KEY (IDklijent) REFERENCES Klijent(IDklijent)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (IDkopija) REFERENCES Kopija(IDkopija)
ON DELETE CASCADE
ON UPDATE CASCADE
);
desc Pozajmica;

-- 1) Za svaku od tabela uneti po 10 podataka. / Enter 10 pieces of data for each of the tables.

insert into Klijent (IDklijent, ime, prezime) values
(1, 'Milos','Peric'),
(2, 'Marijana','Savkovic'),
(3, 'Sanja','Terzic'),
(4, 'Nikola','Vukovic'),
(5, 'Marijana','Savkovic'),
(6, 'Zorica','Miladinovic'),
(7, 'Milena','Stankovic'),
(8, 'Danilo','Bojkovic'),
(9, 'Lazar','Bulatovic'),
(10, 'Nenad','Stankovic');

select * from Klijent;

insert into Film (IDfilm, ime, duzina_trajanja) values
(1, 'Fast and Furious 7', 120),
(2, 'Top Gun', 137),
(3, 'No Time to Die', 163),
(4, 'John Wick', 101),
(5, 'Avengers', 143),
(6, 'Venom', 140),
(7, 'Ice Age', 81),
(8, 'Superman 2', 127),
(9, 'A Family Portrait', 106),
(10, 'Godzilla', 123);

select * from Film;

insert into Distributer(IDdistributer, naziv, grad) values
(1, 'Lionsgate', 'Santa Monica'),
(2, '20th Century Fox', 'Los Angeles'),
(3, 'Warner Bros', 'Los Angeles'),
(4, 'Film London', 'London'),
(5, 'Toho Company', 'Tokio'),
(6, 'Paramount Pictures', 'Los Angeles'),
(7, 'Metro-Goldwyn-Mayer', 'Los Angeles'),
(8, 'Universal Pictures', 'Universal City'),
(9, 'Walt Disney Studios', 'Burbank'),
(10, 'Sony Pictures', 'Culver City');

select * from Distributer;

insert into Kopija (IDkopija, IDfilm) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

select * from Kopija;

insert into Nabavka_filma (IDnabavka, IDdistributer, IDfilm, cena, broj_kopija) values
(1, 8, 1, 300, 9),
(2, 2, 7, 250, 13),
(3, 7, 3, 700, 0),
(4, 10, 6, 550, 3),
(5, 1, 4, 450, 7),
(6, 3, 8, 150, 10),
(7, 9, 5, 400, 6),
(8, 6, 2, 750, 1),
(9, 4, 9, 200, 2),
(10, 5, 10, 300, 8);

select * from Nabavka_filma;

insert into  Pozajmica (IDklijent, IDkopija, datum, broj_dana) values
(1, 6, '2022-05-25', 3),
(2, 8, '2022-05-14', 1),
(3, 5, '2022-05-22', 2),
(4, 1, '2022-05-18', 4),
(5, 3, '2022-05-28', 2),
(6, 2, '2022-05-13', 1),
(7, 4, '2022-05-21', 5),
(8, 10, '2022-05-04', 3),
(9, 7, '2022-05-10', 1),
(10, 9, '2022-05-07', 3);

select * from Pozajmica;

-- 2) Naći imena filmova koji su nabavljeni od distributera 'Universal Pictures' ili '20th Century Fox'. Ispisati imena filmova.
-- / Find names of the movies that have been acquired from distributors 'Universal Pictures' or '20th Century Fox'. Print movie names.

CREATE OR REPLACE VIEW film_view AS
SELECT IDdistributer from Distributer
WHERE naziv in ('Universal Pictures', '20th Century Fox');
CREATE OR REPLACE VIEW filmid_view AS
SELECT IDfilm from Nabavka_filma, film_view
WHERE Nabavka_filma.IDdistributer = film_view.IDdistributer;
SELECT ime from film, filmid_view
WHERE Film.IDfilm = filmid_view.IDfilm;

-- 3) Naći kopiju filma koji je klijent najduže pozajmio. Ispisati naziv filma, kao i period.
-- / Find the copy of the movie that the client has borrowed the longest. Write the name of the movie, as well as the period of time.

CREATE OR REPLACE VIEW pozajmica_view AS
SELECT max(broj_dana) AS broj_dana
from Pozajmica;
CREATE OR REPLACE VIEW pozajmicaid_view AS
SELECT IDkopija from Pozajmica, pozajmica_view
WHERE pozajmica_view.broj_dana = pozajmica.broj_dana;
SELECT Film.ime, pozajmica_view.broj_dana
FROM Film, pozajmica_view, pozajmicaid_view
WHERE pozajmicaid_view.IDkopija = Film.IDfilm;


--4) Naći sve filmove za koje postoji nabavka filma od 4 ili više kopija. / Find all movies for which there is a film purchase of 4 or more copies.

CREATE OR REPLACE VIEW nabavka_view AS
SELECT IDfilm from Nabavka_filma
WHERE broj_kopija >= 4;
SELECT ime
from Film, nabavka_view
WHERE nabavka_view.IDfilm = Film.IDfilm;


-- 5) Naći klijenta koji je pozajmio film 'Supermen 2'. Ispisati ime i prezime klijenta.
-- / Find a customer who borrowed the movie 'Superman 2'. Write the name and surname of the client.

CREATE OR REPLACE VIEW superman_view AS
SELECT IDfilm from Film
WHERE ime = 'Superman 2';
CREATE OR REPLACE VIEW supermankopija_view AS
SELECT IDkopija from Kopija, superman_view
WHERE superman_view.IDfilm = Kopija.IDkopija;
CREATE OR REPLACE VIEW supermanpozajmica_view AS
SELECT IDklijent from Pozajmica, supermankopija_view
WHERE supermankopija_view.IDkopija = Pozajmica.IDkopija;
SELECT ime, prezime from Klijent, supermanpozajmica_view
WHERE supermanpozajmica_view.IDklijent = Klijent.IDklijent;


-- 6) Naći klijenta koji je iznajmio film na duže od 4 dana. / Find a customer who rented a movie for more than 4 days.

CREATE OR REPLACE VIEW duzeod4dana_view AS
SELECT IDklijent from Pozajmica
WHERE broj_dana > 4;
SELECT ime, prezime from Klijent, duzeod4dana_view
WHERE duzeod4dana_view.IDklijent = Klijent.IDklijent;


-- 7) Naći sve filmove za koje ne postoji ni jedna kopija. / Find all movies for which no copy exists.

CREATE OR REPLACE VIEW 0kopija_view AS
SELECT IDfilm from Nabavka_filma
WHERE broj_kopija = 0;
SELECT ime from Film, 0kopija_view
WHERE 0kopija_view.IDfilm = Film.IDfilm;


-- 8) Naći broj distributera iz Londona. / Find the number of distributors from London.

SELECT COUNT(*) from Distributer
WHERE grad = 'London';


-- 9) Zbog greške prilikom unosa podataka, promeniti dužinu filma 'Paklene ulice 7' na 137min.
-- / Due to an error during data entry, change the length of the movie 'Fast and Furious 7' to 137 min.

update Film
set duzina_trajanja = 137
WHERE ime = 'Fast and Furious 7';


-- 10) Obrisati sve informacije o nabavci filmova, za sve distributere iz Tokija. / Clear all film acquisition information for all Tokyo distributors.

delete from Nabavka_filma
where IDdistributer in (
select IDdistributer 
from Distributer
where grad = 'Tokio');