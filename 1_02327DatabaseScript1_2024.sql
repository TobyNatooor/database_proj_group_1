DROP DATABASE IF EXISTS DKNEWSPAPER;
CREATE DATABASE IF NOT EXISTS DKNEWSPAPER;
USE DKNEWSPAPER;

DROP TABLE IF EXISTS Journalist;
DROP TABLE IF EXISTS Email;
DROP TABLE IF EXISTS PhoneNumber;

DROP TABLE IF EXISTS Photo;
DROP TABLE IF EXISTS Article;
DROP TABLE IF EXISTS Newspaper;

CREATE TABLE Journalist (
	CPRNumber		VARCHAR(10),
	FirstName		VARCHAR(60),
    LastName		VARCHAR(60),
    Address 		VARCHAR(60),
	StreetName		VARCHAR(60),
    CivicNumber		VARCHAR(60),
    City			VARCHAR(60),
    ZIPCode			VARCHAR(60),
    Country			VARCHAR(60),
    PRIMARY KEY(CPRNumber)
);

CREATE TABLE Emails (
	CPRNumber		VARCHAR(10),
    Email			VARCHAR(60),
    FOREIGN KEY(CPRNumber) REFERENCES Journalist(CPRNumber) -- ON DELETE CASCADE
);

CREATE TABLE PhoneNumbers (
	CPRNumber		VARCHAR(10),
    PhoneNumber		VARCHAR(60),
    FOREIGN KEY(JournalistID) REFERENCES Journalist(JournalistID) -- ON DELETE CASCADE
);

CREATE TABLE Article (
	ArticleTitle	VARCHAR(60),
    PhotoTitle		VARCHAR(10),
    Content			VARCHAR(60),
    Topic			VARCHAR(60),
	NrOfReaders		DECIMAL(10,0),
    PRIMARY KEY(ArticleTitle),
    FOREIGN KEY(PhotoTitle) REFERENCES Photo(PhotoTitle)
);

CREATE TABLE Photo (
	PhotoTitle		VARCHAR(60),
    CPRNumber		VARCHAR(10),
    PhotoDate		VARCHAR(60),
    PRIMARY KEY(PhotoTitle)
);

CREATE TABLE IncludesPhoto (
	PhotoTitle		VARCHAR(60),
    ArticleTitle	VARCHAR(60),
    FOREIGN KEY(PhotoTitle) REFERENCES Photo(PhotoTitle),
    FOREIGN KEY(ArticleTitle) REFERENCES Article(ArticleTitle)
);

CREATE TABLE Newspaper (
	NewspaperTitle	VARCHAR(60),
    Founded			VARCHAR(60),
    Periodicity		VARCHAR(60),
    PRIMARY KEY(NewspaperTitle)
);

CREATE TABLE Edition (
	EditionID		VARCHAR(10),
    JournalistID	VARCHAR(10)
);
