-- CS4400: Introduction to Database Systems (Spring 2025)
-- Phase II: Create Table & Insert Statements [v0] Monday, February 3, 2025 @ 17:00 EST

-- Team __
-- Andrew Leng 903832819
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Team Member Name (GT username)

-- Directions:
-- Please follow all instructions for Phase II as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.
-- Create Table statements must be manually written, not taken from an SQL Dump file.
-- This file must run without error for credit.

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;

set @thisDatabase = 'airline_management';
drop database if exists airline_management;
create database if not exists airline_management;
use airline_management;

-- Define the database structures
/* You must enter your tables definitions, along with your primary, unique and foreign key
declarations, and data insertion statements here.  You may sequence them in any order that
works for you.  When executed, your statements must create a functional database that contains
all of the data, and supports as many of the constraints as reasonably possible. */

-- Table Definitions
-- Updated schema with correct data types and lengths
CREATE TABLE location (
    locID VARCHAR(50) PRIMARY KEY
) ENGINE=InnoDB;

CREATE TABLE airline (
    airlineID VARCHAR(50) PRIMARY KEY,
    revenue DECIMAL(12,2) DEFAULT 0.00
) ENGINE=InnoDB;

CREATE TABLE airport (
    airportID CHAR(3) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    country CHAR(3) NOT NULL,
    locID VARCHAR(50),
    CONSTRAINT fk_airport_location
        FOREIGN KEY (locID) REFERENCES location(locID)
) ENGINE=InnoDB;

CREATE TABLE route (
    routeID VARCHAR(50) PRIMARY KEY,
    airlineID VARCHAR(50) NOT NULL,
    CONSTRAINT fk_route_airline
        FOREIGN KEY (airlineID) REFERENCES airline(airlineID)
) ENGINE=InnoDB;


CREATE TABLE leg (
    legID VARCHAR(50) PRIMARY KEY,
    origin_airportID CHAR(3) NOT NULL,
    destination_airportID CHAR(3) NOT NULL,
    distance INT,
    CHECK (origin_airportID <> destination_airportID),
    CONSTRAINT fk_leg_origin
        FOREIGN KEY (origin_airportID) REFERENCES airport(airportID),
    CONSTRAINT fk_leg_dest
        FOREIGN KEY (destination_airportID) REFERENCES airport(airportID)
) ENGINE=InnoDB;

CREATE TABLE containTable (
    routeID VARCHAR(50) NOT NULL,
    legID VARCHAR(50) NOT NULL,
    sequence INT,
    PRIMARY KEY (routeID, legID),
    CONSTRAINT fk_contains_route
        FOREIGN KEY (routeID) REFERENCES route(routeID),
    CONSTRAINT fk_contains_leg
        FOREIGN KEY (legID) REFERENCES leg(legID)
) ENGINE=InnoDB;

CREATE TABLE airplane (
    tail_num VARCHAR(10),
    airlineID VARCHAR(50) NOT NULL,
    manufacturer ENUM('Airbus','Boeing') NOT NULL,
    seat_cap SMALLINT UNSIGNED NOT NULL CHECK (seat_cap > 0),
    speed int,
    locID VARCHAR(50),
    PRIMARY KEY(tail_num, airlineID),
    CONSTRAINT fk_airplane_airline
        FOREIGN KEY (airlineID) REFERENCES airline(airlineID),
    CONSTRAINT fk_airplane_location
        FOREIGN KEY (locID) REFERENCES location(locID)
) ENGINE=InnoDB;

CREATE TABLE airbus (
    tail_num VARCHAR(10),
    airlineID VARCHAR(50),
    variant VARCHAR(30),
    PRIMARY KEY (tail_num, airlineID),
    CONSTRAINT fk_airbus_airplane
        FOREIGN KEY (tail_num, airlineID) REFERENCES airplane(tail_num, airlineID)
) ENGINE=InnoDB;

CREATE TABLE boeing (
    tail_num VARCHAR(10),
    airlineID VARCHAR(50),
    model VARCHAR(30),
    maintained BOOLEAN,
    PRIMARY KEY (tail_num, airlineID),
    CONSTRAINT fk_boeing_airplane
        FOREIGN KEY (tail_num, airlineID) REFERENCES airplane(tail_num, airlineID)
) ENGINE=InnoDB;

