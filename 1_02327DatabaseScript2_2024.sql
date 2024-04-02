DELIMITER //
CREATE FUNCTION getTopicReaderSum(topic ENUM('SPORTS','CULTURE','POLITICS','INTERNATIONAL','LOCAL')) RETURNS INT
BEGIN
	DECLARE readerSum INT;
	SELECT sum(NrOfReaders) INTO readerSum FROM Article WHERE Article.topic = topic;
    RETURN readerSum;
END //
DELIMITER ;

-- Example:
-- select getTopicReaderSum('CULTURE');
