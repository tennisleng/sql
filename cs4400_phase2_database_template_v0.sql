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

CREATE TABLE Contains (
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
    speed SMALLINT CHECK (speed BETWEEN 400 AND 700),
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

CREATE TABLE pilot (
    personID VARCHAR(50) NOT NULL,
    taxID CHAR(11) NOT NULL,  
    experience INT,
    flightID VARCHAR(50),
    PRIMARY KEY (personID, taxID),  
    UNIQUE (taxID),  
    CONSTRAINT fk_pilot_person
        FOREIGN KEY (personID) REFERENCES person(personID),
    CONSTRAINT fk_pilot_flight
        FOREIGN KEY (flightID) REFERENCES flight(flightID)
) ENGINE=InnoDB;

CREATE TABLE license (
    License INT AUTO_INCREMENT,
    taxID CHAR(11) NOT NULL,
    primary key(License, taxid), 
    CONSTRAINT fk_license_pilot
        FOREIGN KEY (taxID) REFERENCES pilot(taxID)
) ENGINE=InnoDB;

CREATE TABLE flight (
    flightID VARCHAR(50),
    routeID VARCHAR(50) NOT NULL,
    tail_num VARCHAR(10) NOT NULL,
    airlineID VARCHAR(50) NOT NULL,
    progress INT,
    status ENUM('on_ground', 'in_flight'),
    next_time DATETIME,
    cost DECIMAL(8,2) NOT NULL CHECK (cost > 0),
    PRIMARY KEY(flightID, tail_num,airlineID),
    CONSTRAINT fk_flight_route
        FOREIGN KEY (routeID) REFERENCES route(routeID),
    CONSTRAINT fk_flight_airplane
        FOREIGN KEY (tail_num, airlineID) REFERENCES airplane(tail_num, airlineID)
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


-- Insert Statements
INSERT INTO airline (airlineID, name, revenue) VALUES
('Delta', 'Delta Air Lines', 53000),
('United', 'United Airlines', 48000),
('British_Airways', 'British Airways', 24000),
('Lufthansa', 'Lufthansa', 35000),
('Air_France', 'Air France', 29000),
('KLM', 'KLM Royal Dutch Airlines', 29000),
('Ryanair', 'Ryanair', 10000),
('Japan_Airlines', 'Japan Airlines', 9000),
('China_Southern', 'China Southern Airlines', 14000),
('Korean_Air', 'Korean Air Lines', 10000),
('American', 'American Airlines', 52000);

INSERT INTO airport (airportID, name, city, state, country) VALUES
('ATL', 'Atlanta Hartsfield-Jackson International', 'Atlanta', 'Georgia', 'US'),
('DXB', 'Dubai International', 'Dubai', 'Dubai', 'AE'),
('HND', 'Tokyo International Haneda', 'Tokyo', 'Tokyo', 'JP'),
('LHR', 'London Heathrow', 'London', 'England', 'GB'),
('IST', 'Istanbul Airport', 'Istanbul', 'Istanbul', 'TR'),
('DFW', 'Dallas/Fort Worth International', 'Dallas', 'Texas', 'US'),
('CAN', 'Guangzhou Baiyun International', 'Guangzhou', 'Guangdong', 'CN'),
('DEN', 'Denver International', 'Denver', 'Colorado', 'US'),
('LAX', 'Los Angeles International', 'Los Angeles', 'California', 'US'),
('ORD', 'O''Hare International', 'Chicago', 'Illinois', 'US'),
('AMS', 'Amsterdam Airport Schiphol', 'Amsterdam', 'North Holland', 'NL'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'Île-de-France', 'FR'),
('FRA', 'Frankfurt Airport', 'Frankfurt', 'Hesse', 'DE'),
('MAD', 'Adolfo Suárez Madrid–Barajas Airport', 'Madrid', 'Madrid', 'ES'),
('BCN', 'Barcelona–El Prat Airport', 'Barcelona', 'Catalonia', 'ES'),
('FCO', 'Leonardo da Vinci–Fiumicino Airport', 'Rome', 'Lazio', 'IT'),
('LGW', 'London Gatwick', 'London', 'England', 'GB'),
('MUC', 'Munich Airport', 'Munich', 'Bavaria', 'DE'),
('IAH', 'George Bush Intercontinental', 'Houston', 'Texas', 'US'),
('HOU', 'William P. Hobby', 'Houston', 'Texas', 'US'),
('NRT', 'Narita International', 'Tokyo', 'Chiba', 'JP'),
('BER', 'Berlin Brandenburg', 'Berlin', 'Berlin', 'DE'),
('ICN', 'Incheon International', 'Seoul', 'Incheon', 'KR'),
('PVG', 'Shanghai Pudong International', 'Shanghai', 'Shanghai', 'CN');

INSERT INTO location (locID) VALUES
('port_1'),('port_2'),('port_3'),('port_4'),('port_6'),('port_7'),('port_10'),
('port_11'),('port_12'),('port_13'),('port_14'),('port_15'),('port_16'),('port_17'),
('port_18'),('port_20'),('port_21'),('port_22'),('port_23'),('port_24'),('port_25'),
('plane_1'),('plane_2'),('plane_3'),('plane_4'),('plane_5'),('plane_6'),('plane_7'),
('plane_8'),('plane_10'),('plane_13'),('plane_18'),('plane_20');

INSERT INTO airplane (tail_num, airlineID, manufacturer, model, variant, seat_cap, speed, locID) VALUES
('n106js','Delta','Airbus',NULL,NULL,4,800,'plane_1'),
('n110jn','Delta','Airbus',NULL,NULL,5,800,'plane_3'),
('n127js','Delta','Airbus',NULL,'neo',4,600,NULL),
('n330ss','United','Airbus',NULL,NULL,4,800,NULL),
('n380sd','United','Airbus',NULL,NULL,5,400,'plane_5'),
('n616lt','British_Airways','Airbus',NULL,NULL,7,600,'plane_6'),
('n517ly','British_Airways','Airbus',NULL,NULL,4,600,'plane_7'),
('n620la','Lufthansa','Airbus',NULL,'neo',4,800,'plane_8'),
('n401fj','Lufthansa','Airbus',NULL,NULL,4,300,NULL),
('n653fk','Lufthansa','Airbus',NULL,NULL,6,600,'plane_10'),
('n118fm','Air_France','Boeing','777',NULL,4,400,NULL),
('n815pw','Air_France','Airbus',NULL,NULL,3,400,NULL),
('n161fk','KLM','Airbus',NULL,'neo',4,600,'plane_13'),
('n337as','KLM','Airbus',NULL,NULL,5,400,NULL),
('n256ap','KLM','Boeing','737',NULL,4,300,NULL),
('n156sq','Ryanair','Airbus',NULL,NULL,8,600,NULL),
('n451fi','Ryanair','Airbus',NULL,'neo',5,600,NULL),
('n341eb','Ryanair','Boeing','737','MAX',4,400,'plane_18'),
('n353kz','Ryanair','Boeing','737','MAX',4,400,NULL),
('n305fv','Japan_Airlines','Airbus',NULL,NULL,6,400,'plane_20'),
('n443wu','Japan_Airlines','Airbus',NULL,'neo',4,800,NULL),
('n454gq','China_Southern','Airbus',NULL,NULL,3,400,NULL),
('n249yk','China_Southern','Boeing','787',NULL,4,400,NULL),
('n180co','Korean_Air','Airbus',NULL,NULL,5,600,'plane_4'),
('n448cs','American','Boeing','787','Dreamliner',4,400,NULL),
('n225sb','American','Airbus',NULL,NULL,8,800,NULL),
('n553qn','American','Airbus',NULL,NULL,5,800,'plane_2');