CREATE TABLE person (
    personID VARCHAR(50) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    locID VARCHAR(50),
    CONSTRAINT fk_person_location
        FOREIGN KEY (locID) REFERENCES location(locID)
) ENGINE=InnoDB;




CREATE TABLE flight (
    flightID VARCHAR(50) PRIMARY KEY,
    routeID VARCHAR(50) NOT NULL,
    tail_num VARCHAR(10) NOT NULL,
    airlineID VARCHAR(50) NOT NULL,
    progress INT,
    status ENUM('on_ground', 'in_flight'),
    next_time DATETIME,
    cost DECIMAL(8,2) NOT NULL CHECK (cost > 0),
    CONSTRAINT fk_flight_route
        FOREIGN KEY (routeID) REFERENCES route(routeID),
    CONSTRAINT fk_flight_airplane
        FOREIGN KEY (tail_num, airlineID) REFERENCES airplane(tail_num, airlineID)
) ENGINE=InnoDB;

CREATE TABLE license (
    license_type INT AUTO_INCREMENT,
    taxID CHAR(11) NOT NULL unique,
	personID VARCHAR(50) NOT NULL,
    primary key( personID, license_type), 
    CONSTRAINT fk_license_pilot
        FOREIGN KEY (personID) REFERENCES pilot(personID)
) ENGINE=InnoDB;


CREATE TABLE pilot (
    personID VARCHAR(50) PRIMARY KEY,
    taxID CHAR(11) NOT NULL UNIQUE, 
    experience INT,
    flightID VARCHAR(50),
    CONSTRAINT fk_pilot_person
        FOREIGN KEY (personID) REFERENCES person(personID),
    CONSTRAINT fk_pilot_flight
        FOREIGN KEY (flightID) REFERENCES flight(flightID)
) ENGINE=InnoDB;


CREATE TABLE passenger (
    personID VARCHAR(50) PRIMARY KEY,
    funds DECIMAL(10,2) DEFAULT 0.00,
    miles INT DEFAULT 0,
    CONSTRAINT fk_passenger_person
        FOREIGN KEY (personID) REFERENCES person(personID)
) ENGINE=InnoDB;

CREATE TABLE vacation (
    sequence int  NOT NULL,
    destination CHAR(3) NOT NULL,
    personID VARCHAR(50) NOT NULL,
    PRIMARY KEY (personID, sequence,destination),
    CONSTRAINT fk_vacation_passenger
        FOREIGN KEY (personID) REFERENCES passenger(personID)
) ENGINE=InnoDB;


-- Insert Locations
INSERT INTO location (locID) VALUES
('port_1'), ('port_2'), ('port_3'), ('port_4'), ('port_6'), ('port_7'), ('port_10'),
('port_11'), ('port_12'), ('port_13'), ('port_14'), ('port_15'), ('port_16'), ('port_17'),
('port_18'), ('port_20'), ('port_21'), ('port_22'), ('port_23'), ('port_24'), ('port_25'),
('plane_1'), ('plane_2'), ('plane_3'), ('plane_4'), ('plane_5'), ('plane_6'), ('plane_7'),
('plane_8'), ('plane_10'), ('plane_13'), ('plane_18'), ('plane_20');

-- Insert Airlines
INSERT INTO airline (airlineID, revenue) VALUES
('Delta', 53000.00),
('United', 48000.00),
('British_Airways', 24000.00),
('Lufthansa', 35000.00),
('Air_France', 29000.00),
('KLM', 29000.00),
('Ryanair', 10000.00),
('Japan_Airlines', 9000.00),
('China_Southern', 14000.00),
('Korean_Air', 10000.00),
('American', 52000.00);

