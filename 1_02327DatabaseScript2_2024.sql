DROP PROCEDURE IF EXISTS AddPhoto;
DELIMITER //
CREATE PROCEDURE AddPhoto(IN vPhotoTitle VARCHAR(50), IN vPhotoDate DATE, IN vReporter DECIMAL(6, 0))
BEGIN
    INSERT user(PhotoTitle,PhotoDate,Reporter)
        VALUES (vPhotoTitle,vPhotoDate,vReporter);
END //