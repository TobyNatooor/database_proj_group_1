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
(6829103847, "Liu", "Wei", "Pine Street", "56", "20001", "China"),
(1837462910, "Sarah", "Johnson", "Chestnut Avenue", "34", "10021", "USA"),
(2948573019, "Emily", "Brown", "Willow Lane", "67", "30301", "USA"),
(3049581736, "Michael", "Chen", "Sunset Boulevard", "89", "90210", "USA"),
(4037192846, "Luca", "Ricci", "Via Roma", "45", "00100", "Italy"),
(5028103957, "Sophia", "Nguyen", "Tran Phu Street", "23", "70000", "Vietnam"),
(6739201847, "Anna", "Gonzalez", "Avenida Revolución", "56", "01000", "Mexico"),
(7730182936, "Daniel", "Wong", "King's Road", "78", "00001", "Hong Kong"),
(8291047563, "Thomas", "Mueller", "Mozartstraße", "12", "10117", "Germany"),
(9310857264, "Elena", "Petrova", "Bolshaya Moskovskaya Street", "34", "103001", "Russia"),
(1049385726, "Hiroshi", "Yamamoto", "Sakura Dori", "67", "100-0001", "Japan"),
(2048591738, "Léa", "Dubois", "Rue de la Paix", "89", "75001", "France"),
(3047192850, "Andreas", "Andersen", "Kongens Nytorv", "45", "1050", "Denmark"),
(4058193067, "Eva", "Müller", "Unter den Linden", "23", "10117", "Germany"),
(5049103876, "Sophie", "Lefèvre", "Champs-Élysées", "56", "75008", "France"),
(6037192846, "Federico", "Rossi", "Via del Corso", "78", "00186", "Italy"),
(7038192056, "Alessia", "Ricci", "Piazza di Spagna", "12", "00187", "Italy"),
(8049173625, "Juan", "García", "Calle Gran Vía", "34", "28013", "Spain"),
(9047183625, "María", "Rodríguez", "Carrer de Balmes", "67", "08007", "Spain"),
(1039581746, "Sara", "González", "Calle Serrano", "89", "28001", "Spain"),
(2038173946, "Lucía", "Martínez", "Rua Augusta", "45", "1100-048", "Portugal"),
(3047182957, "João", "Silva", "Avenida da Liberdade", "23", "1250-096", "Portugal"),
(4038192765, "Rui", "Santos", "Praça do Comércio", "56", "1100-148", "Portugal"),
(5039172836, "Carlos", "Fernández", "Calle de Alcalá", "78", "28014", "Spain"),
(6038192057, "Manuel", "López", "Carrer de Mallorca", "12", "08029", "Spain"),
(7039183746, "Paula", "Pérez", "Passeig de Gràcia", "34", "08007", "Spain"),
(8049172958, "Miguel", "Gómez", "Rua de Santa Catarina", "67", "4000-440", "Portugal"),
(9038172946, "Ana", "Dias", "Rua de Santa Justa", "89", "1100-485", "Portugal"),
(1029384729, "Pedro", "Ferreira", "Avenida da Boavista", "45", "4100-139", "Portugal"),
(2038192857, "Catarina", "Carvalho", "Rua de Cedofeita", "23", "4050-180", "Portugal");

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
(6829103847, "liu.wei@example.com"),
(1837462910, "Sarah@example.com"),
(2948573019, "Emily@example.com"),
(3049581736, "Michael@example.com"),
(4037192846, "Luca@example.com"),
(5028103957, "Sophia@example.com"),
(6739201847, "Anna@example.com"),
(7730182936, "Daniel@example.com"),
(8291047563, "Thomas@example.com"),
(9310857264, "Elena@example.com"),
(1049385726, "Hiroshi@example.com"),
(2048591738, "Léa@example.com"),
(3047192850, "Andreas@example.com"),
(4058193067, "Eva@example.com"),
(5049103876, "Sophie@example.com"),
(6037192846, "Federico@example.com"),
(7038192056, "Alessia@example.com"),
(8049173625, "Juan@example.com"),
(9047183625, "María@example.com"),
(1039581746, "Sara@example.com"),
(2038173946, "Lucía@example.com"),
(3047182957, "João@example.com"),
(4038192765, "Rui@example.com"),
(5039172836, "Carlos@example.com"),
(6038192057, "Manuel@example.com"),
(7039183746, "Paula@example.com"),
(8049172958, "Miguel@example.com"),
(9038172946, "Ana@example.com"),
(1029384729, "Pedro@example.com"),
(2038192857, "Catarina@example.com");

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
(6829103847, 56789012),
(1837462910, 57283194),
(2948573019, 46392517),
(3049581736, 32791486),
(4037192846, 54219836),
(5028103957, 17864329),
(6739201847, 65931482),
(7730182936, 83521947),
(8291047563, 47291638),
(9310857264, 98461723),
(1049385726, 73628419),
(2048591738, 38194725),
(3047192850, 25789314),
(4058193067, 96821534),
(5049103876, 17384629),
(6037192846, 29467831),
(7038192056, 81945632),
(8049173625, 62497138),
(9047183625, 50182739),
(1039581746, 73846259),
(2038173946, 29684315),
(3047182957, 40759128),
(4038192765, 86291573),
(5039172836, 57029384),
(6038192057, 34968251),
(7039183746, 18573942),
(8049172958, 63298410),
(9038172946, 71402589),
(1029384729, 50621938),
(2038192857, 92384765);

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
('Wildlife Safari Adventure', date("2024-03-13"), 4738291056),
('Spectacular Sunset', date("2024-04-01"), 7730182936),
('Ancient Ruins Discovery', date("2024-03-31"), 7730182936),
('Exotic Flower Exhibition', date("2024-03-30"), 7730182936),
('Epic Mountain Trek', date("2024-03-29"), 7730182936),
('Celebrity Red Carpet', date("2024-03-28"), 7730182936),
('Underwater Wonderland', date("2024-03-27"), 7730182936),
('Tropical Paradise Retreat', date("2024-03-26"), 8049172958),
('Artisan Chocolate Festival', date("2024-03-25"), 8049172958),
('Futuristic Technology Expo', date("2024-03-24"), 5028103957),
('Historic Battle Reenactment', date("2024-03-23"), 5028103957),
('Cosmic Nebula Observation', date("2024-03-22"), 5028103957),
('Medieval Castle Exploration', date("2024-03-21"), 5028103957),
('Culinary Delights Showcase', date("2024-03-20"), 5028103957),
('Aerial Acrobatics Show', date("2024-03-19"), 6037192846),
('Carnival Extravaganza', date("2024-03-18"), 6037192846),
('Enchanted Forest Walk', date("2024-03-17"), 9310857264),
('Classic Car Exhibition', date("2024-03-16"), 9310857264),
('World Music Festival', date("2024-03-15"), 9310857264),
('Architectural Marvel Tour', date("2024-03-14"), 9310857264),
('Extreme Sports Competition', date("2024-03-13"), 1029384729),
('Gourmet Food Truck Rally', date("2024-03-12"), 1029384729),
('Magical Fairy Garden', date("2024-03-11"), 1029384729),
('High-Speed Racing Event', date("2024-03-10"), 1029384729),
('Haute Couture Runway Show', date("2024-03-09"), 1029384729),
('Space Exploration Exhibition', date("2024-03-08"), 4037192846),
('Ethereal Waterfall Discovery', date("2024-03-07"), 4037192846),
('Fantasy Book Convention', date("2024-03-06"), 4037192846),
('Robotics Innovation Summit', date("2024-03-05"), 4037192846),
('Surreal Art Installation', date("2024-03-04"), 2038173946);

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
('Art Exhibition Showcases Local Talent', 'Review of the latest art exhibit featuring works by emerging artists in the community.', 'CULTURE', 15001, date("2023-03-13"), "Monthly Digest"),
('Cute dogs are populer', 'Science show that people like cute dogs... not cats tho', 'CULTURE', 567, date("2021-03-11"), "The world is doing great, NOT!"),
('Breaking News: Everyone hates you', 'Everyone has come together to agree that you suck', 'POLITICS', 1, date("2021-03-11"), "The world is doing great, NOT!"),
('Some guy won a sports thing', 'We dont know who tho.. or what they won', 'SPORTS', 6488, date("2021-03-11"), "The world is doing great, NOT!"),
('ChatGPT is awsome', 'Thanks to ChatGPT, writing these articals is just a litle faster', 'LOCAL', 10020, date("2023-03-15"), "The Daily Reporter"),
('Im getting sick of working', 'working this much shouldnt be allowed', 'LOCAL', 1312, date("2023-03-15"), "The Daily Reporter"),
('Please let me out of this basment', 'If anyone can read this please rescue me im trapt in #/&!..', 'LOCAL', 6969, date("2023-03-15"), "The Daily Reporter"),
('Im so happy to be reporting news!!', 'My life is great.', 'CULTURE', 420, date("2023-03-13"), "Monthly Digest"),
('Some Phone exploded, 2 teenagers dead', 'We dont yet know what phone it was but im sure it was an android.', 'CULTURE', 628, date("2023-03-13"), "Monthly Digest"),
('Worlds biggest pop star Saylor Twift is dead', 'Killed by a cat.', 'CULTURE', 8201, date("2023-03-13"), "Monthly Digest");


