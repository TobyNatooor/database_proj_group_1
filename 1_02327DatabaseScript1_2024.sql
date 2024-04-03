DROP DATABASE IF EXISTS dkavisendb;
CREATE DATABASE dkavisendb;
USE dkavisendb;

DROP TABLE IF EXISTS Journalist;
DROP TABLE IF EXISTS NewsPaper;
DROP TABLE IF EXISTS Edition;
DROP TABLE IF EXISTS Article;
DROP TABLE IF EXISTS Photo;
DROP TABLE IF EXISTS IncludeesPhoto;
DROP TABLE IF EXISTS Writer;
DROP TABLE IF EXISTS Phone;
DROP TABLE IF EXISTS Email;

CREATE TABLE Journalist (
	CPR				DECIMAL(10,0),
	FirstName		VARCHAR(60),
    LastName		VARCHAR(60),
	StreetName		VARCHAR(60),
    StreetNumber	VARCHAR(60),
    ZipCode			VARCHAR(60),
    Country			VARCHAR(60),
    PRIMARY KEY(CPR)
);

CREATE TABLE Email (
	CPR				DECIMAL(10,0),
    Email			VARCHAR(60),
    PRIMARY KEY(Email),
    FOREIGN KEY(CPR) REFERENCES Journalist(CPR) -- ON DELETE CASCADE
);

CREATE TABLE Phone (
	CPR				DECIMAL(10,0),
    PhoneNr			VARCHAR(60),
    PRIMARY KEY(PhoneNr),
    FOREIGN KEY(CPR) REFERENCES Journalist(CPR) -- ON DELETE CASCADE
);

CREATE TABLE Newspaper (
	NewspaperTitle	VARCHAR(60),
    Founded			DATE,
    Periodicity		enum('DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY'),
    PRIMARY KEY(NewspaperTitle)
);

CREATE TABLE Edition (
	Published		Date,
    NewspaperTitle	varchar(60),
    Editor			DECIMAL(10,0),
    primary key (Published, NewspaperTitle),
    foreign key (NewspaperTitle) references Newspaper(NewspaperTitle),
    foreign key (Editor) references Journalist(CPR)
);

CREATE TABLE Article (
	ArticleTitle	VARCHAR(60),
    ContentText		TEXT,
    Topic			ENUM('SPORTS','CULTURE','POLITICS','INTERNATIONAL','LOCAL'),
	NrOfReaders		DECIMAL(10,0),
    Published		DATE,
    NewspaperTitle	VARCHAR(60),
    PRIMARY KEY(ArticleTitle),
    FOREIGN KEY(Published) REFERENCES Edition(Published),
    FOREIGN KEY(NewspaperTitle) REFERENCES Newspaper(NewspaperTitle)
);

CREATE TABLE Photo (
	PhotoTitle		VARCHAR(60),
    PhotoDate		DATE,
    Reporter		DECIMAL(10,0),
    PRIMARY KEY(PhotoTitle),
    FOREIGN KEY(Reporter) REFERENCES Journalist(CPR)
);

CREATE TABLE IncludesPhoto (
	PhotoTitle		VARCHAR(60),
    ArticleTitle	VARCHAR(60),
    PRIMARY KEY(Phototitle, ArticleTitle),
    FOREIGN KEY(PhotoTitle) REFERENCES Photo(PhotoTitle),
    FOREIGN KEY(ArticleTitle) REFERENCES Article(ArticleTitle)
);

CREATE TABLE Writer (
	ArticleTitle	VARCHAR(60),
    Writer			DECIMAL(10,0),
    WritingRole		ENUM('LEADER', 'ADVISOR'),
    PRIMARY KEY(ArticleTitle, Writer, WritingRole),
    FOREIGN KEY(ArticleTitle) REFERENCES Article(ArticleTitle),
    FOREIGN KEY(Writer) REFERENCES Journalist(CPR)
);

CREATE VIEW ContainsArticle AS
SELECT NewspaperTitle, Published, ArticleTitle FROM Article
WHERE Published != null;

INSERT INTO Journalist (CPR, FirstName, LastName, StreetName, StreetNumber, ZipCode, Country) VALUES 
(1234567890, "Mette", "Frederiksen", "Birkebakken", "12", "3460", "Denmark"),
(9438259242, "John", "Doe", "Prospect Street", "62", "32401", "China"),
(1047395734, "Jane", "Doe", "Airplane Avenue", "97", "654195", "Chad"),
(4953710423, "Bob", "Ross", "Main Street", "123", "55406", "America"),
(0684353941, "Barack", "Obama", "Wall Street", "83", "22980", "America"),
(2837465921, "Alice", "Smith", "Oak Street", "45", "90210", "USA"),
(3847562901, "David", "Johnson", "Elm Avenue", "32", "10001", "USA"),
(4738291056, "Maria", "Garcia", "Maple Road", "78", "60601", "USA"),
(5738192046, "Mohammed", "Ali", "Cedar Lane", "21", "90001", "USA"),
(6829103847, "Liu", "Wei", "Pine Street", "56", "20001", "China");

INSERT INTO Email (CPR, Email) VALUES 
(1234567890, "MetteF@gmail.com"),
(9438259242, "JD@hotmail.com"),
(1047395734, "voros78310@felibg.com"),
(1047395734, "1234asdzx@felibg.com"),
(4953710423, "Paint4Life@hotmail.com"),
(0684353941, "NotPresident@gmail.com"),
(2837465921, "alice.smith@example.com"),
(3847562901, "david.johnson@example.com"),
(4738291056, "maria.garcia@example.com"),
(5738192046, "mohammed.ali@example.com"),
(6829103847, "liu.wei@example.com");

