USE dkavisendb;

-- Examples of INSERT, UPDATE and DELETE statements:

INSERT Journalist VALUES('0123456789', 'Bjørn', 'Normann', 'Oslovegen', 11, 64973, 'Norway');

SELECT * FROM Journalist
WHERE CPR = '0123456789';

INSERT Newspaper VALUES
	('Oslo Tidende', '2003-06-22', 'DAILY'),
    ('Bjørns Tanker', '2017-11-15', 'MONTHLY');
    
SELECT * FROM Newspaper;

UPDATE Newspaper SET Periodicity = 'WEEKLY'
WHERE NewspaperTitle = 'Bjørns Tanker';

SELECT * FROM Newspaper;

UPDATE Journalist
SET StreetName = 'Holmegården', StreetNumber = 15
WHERE CPR = '0123456789';

SELECT * FROM Journalist
WHERE CPR = '0123456789';

DELETE FROM Journalist
WHERE CPR = '0123456789';

SELECT * FROM Journalist
WHERE CPR = '0123456789';

DELETE FROM Newspaper
WHERE NewspaperTitle = 'Oslo Tidende'
OR NewspaperTitle = 'Bjørns Tanker';

SELECT * FROM Newspaper;

-- Lists the top 10 journalists with most amount of total readers
SELECT FirstName, LastName, SUM(NrOfReaders) AS Readers
FROM Article NATURAL JOIN Writer AS w JOIN Journalist AS j WHERE j.CPR = w.writer
GROUP BY Writer ORDER BY Readers DESC
LIMIT 10;

-- Identify which journalists were both writers and reporters, having shot at least a photo that was used for a news article they wrote
SELECT w.ArticleTitle, j.FirstName, j.LastName
FROM Writer w
JOIN IncludesPhoto ip ON w.ArticleTitle = ip.ArticleTitle
JOIN Photo p ON ip.PhotoTitle = p.PhotoTitle
JOIN Journalist j ON p.Reporter = j.CPR
WHERE j.CPR = w.writer;

-- Showing the most read article in each topic
SELECT Topic, ArticleTitle AS Most_Read, MAX(NrOfReaders) AS Readers
FROM Article
GROUP BY Topic ORDER BY Readers DESC;

-- Show reporters whose photos were never used more than once
SELECT DISTINCT j.FirstName, j.LastName
FROM Journalist j
JOIN Photo p ON j.CPR = p.Reporter
LEFT JOIN IncludesPhoto ip ON p.PhotoTitle = ip.PhotoTitle
GROUP BY j.CPR, j.FirstName
HAVING COUNT(DISTINCT p.PhotoTitle) > 0
AND COUNT(DISTINCT ip.ArticleTitle) < 2;

-- Identify which topics, overall, attracted less reads that the average
SELECT Topic, AVG(NrOfReaders) AverageNrOfReadersForTopic
FROM Article
GROUP BY Topic
HAVING AVG(NrOfReaders) < (SELECT AVG(NrOfReaders) FROM Article);

-- Identify which topics, overall, attracted less reads that the average (Alternativ)
SELECT Topic, TotalNrOfReadersForTopic
FROM (
    SELECT Topic, SUM(NrOfReaders) TotalNrOfReadersForTopic
    FROM Article
    GROUP BY Topic
) AReaders
WHERE TotalNrOfReadersForTopic < (
    SELECT AVG(TotalNrOfReadersForTopic)
    FROM (
        SELECT Topic, SUM(NrOfReaders) TotalNrOfReadersForTopic
        FROM Article
        GROUP BY Topic
    ) AvgR
);

-- Functions
DROP FUNCTION IF EXISTS getTopicReaderSum;
DROP FUNCTION IF EXISTS getAverageReaderPerArticle;

DELIMITER //
CREATE FUNCTION getTopicReaderSum(topic ENUM('SPORTS','CULTURE','POLITICS','INTERNATIONAL','LOCAL')) RETURNS INT
BEGIN
	DECLARE readerSum INT;
	SELECT sum(NrOfReaders) INTO readerSum FROM Article WHERE Article.topic = topic;
    RETURN readerSum;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS AddPhoto;
DELIMITER //
CREATE PROCEDURE AddPhoto(IN vPhotoTitle VARCHAR(60), IN vPhotoDate DATE, IN vReporter VARCHAR(10))
BEGIN
    INSERT Photo(PhotoTitle,PhotoDate,Reporter)
        VALUES (vPhotoTitle,vPhotoDate,vReporter);
END //

DELIMITER //
CREATE FUNCTION getAverageReaderPerArticle(topic ENUM('SPORTS','CULTURE','POLITICS','INTERNATIONAL','LOCAL')) RETURNS DOUBLE
BEGIN
	DECLARE readerSum INT;
    DECLARE articleCount INT;
	SELECT sum(NrOfReaders) INTO readerSum FROM Article WHERE Article.topic = topic;
	SELECT count(*) INTO articleCount FROM Article WHERE Article.topic = topic;
    RETURN readerSum / articleCount;
END //
DELIMITER ;

-- Example of function use:
-- select getTopicReaderSum('CULTURE');
-- select getAverageReaderPerArticle('CULTURE');


-- TRIGGERS

SET SQL_SAFE_UPDATES = 0;

INSERT Journalist VALUES('0123456789', 'Bjørn', 'Normann', 'Oslovegen', 11, 64973, 'Norway');
INSERT Phone VALUES('0123456789', '04853478');

DELETE FROM Phone
WHERE CPR = '0123456789';
DELETE FROM Journalist
WHERE CPR = '0123456789';

DELIMITER //
CREATE TRIGGER PhoneNrFirstDigitNotZero
BEFORE INSERT ON Phone
FOR EACH ROW
BEGIN
    DECLARE firstDigit VARCHAR(1);
    SET firstDigit = LEFT(NEW.PhoneNr, 1);

    IF firstDigit = '0' THEN
        SIGNAL SQLSTATE 'HY000'
        SET MESSAGE_TEXT = 'Phone number cannot start with zero.';
    END IF;
END //
DELIMITER ;

-- INSERT Journalist VALUES('0123456789', 'Bjørn', 'Normann', 'Oslovegen', 11, 64973, 'Norway');
-- INSERT Phone VALUES('0123456789', '04853478');