-- Insert Airports
INSERT INTO airport (airportID, name, city, state, country, locID) VALUES
('ATL', 'Atlanta Hartsfield_Jackson International', 'Atlanta', 'Georgia', 'USA', 'port_1'),
('DXB', 'Dubai International', 'Dubai', 'Al Garhoud', 'UAE', 'port_2'),
('HND', 'Tokyo International Haneda', 'Ota City', 'Tokyo', 'JPN', 'port_3'),
('LHR', 'London Heathrow', 'London', 'England', 'GBR', 'port_4'),
('DFW', 'Dallas_Fort Worth International', 'Dallas', 'Texas', 'USA', 'port_6'),
('CAN', 'Guangzhou International', 'Guangzhou', 'Guangdong', 'CHN', 'port_7'),
('DEN', 'Denver International', 'Denver', 'Colorado', 'USA', NULL),
('LAX', 'Los Angeles International', 'Los Angeles', 'California', 'USA', NULL),
('ORD', 'O_Hare International', 'Chicago', 'Illinois', 'USA', 'port_10'),
('AMS', 'Amsterdam Schipol International', 'Amsterdam', 'Haarlemmermeer', 'NLD', 'port_11'),
('CDG', 'Paris Charles de Gaulle', 'Roissy_en_France', 'Paris', 'FRA', 'port_12'),
('FRA', 'Frankfurt International', 'Frankfurt', 'Frankfurt_Rhine_Main', 'DEU', 'port_13'),
('MAD', 'Madrid Adolfo Suarez_Barajas', 'Madrid', 'Barajas', 'ESP', 'port_14'),
('BCN', 'Barcelona International', 'Barcelona', 'Catalonia', 'ESP', 'port_15'),
('FCO', 'Rome Fiumicino', 'Fiumicino', 'Lazio', 'ITA', 'port_16'),
('LGW', 'London Gatwick', 'London', 'England', 'GBR', 'port_17'),
('MUC', 'Munich International', 'Munich', 'Bavaria', 'DEU', 'port_18'),
('IAH', 'George Bush Intercontinental', 'Houston', 'Texas', 'USA', 'port_20'),
('HOU', 'William P_Hobby International', 'Houston', 'Texas', 'USA', 'port_21'),
('NRT', 'Narita International', 'Narita', 'Chiba', 'JPN', 'port_22'),
('BER', 'Berlin Brandenburg Willy Brandt International', 'Berlin', 'Schonefeld', 'DEU', 'port_23'),
('ICN', 'Incheon International Airport', 'Seoul', 'Jung_gu', 'KOR', 'port_24'),
('PVG', 'Shanghai Pudong International Airport', 'Shanghai', 'Pudong', 'CHN', 'port_25');

INSERT INTO route (routeID, airlineID) VALUES
('americas_one', 'Delta'),
('americas_three', 'United'),
('americas_two', 'British_Airways'),
('euro_north', 'Lufthansa'),
('euro_south', 'KLM'),
('pacific_rim_tour', 'Japan_Airlines'),
('germany_local', 'Ryanair'),
('texas_local', 'Delta'),
('big_europe_loop', 'British_Airways'),
('americas_hub_exchange', 'American'),
('korea_direct', 'Korean_Air');

INSERT INTO leg (legID, origin_airportID, destination_airportID, distance) VALUES
('leg_1', 'AMS', 'BER', 400),
('leg_2', 'ATL', 'AMS', 3900),
('leg_3', 'ATL', 'LHR', 3700),
('leg_4', 'ATL', 'ORD', 600),
('leg_5', 'BCN', 'CDG', 500),
('leg_6', 'BCN', 'MAD', 300),
('leg_7', 'BER', 'CAN', 4700),
('leg_8', 'BER', 'LGW', 600),
('leg_9', 'BER', 'MUC', 300),
('leg_10', 'CAN', 'HND', 1600),
('leg_11', 'CDG', 'BCN', 500),
('leg_12', 'CDG', 'FCO', 600),
('leg_13', 'CDG', 'LHR', 200),
('leg_14', 'CDG', 'MUC', 400),
('leg_15', 'DFW', 'IAH', 200),
('leg_16', 'FCO', 'MAD', 800),
('leg_17', 'FRA', 'BER', 300),
('leg_18', 'HND', 'NRT', 100),
('leg_19', 'HOU', 'DFW', 300),
('leg_20', 'IAH', 'HOU', 100),
('leg_21', 'LGW', 'BER', 600),
('leg_22', 'LHR', 'BER', 600),
('leg_23', 'LHR', 'MUC', 500),
('leg_24', 'MAD', 'BCN', 300),
('leg_25', 'MAD', 'CDG', 600),
('leg_26', 'MAD', 'FCO', 800),
('leg_27', 'MUC', 'BER', 300),
('leg_28', 'MUC', 'CDG', 400),
('leg_29', 'MUC', 'FCO', 400),
('leg_30', 'MUC', 'FRA', 200),
('leg_31', 'ORD', 'CDG', 3700),
('leg_32', 'DFW', 'ICN', 6800);

