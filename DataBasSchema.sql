--CREATE TABLES--------------------

CREATE TABLE CUSTOMER_T (
    CustomerID INT PRIMARY KEY,
    customerName VARCHAR2(50),
    customerContact VARCHAR2(20) UNIQUE,
    customerCity VARCHAR2(50),
    customerGender VARCHAR2(10),
    customerEmail VARCHAR2(100) UNIQUE,
    customerPassword VARCHAR2(100), 
    CONSTRAINT chk_password CHECK (LENGTH(customerPassword) >= 8 AND REGEXP_LIKE(customerPassword, '\d')),
    CONSTRAINT chk_email CHECK (REGEXP_LIKE(customerEmail, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')),
    CONSTRAINT chk_gender CHECK (customerGender IN ('Male', 'Female', 'Other'))
);

DROP TABLE Manager;
CREATE TABLE Manager (
    ManagerID INT PRIMARY KEY,
    managerContact VARCHAR2(20),
    managerEmail VARCHAR2(100),
    password VARCHAR2(100),
    CONSTRAINT chk_manager_password CHECK (LENGTH(password) >= 8 AND REGEXP_LIKE(password, '\d')),
    CONSTRAINT chk_manager_email CHECK (REGEXP_LIKE(managerEmail, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'))
);

ALTER TABLE Manager ADD managerName VARCHAR2(20);

CREATE TABLE Station (
    StationID INT PRIMARY KEY,
    StationName VARCHAR2(100) NOT NULL
);

CREATE TABLE Train (
    TrainID INT PRIMARY KEY,
    TrainName VARCHAR2(100) NOT NULL,
    SeatsCapacity INT NOT NULL,
    BasePrice NUMBER(10, 2) NOT NULL,
    seatsLeft INT
);

CREATE TABLE TrainStops (
    TrainID INT,
    StationID INT,
    ArrivalTime TIMESTAMP,
    DepartureTime TIMESTAMP,
    PRIMARY KEY (TrainID, StationID),
    FOREIGN KEY (TrainID) REFERENCES Train(TrainID),
    FOREIGN KEY (StationID) REFERENCES Station(StationID)
);

CREATE TABLE Booking (
    BookingID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    TrainID INT NOT NULL,
    bookingDate DATE NOT NULL,
    seatsBooked INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer_T(CustomerID),
    FOREIGN KEY (TrainID) REFERENCES Train(TrainID)
);

ALTER TABLE Booking ADD fromstation INT;
ALTER TABLE Booking ADD tostation INT;

ALTER TABLE Booking
ADD CONSTRAINT fk_fromstation
FOREIGN KEY (fromstation)
REFERENCES Station(StationID);

ALTER TABLE Booking
ADD CONSTRAINT fk_tostation
FOREIGN KEY (tostation)
REFERENCES Station(StationID);


-------------------------VIEW-------------------------------

CREATE VIEW CustomerBookingView AS
SELECT 
    C.customerName AS CustomerName,
    T.TrainName AS TrainName,
    TS.DepartureTime AS DepartureTime,
    B.CustomerID AS CustomerID,
    SUM(B.seatsBooked) AS TotalSeatsBooked,
    SF.StationName AS FromStation,
    ST.StationName AS ToStation
FROM 
    Booking B
JOIN 
    CUSTOMER_T C ON B.CustomerID = C.CustomerID
JOIN 
    Train T ON B.TrainID = T.TrainID
JOIN 
    TrainStops TS ON B.TrainID = TS.TrainID
JOIN 
    TrainStops TF ON B.TrainID = TF.TrainID AND TF.ArrivalTime = (SELECT MIN(ArrivalTime) FROM TrainStops WHERE TrainID = B.TrainID)
JOIN 
    Station SF ON TF.StationID = SF.StationID
JOIN 
    TrainStops TT ON B.TrainID = TT.TrainID AND TT.DepartureTime = (SELECT MAX(DepartureTime) FROM TrainStops WHERE TrainID = B.TrainID)
JOIN 
    Station ST ON TT.StationID = ST.StationID
GROUP BY
    C.customerName, T.TrainName, TS.DepartureTime, B.CustomerID, SF.StationName, ST.StationName;

SELECT * FROM CustomerBookingView;

DROP VIEW BookingDetails;

CREATE OR REPLACE VIEW BookingDetails2 AS
SELECT 
    C.customerID AS CustomerID,
    FS.stationID AS FromStationID,
    FS.stationName AS FromStationName,
    TS.stationID AS ToStationID,
    TS.stationName AS ToStationName,
    C.customerName AS CustomerName,
    TO_CHAR(B.bookingDate, 'yyyy-mm-dd') AS BookingDate,
    T.TrainName AS TrainName,
    TO_CHAR(TS.DepartureTime, 'HH24:MI') AS DepartureTime,
    B.seatsBooked AS NoOfSeats
FROM 
    Booking B
INNER JOIN 
    CUSTOMER_T C ON B.CustomerID = C.CustomerID
INNER JOIN 
    Train T ON B.TrainID = T.TrainID
INNER JOIN 
    TrainStops FS ON T.TrainID = FS.TrainID AND B.fromstation = FS.StationID
INNER JOIN 
    Station FSN ON FS.StationID = FSN.StationID
INNER JOIN 
    TrainStops TS ON T.TrainID = TS.TrainID AND B.tostation = TS.StationID
INNER JOIN 
    Station TSN ON TS.StationID = TSN.StationID;

CREATE OR REPLACE VIEW BookingDetails3 AS
SELECT 
    B.BookingID,
    B.CustomerID,
    T.TrainName AS TrainName,
    TO_CHAR(B.bookingDate, 'YYYY-MM-DD') AS BookingDate,
    B.seatsBooked AS SeatsBooked,
    FS.StationName AS FromStationName,
    TS.StationName AS ToStationName
FROM 
    Booking B
INNER JOIN 
    Train T ON B.TrainID = T.TrainID
INNER JOIN 
    Station FS ON B.fromstation = FS.StationID
INNER JOIN 
    Station TS ON B.tostation = TS.StationID;

-----------------------------SEQUENCES---------------------------

CREATE SEQUENCE customer_id_seq
    START WITH 11
    INCREMENT BY 1
    NOCACHE;

CREATE SEQUENCE manager_id_seq
    START WITH 10
    INCREMENT BY 5
    NOCACHE;

CREATE SEQUENCE station_id_seq
    START WITH 8
    INCREMENT BY 1
    NOCACHE;

CREATE SEQUENCE train_id_seq
    START WITH 1004
    INCREMENT BY 1
    NOCACHE;

CREATE SEQUENCE booking_id_seq
    START WITH 2003
    INCREMENT BY 1
    NOCACHE;

-------------------------VIEW-------------------------------

CREATE OR REPLACE VIEW TrainDetails AS
SELECT 
    T.TrainID,
    T.TrainName,
    T.SeatsCapacity,
    T.BasePrice,
    T.seatsLeft,
    LISTAGG(S.StationName, ', ') WITHIN GROUP (ORDER BY TS.DepartureTime) AS Stops
FROM 
    Train T
LEFT JOIN 
    TrainStops TS ON T.TrainID = TS.TrainID
LEFT JOIN 
    Station S ON TS.StationID = S.StationID
GROUP BY 
    T.TrainID, T.TrainName, T.SeatsCapacity, T.BasePrice, T.seatsLeft;
