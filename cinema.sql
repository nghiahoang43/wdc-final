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

DELIMITER //
CREATE PROCEDURE get_bookings(IN movie_id_ INT)
BEGIN
    SELECT * FROM Booking
    WHERE Booking.movie_id = movie_id_;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE show_avail(IN booking_id_ INT)
BEGIN
    SELECT Seat.seat_id, Seat.seat_number FROM Seat
    INNER JOIN Booking ON Booking.room_id = Seat.room_id
    WHERE Seat.seat_id NOT IN (SELECT seat_id FROM Ticket WHERE Ticket.booking_id = booking_id_)
    AND Booking.booking_id = booking_id_;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE view_ticket (
    IN user_id_ INT
)
BEGIN
    SELECT Movie.movie_name, Movie.imgUrl, Booking.date, Room.room_number, Booking.startTime, Seat.seat_number from Ticket
    INNER JOIN Seat ON Seat.seat_id = Ticket.seat_id
    INNER JOIN Booking ON Booking.booking_id = Ticket.booking_id
    INNER JOIN Room ON Room.room_id = Booking.room_id
    INNER JOIN Movie ON Booking.movie_id = Movie.movie_id
    WHERE Ticket.user_id = user_id_
    ORDER BY Booking.date ASC, Booking.startTime ASC;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE booking_on_2022_06_20 (
)
BEGIN
    SELECT DISTINCT Movie.movie_name, Seat.seat_number FROM Booking
    INNER JOIN Movie ON Movie.movie_id = Booking.movie_id
    INNER JOIN Ticket ON Ticket.booking_id = Booking.booking_id
    INNER JOIN Seat ON Seat.seat_id = Ticket.seat_id
    WHERE date = '2022-06-20';
END //
DELIMITER ;

/* Mock database */
/* Create User */
CALL sign_up('user1', 'user1@gmail.com', 'WatchMovie12@');
CALL sign_up('user2', 'user2@gmail.com', 'WatchMovie12@');
CALL sign_up('user3', 'user3@gmail.com', 'WatchMovie12@');
CALL sign_up('user4', 'user4@gmail.com', 'WatchMovie12@');
CALL sign_up('user5', 'user5@gmail.com', 'WatchMovie12@');
CALL sign_up('user6', 'user6@gmail.com', 'WatchMovie12@');

/* Create Movie */
CALL add_movie('LIGHTYEAR', 105, 'https://wallis-digital-cdn.app.vista.co/media/entity/get/FilmPosterGraphic/HO00001408?width=300&height=450&allowPlaceHolder=false', 'The sci-fi action-adventure presents the definitive origin story of Buzz Lightyear???the hero who inspired the toy???introducing the legendary Space Ranger who would win generations of fans.');
CALL add_movie('JURASSIC WORLD: DOMINION', 147, 'https://wallis-digital-cdn.app.vista.co/media/entity/get/FilmPosterGraphic/HO00001152?width=300&height=450&allowPlaceHolder=false', 'This June, experience the epic conclusion to the Jurassic era as two generations unite for the first time. Chris Pratt and Bryce Dallas Howard are joined by Oscar??-winner Laura Dern, Jeff Goldblum, and Sam Neill in Jurassic World Dominion, a bold, timely, and breathtaking new adventure that spans the globe.');
CALL add_movie('DOCTOR STRANGE IN THE MULTIVERSE OF MADNESS', 126, 'https://wallis-digital-cdn.app.vista.co/media/entity/get/FilmPosterGraphic/HO00000975?width=300&height=450&allowPlaceHolder=false', "In Marvel Studios??? Doctor Strange in the Multiverse of Madness, the MCU unlocks the Multiverse and pushes its boundaries further than ever before. Journey into the unknown with Doctor Strange, who, with the help of mystical allies both old and new, traverses the mind-bending and dangerous alternate realities of the Multiverse to confront a mysterious new adversary.");
CALL add_movie('TOP GUN: MAVERICK', 130, 'https://wallis-digital-cdn.app.vista.co/media/entity/get/FilmPosterGraphic/HO00000704?width=300&height=450&allowPlaceHolder=false', 'After more than thirty years of service as one of the Navy???s top aviators, Pete ???Maverick??? Mitchell (Tom Cruise) is where he belongs, pushing the envelope as a courageous test pilot and dodging the advancement in rank that would ground him. When he finds himself training a detachment of Top Gun graduates for a specialized mission the likes of which no living pilot has ever seen, Maverick encounters Lt. Bradley Bradshaw (Miles Teller), call sign: ???Rooster,??? the son of Maverick???s late friend and Radar Intercept Officer Lt. Nick Bradshaw, aka ???Goose???.');
CALL add_movie('PIL???S ADVENTURES', 130, 'https://wallis-digital-cdn.app.vista.co/media/entity/get/FilmPosterGraphic/HO00001158?width=300&height=450&allowPlaceHolder=false', 'After more than thirty years of service as one of the Navy???s top aviators, Pete ???Maverick??? Mitchell (Tom Cruise) is where he belongs, pushing the envelope as a courageous test pilot and dodging the advancement in rank that would ground him. When he finds himself training a detachment of Top Gun graduates for a specialized mission the likes of which no living pilot has ever seen, Maverick encounters Lt. Bradley Bradshaw (Miles Teller), call sign: ???Rooster,??? the son of Maverick???s late friend and Radar Intercept Officer Lt. Nick Bradshaw, aka ???Goose???.');