INSERT INTO IncludesPhoto (PhotoTitle, ArticleTitle) VALUES
('UFO Sighting', 'Breaking News: Alien Invasion'),
('Unicorn Cupcakes', 'Recipe: Unicorn Cupcakes'),
('Bitcoin Surge', 'Crypto Market Update'),
('Cityscape at Night', 'Local Hero Wins Marathon'),
('Fashion Show Highlights', 'Interview with a Celebrity Chef'),
('Wildlife Safari Adventure', 'Political Unrest in the Middle East'),
('Spectacular Sunset','Cute dogs are populer'),
('Historic Battle Reenactment','ChatGPT is awsome'),
('Aerial Acrobatics Show','Please let me out of this basment'),
('Magical Fairy Garden','Im getting sick of working'),
('High-Speed Racing Event','Some guy won a sports thing'),
('Haute Couture Runway Show','Breaking News: Everyone hates you'),
('Ancient Ruins Discovery','Some Phone exploded, 2 teenagers dead'),
('Exotic Flower Exhibition','Worlds biggest pop star Saylor Twift is dead'),
('Artisan Chocolate Festival','Im so happy to be reporting news!!');

INSERT INTO Writer (ArticleTitle, Writer, WritingRole) VALUES
('Breaking News: Alien Invasion', 4953710423, 'LEADER'),
('Recipe: Unicorn Cupcakes', 0684353941, 'ADVISOR'),
('Crypto Market Update', 1047395734, 'LEADER'),
('Local Hero Wins Marathon', 6829103847, 'LEADER'),
('Interview with a Celebrity Chef', 5738192046, 'ADVISOR'),
('Political Unrest in the Middle East', 2837465921, 'LEADER'),
('New Study on Climate Change', 2948573019, 'LEADER'),
('Tech Giants Face Antitrust Probe', 2948573019, 'LEADER'),
('Health Benefits of Meditation', 7730182936, 'LEADER'),
('Sports Team Clinches Championship Victory', 7730182936, 'LEADER'),
('Art Exhibition Showcases Local Talent', 1029384729, 'LEADER'),
('Cute dogs are populer', 1029384729, 'LEADER'),
('Breaking News: Everyone hates you',3047182957, 'LEADER'),
('Some guy won a sports thing', 3047182957, 'ADVISOR'),
('ChatGPT is awsome', 2038192857, 'ADVISOR'),
('Im getting sick of working', 2038192857, 'ADVISOR'),
('Please let me out of this basment', 6038192057, 'ADVISOR'),
('Im so happy to be reporting news!!', 6038192057, 'ADVISOR'),
('Some Phone exploded, 2 teenagers dead', 9310857264, 'ADVISOR'),
('Worlds biggest pop star Saylor Twift is dead', 7730182936, 'ADVISOR');
