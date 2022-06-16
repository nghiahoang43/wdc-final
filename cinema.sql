DROP DATABASE IF EXISTS cinema;
CREATE DATABASE cinema;
USE cinema;

CREATE TABLE User(
    user_id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(50) NOT NULL,

    PRIMARY KEY (user_id),
    CONSTRAINT email_not_unique UNIQUE (email)
);

CREATE TABLE Movie(
    movie_id INT NOT NULL AUTO_INCREMENT,
    movie_name VARCHAR(50) NOT NULL,
    duration INT NOT NULL,
    imgUrl TEXT NOT NULL,
    about TEXT,

    PRIMARY KEY (movie_id)
);

CREATE TABLE Room(
    room_id INT NOT NULL AUTO_INCREMENT,
    room_number INT NOT NULL,

    PRIMARY KEY (room_id)
);

CREATE TABLE Seat(
    seat_id INT NOT NULL AUTO_INCREMENT,
    room_id INT NOT NULL,
    seat_number INT NOT NULL,

    PRIMARY KEY (seat_id),
    CONSTRAINT fk_roomid_to_seatid FOREIGN KEY (room_id) REFERENCES Room (room_id) ON DELETE CASCADE
);

CREATE TABLE Booking(
    booking_id INT NOT NULL AUTO_INCREMENT,
    movie_id INT NOT NULL,
    room_id INT NOT NULL,
    date DATE,
    startTime TIME NOT NULL,

    PRIMARY KEY (booking_id),
    CONSTRAINT fk_movieid_to_bookingid FOREIGN KEY (movie_id) REFERENCES Movie (movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_roomid_to_bookingid FOREIGN KEY (room_id) REFERENCES Room (room_id) ON DELETE CASCADE
);

CREATE TABLE Ticket(
    user_id INT NOT NULL,
    booking_id INT NOT NULL,
    seat_id INT NOT NULL,

    PRIMARY KEY (user_id, booking_id, seat_id),
    CONSTRAINT fk_userid_to_ticketid FOREIGN KEY (user_id) REFERENCES User (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_bookingid_to_ticketid FOREIGN KEY (booking_id) REFERENCES Booking (booking_id) ON DELETE CASCADE,
    CONSTRAINT fk_seatid_to_ticketid FOREIGN KEY (seat_id) REFERENCES Seat (seat_id) ON DELETE CASCADE
);

DELIMITER //
CREATE PROCEDURE sign_up (
    IN username_ VARCHAR(50), email_ VARCHAR(50), password_ VARCHAR(30)
)
BEGIN
    INSERT INTO User (username, email, password) VALUES (username_, email_, password_);
    CALL login(email_, password_);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE login (
    IN email_ VARCHAR(50), password_ VARCHAR(30)
)
BEGIN
    SELECT * FROM User
        WHERE email = email_ AND password = password_;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE add_movie(
    IN
    movie_name_ VARCHAR(50),
    duration_ INT,
    imgUrl_ TEXT,
    about_ TEXT
)
BEGIN
    INSERT INTO Movie(movie_name, duration, imgUrl, about)
        VALUES (movie_name_, duration_, imgUrl_, about_);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE add_booking(
    IN
    movie_id_ INT,
    room_id_ INT,
    date_ DATE,
    startTime_ TIME
)
BEGIN
    INSERT INTO Booking(movie_id, room_id, date, startTime)
        VALUES (movie_id_, room_id_, date_, startTime_);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE add_room(
    IN
    room_number_ INT
)
BEGIN
    INSERT INTO Room(room_number)
        VALUES (room_number_);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE add_seat(
    IN
    room_id_ INT,
    seat_number_ INT
)
BEGIN
    INSERT INTO Seat(room_id, seat_number)
        VALUES (room_id_, seat_number_);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE buy_ticket(
    IN
    user_id_ INT,
    booking_id_ INT,
    seat_id_ INT
)
BEGIN
    INSERT INTO Ticket(user_id, booking_id, seat_id)
        VALUES (user_id_, booking_id_, seat_id_);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE get_tickets(IN user_id_ INT)
BEGIN
    SELECT * FROM Ticket WHERE user_id = user_id_;
END //
DELIMITER ;


/* Mock database */
CALL add_movie('LIGHTYEAR', 105, 'https://wallis-digital-cdn.app.vista.co/media/entity/get/FilmPosterGraphic/HO00001408?width=300&height=450&allowPlaceHolder=false', 'The sci-fi action-adventure presents the definitive origin story of Buzz Lightyear—the hero who inspired the toy—introducing the legendary Space Ranger who would win generations of fans.');
CALL add_movie('JURASSIC WORLD: DOMINION', 147, 'https://wallis-digital-cdn.app.vista.co/media/entity/get/FilmPosterGraphic/HO00001152?width=300&height=450&allowPlaceHolder=false', 'This June, experience the epic conclusion to the Jurassic era as two generations unite for the first time. Chris Pratt and Bryce Dallas Howard are joined by Oscar®-winner Laura Dern, Jeff Goldblum, and Sam Neill in Jurassic World Dominion, a bold, timely, and breathtaking new adventure that spans the globe.');
CALL add_movie('DOCTOR STRANGE IN THE MULTIVERSE OF MADNESS', 126, 'https://wallis-digital-cdn.app.vista.co/media/entity/get/FilmPosterGraphic/HO00000975?width=300&height=450&allowPlaceHolder=false', 'In Marvel Studios’ Doctor Strange in the Multiverse of Madness, the MCU unlocks the Multiverse and pushes its boundaries further than ever before. Journey into the unknown with Doctor Strange, who, with the help of mystical allies both old and new, traverses the mind-bending and dangerous alternate realities of the Multiverse to confront a mysterious new adversary.');