/* Create Room */
CALL add_room(1);
CALL add_room(2);
CALL add_room(3);
CALL add_room(4);

/* Create Seat Room 1 */
CALL add_seat(1, 1);
CALL add_seat(1, 2);
CALL add_seat(1, 3);
CALL add_seat(1, 4);
CALL add_seat(1, 5);
CALL add_seat(1, 6);
CALL add_seat(1, 7);
CALL add_seat(1, 8);
CALL add_seat(1, 9);
CALL add_seat(1, 10);

/* Create Seat Room 2 */
CALL add_seat(2, 1);
CALL add_seat(2, 2);
CALL add_seat(2, 3);
CALL add_seat(2, 4);
CALL add_seat(2, 5);
CALL add_seat(2, 6);
CALL add_seat(2, 7);
CALL add_seat(2, 8);
CALL add_seat(2, 9);
CALL add_seat(2, 10);

/* Create Seat Room 3 */
CALL add_seat(3, 1);
CALL add_seat(3, 2);
CALL add_seat(3, 3);
CALL add_seat(3, 4);
CALL add_seat(3, 5);
CALL add_seat(3, 6);
CALL add_seat(3, 7);
CALL add_seat(3, 8);
CALL add_seat(3, 9);
CALL add_seat(3, 10);

/* Create Seat Room 4 */
CALL add_seat(4, 1);
CALL add_seat(4, 2);
CALL add_seat(4, 3);
CALL add_seat(4, 4);
CALL add_seat(4, 5);
CALL add_seat(4, 6);
CALL add_seat(4, 7);
CALL add_seat(4, 8);
CALL add_seat(4, 9);
CALL add_seat(4, 10);

/* Create Booking */
CALL add_booking(1, 2, '2022-06-20', '12:30:00');
CALL add_booking(1, 3, '2022-06-12', '17:10:00');
CALL add_booking(1, 4, '2022-06-14', '19:10:00');
CALL add_booking(1, 3, '2022-06-12', '08:10:00');
CALL add_booking(2, 2, '2022-06-12', '09:00:00');
CALL add_booking(2, 2, '2022-06-21', '11:30:00');
CALL add_booking(2, 1, '2022-06-23', '12:30:00');
CALL add_booking(3, 1, '2022-06-14', '19:45:00');
CALL add_booking(3, 3, '2022-06-17', '10:10:00');
CALL add_booking(3, 2, '2022-06-12', '07:30:00');
CALL add_booking(4, 3, '2022-07-18', '13:10:00');
CALL add_booking(4, 1, '2022-06-20', '20:10:00');
CALL add_booking(5, 2, '2022-06-20', '15:50:00');
CALL add_booking(5, 4, '2022-06-20', '17:00:00');
CALL add_booking(5, 3, '2022-06-23', '09:00:00');

/* Create Ticket */
CALL buy_ticket(1, 2, 22);
CALL buy_ticket(1, 2, 23);
CALL buy_ticket(2, 14, 32);
CALL buy_ticket(2, 15, 23);
CALL buy_ticket(3, 14, 35);
CALL buy_ticket(3, 2, 30);
CALL buy_ticket(4, 2, 25);
CALL buy_ticket(5, 2, 28);
CALL buy_ticket(5, 1, 14);