-- Insert Airplanes
INSERT INTO airplane (tail_num, airlineID, manufacturer, seat_cap, speed, locID) VALUES
('n106js', 'Delta', 'Airbus', 4, 800, 'plane_1'),
('n110jn', 'Delta', 'Airbus', 5, 800, 'plane_3'),
('n127js', 'Delta', 'Airbus', 4, 600, NULL),
('n330ss', 'United', 'Airbus', 4, 800, NULL),
('n380sd', 'United', 'Airbus', 5, 400, 'plane_5'),
('n616lt', 'British_Airways', 'Airbus', 7, 600, 'plane_6'),
('n517ly', 'British_Airways', 'Airbus', 4, 600, 'plane_7'),
('n620la', 'Lufthansa', 'Airbus', 4, 800, 'plane_8'),
('n401fj', 'Lufthansa', 'Airbus', 4, 300, NULL),
('n653fk', 'Lufthansa', 'Airbus', 6, 600, 'plane_10'),
('n118fm', 'Air_France', 'Boeing', 4, 400, NULL),
('n815pw', 'Air_France', 'Airbus', 3, 400, NULL),
('n161fk', 'KLM', 'Airbus', 4, 600, 'plane_13'),
('n337as', 'KLM', 'Airbus', 5, 400, NULL),
('n256ap', 'KLM', 'Boeing', 4, 300, NULL),
('n156sq', 'Ryanair', 'Airbus', 8, 600, NULL),
('n451fi', 'Ryanair', 'Airbus', 5, 600, NULL),
('n341eb', 'Ryanair', 'Boeing', 4, 400, 'plane_18'),
('n353kz', 'Ryanair', 'Boeing', 4, 400, NULL),
('n305fv', 'Japan_Airlines', 'Airbus', 6, 400, 'plane_20'),
('n443wu', 'Japan_Airlines', 'Airbus', 4, 800, NULL),
('n454gq', 'China_Southern', 'Airbus', 3, 400, NULL),
('n249yk', 'China_Southern', 'Boeing', 4, 400, NULL),
('n180co', 'Korean_Air', 'Airbus', 5, 600, 'plane_4'),
('n448cs', 'American', 'Boeing', 4, 400, NULL),
('n225sb', 'American', 'Airbus', 8, 800, NULL),
('n553qn', 'American', 'Airbus', 5, 800, 'plane_2');

-- Insert Airbus/Boeing Subtypes
INSERT INTO airbus (tail_num, airlineID, variant) VALUES
('n127js', 'Delta', 'neo'),
('n620la', 'Lufthansa', 'neo'),
('n161fk', 'KLM', 'neo'),
('n451fi', 'Ryanair', 'neo'),
('n443wu', 'Japan_Airlines', 'neo');

INSERT INTO boeing (tail_num, airlineID, model, maintained) VALUES
('n118fm', 'Air_France', '777', 0),
('n256ap', 'KLM', '737', 0),
('n341eb', 'Ryanair', '737', 1),
('n353kz', 'Ryanair', '737', 1),
('n249yk', 'China_Southern', '787', 0),
('n448cs', 'American', '787', 1);

