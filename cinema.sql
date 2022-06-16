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
    imgUrl VARCHAR(100) NOT NULL,

    PRIMARY KEY (movie_id)
);

CREATE TABLE Room(
    room_id INT NOT NULL AUTO_INCREMENT,
    room_number INT NOT NULL,

    PRIMARY KEY (room_id)
);

CREATE TABLE Seat(
    seat_id INT NOT NULL AUTO_INCREMENT,
    seat_number INT NOT NULL,
    room_id INT NOT NULL,

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
    ticket_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    booking_id INT NOT NULL,
    seat_id INT NOT NULL,

    PRIMARY KEY (ticket_id),
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