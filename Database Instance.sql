DROP TABLE IF EXISTS IncludesPhoto;
DROP TABLE IF EXISTS Photo;
DROP TABLE IF EXISTS Article;
DROP TABLE IF EXISTS Writer;
DROP TABLE IF EXISTS NewsPaper;
DROP TABLE IF EXISTS Journalist;
DROP TABLE IF EXISTS Edition;
DROP TABLE IF EXISTS Phone;
DROP TABLE IF EXISTS Email;

CREATE TABLE Journalist
	(CPR			DECIMAL(6, 0), 
	 FirstName		DATE, 
     LastName		VARCHAR(50), 
     StreetName		VARCHAR(50), 
     StreetNumber	INTEGER, 
     ZipCode		INTEGER, 
     Country		VARCHAR(50), 
	 PRIMARY KEY(CPR)
	);
    
    CREATE TABLE Phone
	(PhoneNr	DECIMAL(8, 0), 
	 CPR		DECIMAL(6, 0), 
	 PRIMARY KEY(PhoneNr),
     FOREIGN KEY(CPR) REFERENCES Journalist(CPR) ON DELETE SET NULL
	);
    
CREATE TABLE Email
	(Email	VARCHAR(50), 
	 CPR	DECIMAL(6, 0), 
	 PRIMARY KEY(Email),
     FOREIGN KEY(CPR) REFERENCES Journalist(CPR) ON DELETE SET NULL
	);
    
CREATE TABLE Newspaper
	(NewspaperTitle	VARCHAR(50), 
	 Founded		DATE, 
     Periodicity	ENUM('daily','weekly','monthly','quarterly','annually'),   
	 PRIMARY KEY(NewspaperTitle)
     );
     
CREATE TABLE Edition
	(Published		DATE, 
     NewspaperTitle	VARCHAR(50),
     Editor			DECIMAL(6, 0), 
     PRIMARY KEY(Published),
	 FOREIGN KEY(NewspaperTitle) REFERENCES Newspaper(NewspaperTitle) ON DELETE SET NULL,
     FOREIGN KEY(Editor) REFERENCES Journalist(CPR) ON DELETE SET NULL
     );
     
CREATE TABLE Article
	(ArticleTitle	VARCHAR(50), 
	 ContentText	TEXT, 
     Topic			VARCHAR(50), 
     NrOfReaders	INTEGER, 
     Published		DATE, 
     NewspaperTitle	VARCHAR(50), 
	 PRIMARY KEY(ArticleTitle),
     FOREIGN KEY(Published) REFERENCES Edition(Published) ON DELETE SET NULL,
     FOREIGN KEY(NewspaperTitle) REFERENCES Edition(NewspaperTitle) ON DELETE SET NULL
	);
    
CREATE TABLE Writer
	(ArticleTitle	VARCHAR(50), 
	 CPR		DECIMAL(6, 0), 
     Roles		VARCHAR(50), 
	 FOREIGN KEY(ArticleTitle) REFERENCES Article(ArticleTitle) ON DELETE SET NULL,
     FOREIGN KEY(CPR) REFERENCES Journalist(CPR) ON DELETE SET NULL
	);

CREATE TABLE Photo
	(PhotoTitle		VARCHAR(50), 
	 PhotoDate		DATE, 
     Reporter		DECIMAL(6, 0), 
	 PRIMARY KEY(PhotoTitle),
     FOREIGN KEY(Reporter) REFERENCES Journalist(CPR) ON DELETE SET NULL
	);

CREATE TABLE IncludesPhoto
	(ArticleTitle	VARCHAR(50), 
	 PhotoTitle		VARCHAR(50), 
	  FOREIGN KEY(ArticleTitle) REFERENCES Article(ArticleTitle) ON DELETE SET NULL,
      FOREIGN KEY(PhotoTitle) REFERENCES Photo(PhotoTitle) ON DELETE SET NULL
	);
    
DROP PROCEDURE IF EXISTS AddPhoto;
DELIMITER //
CREATE PROCEDURE AddPhoto(IN vPhotoTitle VARCHAR(50), IN vPhotoDate DATE, IN vReporter DECIMAL(6, 0))
BEGIN
    INSERT user(PhotoTitle,PhotoDate,Reporter)
        VALUES (vPhotoTitle,vPhotoDate,vReporter);
END //
    
INSERT INTO Journalist (CPR, FirstName, LastName, StreetName, StreetNumber, ZipCode, Country)
VALUES (123456, 'John', 'Doe', 'Main Street', 123, 12345, 'USA'),
       (234567, 'Jane', 'Smith', 'Oak Avenue', 456, 54321, 'Canada');

INSERT INTO Phone (PhoneNr, CPR)
VALUES (12345678, 123456),
       (87654321, 234567);

INSERT INTO Email (Email, CPR)
VALUES ('john@example.com', 123456),
       ('jane@example.com', 234567);

INSERT INTO Newspaper (NewspaperTitle, Founded, Periodicity)
VALUES ('The Times', '2020-01-01', 'daily'),
       ('Weekly News', '2019-01-01', 'weekly');

INSERT INTO Edition (Published, NewspaperTitle, Editor)
VALUES ('2024-03-25', 'The Times', 123456),
       ('2024-03-25', 'Weekly News', 234567);

INSERT INTO Article (ArticleTitle, ContentText, Topic, NrOfReaders, Published, NewspaperTitle)
VALUES ('Breaking News', 'Lorem ipsum dolor sit amet.', 'Breaking', 1000, '2024-03-25', 'The Times'),
       ('Feature Story', 'Consectetur adipiscing elit.', 'Feature', 500, '2024-03-25', 'Weekly News');

INSERT INTO Writer (ArticleTitle, CPR, Roles)
VALUES ('Breaking News', 123456, 'Reporter'),
       ('Feature Story', 234567, 'Editor');

INSERT INTO Photo (PhotoTitle, PhotoDate, Reporter)
VALUES ('Breaking News Photo', '2024-03-25', 123456),
       ('Feature Photo', '2024-03-25', 234567);

INSERT INTO IncludesPhoto (ArticleTitle, PhotoTitle)
VALUES ('Breaking News', 'Breaking News Photo'),
       ('Feature Story', 'Feature Photo');