-- Insert Persons
INSERT INTO person (personID, first_name, last_name, locID) VALUES
('p1', 'Jeanne', 'Nelson', 'port_1'),
('p2', 'Roxanne', 'Byrd', 'port_1'),
('p3', 'Tanya', 'Nguyen', 'port_1'),
('p4', 'Kendra', 'Jacobs', 'port_1'),
('p5', 'Jeff', 'Burton', 'port_1'),
('p6', 'Randal', 'Parks', 'port_1'),
('p7', 'Sonya', 'Owens', 'port_2'),
('p8', 'Bennie', 'Palmer', 'port_2'),
('p9', 'Marlene', 'Warner', 'port_3'),
('p10', 'Lawrence', 'Morgan', 'port_3'),
('p11', 'Sandra', 'Cruz', 'port_3'),
('p12', 'Dan', 'Ball', 'port_3'),
('p13', 'Bryant', 'Figueroa', 'port_3'),
('p14', 'Dana', 'Perry', 'port_3'),
('p15', 'Matt', 'Hunt', 'port_10'),
('p16', 'Edna', 'Brown', 'port_10'),
('p17', 'Ruby', 'Burgess', 'plane_3'),
('p18', 'Esther', 'Pittman', 'plane_10'),
('p19', 'Doug', 'Fowler', 'port_17'),
('p20', 'Thomas', 'Olson', 'port_17'),
('p21', 'Mona', 'Harrison', 'plane_1'),
('p22', 'Arlene', 'Massey', 'plane_1'),
('p23', 'Judith', 'Patrick', 'plane_1'),
('p24', 'Reginald', 'Rhodes', 'plane_5'),
('p25', 'Vincent', 'Garcia', 'plane_5'),
('p26', 'Cheryl', 'Moore', 'plane_5'),
('p27', 'Michael', 'Rivera', 'plane_8'),
('p28', 'Luther', 'Matthews', 'plane_8'),
('p29', 'Moses', 'Parks', 'plane_13'),
('p30', 'Ora', 'Steele', 'plane_13'),
('p31', 'Antonio', 'Flores', 'plane_13'),
('p32', 'Glenn', 'Ross', 'plane_13'),
('p33', 'Irma', 'Thomas', 'plane_20'),
('p34', 'Ann', 'Maldonado', 'plane_20'),
('p35', 'Jeffrey', 'Cruz', 'port_12'),
('p36', 'Sonya', 'Price', 'port_12'),
('p37', 'Tracy', 'Hale', 'port_12'),
('p38', 'Albert', 'Simmons', 'port_14'),
('p39', 'Karen', 'Terry', 'port_15'),
('p40', 'Glen', 'Kelley', 'port_20'),
('p41', 'Brooke', 'Little', 'port_3'),
('p42', 'Daryl', 'Nguyen', 'port_4'),
('p43', 'Judy', 'Willis', 'port_14'),
('p44', 'Marco', 'Klein', 'port_15'),
('p45', 'Angelica', 'Hampton', 'port_16'),
('p46', 'Janice', 'White', 'plane_10');

INSERT INTO flight (flightID, routeID, tail_num, airlineID, progress, status, next_time, cost) VALUES
('dl_10', 'americas_one', 'n106js', 'Delta', 1, 'in_flight', '2025-02-27 08:00:00', 200.00),
('un_38', 'americas_three', 'n380sd', 'United', 2, 'in_flight', '2025-02-27 14:30:00', 200.00),
('ba_61', 'americas_two', 'n616lt', 'British_Airways', 0, 'on_ground', '2025-02-27 09:30:00', 200.00),
('lf_20', 'euro_north', 'n620la', 'Lufthansa', 3, 'in_flight', '2025-02-27 11:00:00', 300.00),
('km_16', 'euro_south', 'n161fk', 'KLM', 6, 'in_flight', '2025-02-27 14:00:00', 400.00),
('ja_35', 'pacific_rim_tour', 'n305fv', 'Japan_Airlines', 1, 'in_flight', '2025-02-27 09:30:00', 300.00),
('ry_34', 'germany_local', 'n341eb', 'Ryanair', 0, 'on_ground', '2025-02-27 15:00:00', 100.00),
('dl_42', 'texas_local', 'n110jn', 'Delta', 0, 'on_ground', '2025-02-27 13:45:00', 220.00),
('lf_67', 'euro_north', 'n653fk', 'Lufthansa', 6, 'on_ground', '2025-02-27 21:23:00', 900.00);
INSERT INTO pilot (personID, taxID, experience, flightID) VALUES
('p1', '330-12-6907', 31, 'dl_10'),
('p2', '842-88-1257', 9, 'dl_10'),
('p3', '750-24-7616', 11, 'un_38'),
('p4', '776-21-8098', 24, 'un_38'),
('p5', '933-93-2165', 27, 'ba_61'),
('p6', '707-84-4555', 38, 'ba_61'),
('p7', '450-25-5617', 13, 'lf_20'),
('p8', '701-38-2179', 12, 'ry_34'),
('p9', '936-44-6941', 13, 'lf_20'),
('p10', '769-60-1266', 15, 'lf_20'),
('p11', '369-22-9505', 22, 'km_16'),
('p12', '680-92-5329', 24, 'ry_34'),
('p13', '513-40-4168', 24, 'km_16'),
('p14', '454-71-7847', 13, 'km_16'),
('p15', '153-47-8101', 30, 'ja_35'),
('p16', '598-47-5172', 28, 'ja_35'),
('p17', '865-71-6800', 36, 'dl_42'),
('p18', '250-86-2784', 23, 'lf_67');

