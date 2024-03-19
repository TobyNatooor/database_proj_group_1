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
	CPR				VARCHAR(10),
	FirstName		VARCHAR(60),
    LastName		VARCHAR(60),
	StreetName		VARCHAR(60),
    StreetNumber	VARCHAR(60),
    ZipCode			VARCHAR(60),
    Country			VARCHAR(60),
    PRIMARY KEY(CPR)
);

CREATE TABLE Email (
	CPR				VARCHAR(10),
    Email			VARCHAR(60),
    PRIMARY KEY(Email),
    FOREIGN KEY(CPR) REFERENCES Journalist(CPR) -- ON DELETE CASCADE
);

CREATE TABLE Phone (
	CPR				VARCHAR(10),
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
    NewspaperTitle	varchar(30),
    Editor			varchar(10),
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
    Reporter		VARCHAR(10),
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
    Writer			VARCHAR(10),
    WritingRole		ENUM('LEADER', 'ADVISOR'),
    PRIMARY KEY(ArticleTitle, Writer, WritingRole),
    FOREIGN KEY(ArticleTitle) REFERENCES Article(ArticleTitle),
    FOREIGN KEY(Writer) REFERENCES Journalist(CPR)
);

CREATE VIEW ContainsArticle AS
SELECT NewspaperTitle, Published, ArticleTitle FROM Article
WHERE Published != null;