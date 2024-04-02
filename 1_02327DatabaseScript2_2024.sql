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