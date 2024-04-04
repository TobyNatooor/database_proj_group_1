USE dkavisendb;

-- Examples of INSERT, UPDATE and DELETE statements:

INSERT Journalist VALUES('0123456789', 'Bjørn', 'Normann', 'Oslovegen', 11, 64973, 'Norway');

SELECT * FROM Journalist
WHERE CPR = 0123456789;

INSERT Newspaper VALUES
	('Oslo Tidende', '2003-06-22', 'DAILY'),
    ('Bjørns Tanker', '2017-11-15', 'MONTHLY');
    
SELECT * FROM Newspaper;

UPDATE Newspaper SET Periodicity = 'WEEKLY'
WHERE NewspaperTitle = 'Bjørns Tanker';

SELECT * FROM Newspaper;

UPDATE Journalist
SET StreetName = 'Holmegården', StreetNumber = 15
WHERE CPR = 0123456789;

SELECT * FROM Journalist
WHERE CPR = 0123456789;

DELETE FROM Journalist
WHERE CPR = 0123456789;

SELECT * FROM Journalist
WHERE CPR = 0123456789;

DELETE FROM Newspaper
WHERE NewspaperTitle = 'Oslo Tidende'
OR NewspaperTitle = 'Bjørns Tanker';

SELECT * FROM Newspaper;

-- Lists the top 10 journalists with most amount of total readers
select FirstName, LastName, SUM(NrOfReaders) as Readers
from Article natural join Writer as w join Journalist as j where j.CPR = w.writer
group by Writer order by Readers desc
limit 10;

-- Identify which journalists were both writers and reporters, having shot at least a photo that was used for a news article they wrote
select w.ArticleTitle, j.FirstName, j.LastName
from Writer w
join IncludesPhoto ip on w.ArticleTitle = ip.ArticleTitle
join Photo p on ip.PhotoTitle = p.PhotoTitle
join Journalist j on p.Reporter = j.CPR
where j.CPR = w.writer;

-- Showing the most read article in each topic
select Topic, ArticleTitle as Most_Read, max(NrOfReaders) as Readers
from Article
group by Topic order by Readers desc;

-- Show reporters whose photos were never used more than once
select distinct j.FirstName, j.LastName
from Journalist j
join Photo p on j.CPR = p.Reporter
left join IncludesPhoto ip on p.PhotoTitle = ip.PhotoTitle
group by j.CPR, j.FirstName
having COUNT(distinct p.PhotoTitle) > 0
and COUNT(distinct ip.ArticleTitle) < 2;

-- Identify which topics, overall, attracted less reads that the average
select Topic, avg(NrOfReaders) AverageNrOfReadersForTopic
from Article
group by Topic
having avg(NrOfReaders) < (select avg(NrOfReaders) from Article);

-- Identify which topics, overall, attracted less reads that the average (Alternativ)
select Topic, TotalNrOfReadersForTopic
from (
    select Topic, sum(NrOfReaders) TotalNrOfReadersForTopic
    from Article
    group by Topic
) AReaders
where TotalNrOfReadersForTopic < (
    select avg(TotalNrOfReadersForTopic)
    from (
        select Topic, SUM(NrOfReaders) TotalNrOfReadersForTopic
        from Article
        group by Topic
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
    INSERT user(PhotoTitle,PhotoDate,Reporter)
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
WHERE CPR = 0123456789;
DELETE FROM Journalist
WHERE CPR = 0123456789;

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

INSERT Journalist VALUES('0123456789', 'Bjørn', 'Normann', 'Oslovegen', 11, 64973, 'Norway');
INSERT Phone VALUES('0123456789', '04853478');