INSERT INTO license (license_type, personID) VALUES
('airbus', 'p1'),
('airbus', 'p2'),
('boeing', 'p2'),
('airbus', 'p3'),
('airbus', 'p4'),
('boeing', 'p4'),
('airbus', 'p5'),
('airbus', 'p6'),
('boeing', 'p6'),
('airbus', 'p7'),
('airbus', 'p9'),
('boeing', 'p9'),
('general', 'p9'),
('airbus', 'p10'),
('airbus', 'p11'),
('boeing', 'p11'),
('boeing', 'p12'),
('airbus', 'p13'),
('airbus', 'p14'),
('airbus', 'p15'),
('boeing', 'p15'),
('general', 'p15'),
('airbus', 'p16'),
('airbus', 'p17'),
('boeing', 'p17');

INSERT INTO passenger (personID, funds, miles) VALUES
('p19', 0.00, 0),
('p20', 0.00, 0),
('p21', 700.00, 771),
('p22', 200.00, 374),
('p23', 400.00, 414),
('p24', 500.00, 292),
('p25', 300.00, 390),
('p26', 600.00, 302),
('p27', 400.00, 470),
('p28', 400.00, 208),
('p29', 700.00, 292),
('p30', 500.00, 686),
('p31', 400.00, 547),
('p32', 500.00, 257),
('p33', 600.00, 564),
('p34', 200.00, 211),
('p35', 500.00, 233),
('p36', 400.00, 293),
('p37', 700.00, 552),
('p38', 700.00, 812),
('p39', 400.00, 541),
('p40', 700.00, 441),
('p41', 300.00, 875),
('p42', 500.00, 691),
('p43', 300.00, 572),
('p44', 500.00, 572),
('p45', 500.00, 663),
('p46', 5000.00, 690);

INSERT INTO vacation (personID, sequence, destination) VALUES
('p21', 1, 'AMS'),
('p22', 1, 'AMS'),
('p23', 1, 'BER'),
('p24', 1, 'MUC'),
('p24', 2, 'CDG'),
('p25', 1, 'MUC'),
('p26', 1, 'MUC'),
('p27', 1, 'BER'),
('p28', 1, 'LGW'),
('p29', 1, 'FCO'),
('p29', 2, 'LHR'),
('p30', 1, 'FCO'),
('p30', 2, 'MAD'),
('p31', 1, 'FCO'),
('p32', 1, 'FCO'),
('p33', 1, 'CAN'),
('p34', 1, 'HND'),
('p35', 1, 'LGW'),
('p36', 1, 'FCO'),
('p37', 1, 'FCO'),
('p37', 2, 'LGW'),
('p37', 3, 'CDG'),
('p38', 1, 'MUC'),
('p39', 1, 'MUC'),
('p40', 1, 'HND');



INSERT INTO containTable (routeID, legID, sequence) VALUES
('americas_one', 'leg_2', 1),
('americas_one', 'leg_1', 2),
('americas_three', 'leg_31', 1),
('americas_three', 'leg_14', 2),
('americas_two', 'leg_3', 1),
('americas_two', 'leg_22', 2),
('big_europe_loop', 'leg_23', 1),
('big_europe_loop', 'leg_29', 2),
('big_europe_loop', 'leg_16', 3),
('big_europe_loop', 'leg_25', 4),
('big_europe_loop', 'leg_13', 5),
('euro_north', 'leg_16', 1),
('euro_north', 'leg_24', 2),
('euro_north', 'leg_5', 3),
('euro_north', 'leg_14', 4),
('euro_north', 'leg_27', 5),
('euro_north', 'leg_8', 6),
('euro_south', 'leg_21', 1),
('euro_south', 'leg_9', 2),
('euro_south', 'leg_28', 3),
('euro_south', 'leg_11', 4),
('euro_south', 'leg_6', 5),
('euro_south', 'leg_26', 6),
('germany_local', 'leg_9', 1),
('germany_local', 'leg_30', 2),
('germany_local', 'leg_17', 3),
('pacific_rim_tour', 'leg_7', 1),
('pacific_rim_tour', 'leg_10', 2),
('pacific_rim_tour', 'leg_18', 3),
('texas_local', 'leg_15', 1),
('texas_local', 'leg_20', 2),
('texas_local', 'leg_19', 3),
('korea_direct', 'leg_32', 1);