INSERT INTO Phone (CPR, PhoneNr) VALUES 
(1234567890, 47395734),
(1234567890, 12354313),
(9438259242, 30485731),
(1047395734, 42843713),
(4953710423, 04853472),
(0684353941, 49244567),
(2837465921, 12345678),
(3847562901, 23456789),
(4738291056, 34567890),
(5738192046, 45678901),
(6829103847, 56789012);

INSERT INTO Newspaper (NewspaperTitle, Founded, Periodicity) VALUES 
("The world is doing great, NOT!", date("2010-01-12"), 'DAILY'),
("Barack Obama is not the president", date("2000-11-22"), 'WEEKLY'),
("It's too late to fix climate change", date("2003-01-03"), 'MONTHLY'),
("The Daily Reporter", date("2015-05-20"), 'DAILY'),
("Weekly Gazette", date("2008-09-12"), 'WEEKLY'),
("Monthly Digest", date("2010-11-30"), 'MONTHLY');

INSERT INTO Photo (PhotoTitle, PhotoDate, Reporter) VALUES
('UFO Sighting', date("2024-03-31"), 1234567890),
('Unicorn Cupcakes', date("2024-03-30"), 1047395734),
('Bitcoin Surge', date("2024-03-29"), 0684353941),
('Cityscape at Night', date("2024-03-15"), 2837465921),
('Fashion Show Highlights', date("2024-03-14"), 3847562901),
('Wildlife Safari Adventure', date("2024-03-13"), 4738291056);

INSERT INTO Edition (Published, NewspaperTitle, Editor) VALUES
(date("2021-03-11"), "The world is doing great, NOT!", 1234567890),
(date("2001-04-11"), "Barack Obama is not the president", 9438259242),
(date("2019-03-31"), "It's too late to fix climate change", 0684353941),
(date("2023-03-15"), "The Daily Reporter", 2837465921),
(date("2023-03-14"), "Weekly Gazette", 3847562901),
(date("2023-03-13"), "Monthly Digest", 4738291056);

INSERT INTO Article (ArticleTitle, ContentText, Topic, NrOfReaders, Published, NewspaperTitle) VALUES
('Breaking News: Alien Invasion', 'Extraterrestrial beings spotted near Area 51.', 'SPORTS', 12345, date("2021-03-11"), "The world is doing great, NOT!"),
('Recipe: Unicorn Cupcakes', 'Learn how to bake magical cupcakes with rainbow frosting.', 'CULTURE', 9876, date("2001-04-11"), "Barack Obama is not the president"),
('Crypto Market Update', 'Bitcoin hits an all-time high, altcoins follow suit.', 'POLITICS', 54321, date("2019-03-31"), "It's too late to fix climate change"),
('Local Hero Wins Marathon', 'John Doe from our community emerges victorious in the annual marathon.', 'LOCAL', 10000, date("2023-03-15"), "The Daily Reporter"),
('Interview with a Celebrity Chef', 'Exclusive interview with Chef Gordon Ramsay on his new restaurant venture.', 'CULTURE', 15000, date("2023-03-14"), "Weekly Gazette"),
('Political Unrest in the Middle East', 'Insights into the ongoing conflicts and diplomatic efforts in the region.', 'INTERNATIONAL', 20000, date("2023-03-13"), "Monthly Digest"),
('New Study on Climate Change', 'Researchers reveal alarming findings on the accelerating effects of climate change.', 'POLITICS', 25000, date("2023-03-13"), "Monthly Digest"),
('Tech Giants Face Antitrust Probe', 'Government launches investigation into possible monopolistic practices by leading technology companies.', 'INTERNATIONAL', 18000, date("2023-03-14"), "Weekly Gazette"),
('Health Benefits of Meditation', 'Experts discuss the positive impact of meditation on mental and physical well-being.', 'CULTURE', 22000, date("2023-03-15"), "The Daily Reporter"),
('Sports Team Clinches Championship Victory', 'Exciting match recap as the hometown team secures the championship title.', 'SPORTS', 30000, date("2023-03-15"), "The Daily Reporter"),
('Art Exhibition Showcases Local Talent', 'Review of the latest art exhibit featuring works by emerging artists in the community.', 'CULTURE', 15001, date("2023-03-13"), "Monthly Digest");


INSERT INTO IncludesPhoto (PhotoTitle, ArticleTitle) VALUES
('UFO Sighting', 'Breaking News: Alien Invasion'),
('Unicorn Cupcakes', 'Recipe: Unicorn Cupcakes'),
('Bitcoin Surge', 'Crypto Market Update'),
('Cityscape at Night', 'Local Hero Wins Marathon'),
('Fashion Show Highlights', 'Interview with a Celebrity Chef'),
('Wildlife Safari Adventure', 'Political Unrest in the Middle East');

INSERT INTO Writer (ArticleTitle, Writer, WritingRole) VALUES
('Breaking News: Alien Invasion', 4953710423, 'LEADER'),
('Recipe: Unicorn Cupcakes', 0684353941, 'ADVISOR'),
('Crypto Market Update', 1047395734, 'LEADER'),
('Local Hero Wins Marathon', 6829103847, 'LEADER'),
('Interview with a Celebrity Chef', 5738192046, 'ADVISOR'),
('Political Unrest in the Middle East', 2837465921, 'LEADER');
