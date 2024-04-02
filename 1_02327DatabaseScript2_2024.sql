DROP PROCEDURE IF EXISTS AddPhoto;
DELIMITER //
CREATE PROCEDURE AddPhoto(IN vPhotoTitle VARCHAR(60), IN vPhotoDate DATE, IN vReporter VARCHAR(10))
BEGIN
    INSERT user(PhotoTitle,PhotoDate,Reporter)
        VALUES (vPhotoTitle,vPhotoDate,vReporter);
END //