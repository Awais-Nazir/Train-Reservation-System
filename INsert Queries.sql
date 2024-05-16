INSERT INTO Manager (ManagerID, managerContact, managerEmail, password)
VALUES
    (5, '03001234567', 'manager@domain.com', 'password1');
    
INSERT INTO Station Values (1,'Khanewal');

INSERT INTO Station Values (2,'Taxila');

INSERT INTO Station Values (3,'Islamabad');

INSERT INTO Station Values (4,'Rawalpindi');

INSERT INTO Station Values (5,'Lahore');

INSERT INTO Station Values (6,'Karachi');

INSERT INTO Station Values (7,'Multan');

INSERT INTO Train Values(1001,'khyber',50,500,500);
INSERT INTO Train Values(1002,'Hazara',100,500,100);

-- Assuming you know the TrainID and StationIDs
INSERT INTO TrainStops (TrainID, StationID, ArrivalTime, DepartureTime)
VALUES (1003, 1, NULL, TO_TIMESTAMP('2024-05-05 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO TrainStops (TrainID, StationID, ArrivalTime, DepartureTime)
VALUES (1003, 6, TO_TIMESTAMP('2024-05-06 01:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL);

INSERT INTO TrainStops (TrainID, StationID, ArrivalTime, DepartureTime)
VALUES (1003, 7, TO_TIMESTAMP('2024-05-05 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2024-05-05 13:10:00', 'YYYY-MM-DD HH24:MI:SS'));





SELECT t.TrainName, t.seatsLeft
FROM Train t
JOIN TrainStops ts1 ON t.TrainID = ts1.TrainID  -- Join for departure station
JOIN TrainStops ts2 ON t.TrainID = ts2.TrainID  -- Join for arrival station
JOIN Station s1 ON ts1.StationID = s1.StationID
JOIN Station s2 ON ts2.StationID = s2.StationID
WHERE s1.StationName = 'Khanewal'
  AND s2.StationName = 'Multan'
  AND ts1.DepartureTime < ts2.ArrivalTime
  AND TRUNC(ts1.DepartureTime) = DATE '2024-05-05'  -- Ensuring the journey starts on May 5, 2024
ORDER BY ts1.DepartureTime;




DECLARE
    v_cursor SYS_REFCURSOR;
    v_TrainName VARCHAR2(100);
    v_seatsLeft INT;
    v_baseprice INT;
    v_trainid INT;
BEGIN
    GetAvailableTrains('Khanewal', 'Karachi', DATE '2024-05-05', v_cursor);
    LOOP
        FETCH v_cursor INTO v_TrainName, v_seatsLeft, v_baseprice, v_trainid;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Train Name: ' || v_TrainName || ', Seats Left: ' || v_seatsLeft || ', Base Price: ' || v_baseprice || ', Train ID: ' || v_trainid);
    END LOOP;
    CLOSE v_cursor;
END;

SElect * from seats;

SELECT trainname from train where trainid = 1001;


INSERT into SEATS(SeatID,TrainID,SeatNumber) VAlues (&SeatID,&TrainID,'&SeatNumber');

SELECT SeatNumber FROM Seats WHERE TrainID = 1003 AND IsAvailable = 1;

SELECT TO_CHAR(DepartureTime,'YYYY-MM-DD HH24:MI') from TrainStops where TrainID=1003 AND trainstops.stationid=(Select stationid from Station where StationName='Multan');


--INSERT into Booking(BookingID,CustomerID,TrainID,bookingDate,seatsBooked Values (?,?,?,?,?);


SELECT * FROM BOOKING WHERE customerID=10;


SELECT  
    T.TrainName AS TrainName,
    b.bookingdate AS BookingDate,
    C.customerName AS CustomerName,
    TS.DepartureTime AS DepartureTime,
    B.seatsBooked AS NoOfSeats
FROM 
    Booking B
INNER JOIN 
    CUSTOMER_T C ON B.CustomerID = C.CustomerID
INNER JOIN 
    Train T ON B.TrainID = T.TrainID
INNER JOIN 
    TrainStops TS ON B.TrainID = TS.TrainID
WHERE 
    B.CustomerID = 10 AND ts.stationid=1; -- Replace :customerID with the actual CustomerID of the logged-in customer


SELECT Customer_T.customername from Customer_T
INNER JOIN booking B 
ON B.customerid=customer_t.customerid;

SELECT Train.TrainName from Train
INNER JOIN booking B 
ON B.trainid=train.trainid;

SELECT TS.departuretime from TrainStops TS
INNER JOIN booking B 
ON B.trainid=TS.trainid
WHERE stationid=1;

Select bookingdate from booking;




SELECT  
    T.TrainName AS TrainName,
    b.bookingdate AS BookingDate,
    C.customerName AS CustomerName,
    TS.DepartureTime AS DepartureTime,
    B.seatsBooked AS NoOfSeats,
    FS.StationName AS FromStation,
    TS2.StationName AS ToStation
FROM 
    Booking B
INNER JOIN 
    CUSTOMER_T C ON B.CustomerID = C.CustomerID
INNER JOIN 
    Train T ON B.TrainID = T.TrainID
INNER JOIN 
    TrainStops TS ON B.TrainID = TS.TrainID
INNER JOIN 
    TrainStops TS2 ON B.TrainID = TS2.TrainID
INNER JOIN 
    Station FS ON TS.StationID = FS.StationID
INNER JOIN 
    Station TS2 ON TS2.StationID = TS2.StationID
WHERE 
    B.CustomerID = 10 AND TS.StationID = 1; -- Replace :customerID with the actual CustomerID of the logged-in customer



SELECT * FROM BookingDetails Where customerID =10;

DELETE FROM Booking;







INSERT into Booking(BookingID,CustomerID,TrainID,bookingDate,seatsBooked,fromstation,tostation) Values (2001,10,1001,TO_TIMESTAMP('2024-05-05 11:00', 'YYYY-MM-DD HH24:MI'),4,,?)


UPDATE Train SET seatsLeft = seatsLeft - 10 WHERE TrainID = 1001;




DELETE FROM TRAIN
WHERE TrainName= 'demoName';


SELECT BookingID,CustomerID,TrainID,to_char(bookingDate,'yyyy-mm-dd')AS BookingDate,seatsBooked,fromstation,tostation from booking;

SELECT * from bookingdetails3;

SELECT * SELECT * from customer_T;
SELECT t.TrainName, t.seatsLeft
FROM Train t
JOIN TrainStops ts1 ON t.TrainID = ts1.TrainID  -- Join for departure station
JOIN TrainStops ts2 ON t.TrainID = ts2.TrainID  -- Join for arrival station
JOIN Station s1 ON ts1.StationID = s1.StationID
JOIN Station s2 ON ts2.StationID = s2.StationID
WHERE s1.StationName = 'Khanewal'
  AND s2.StationName = 'Islamabad'
  AND ts1.DepartureTime < ts2.ArrivalTime
  AND TRUNC(ts1.DepartureTime) = DATE '2024-05-05'  -- Ensuring the journey starts on May 5, 2024
ORDER BY ts1.DepartureTime;
SELECT DepartureTime from TrainStops where TrainID=1003 AND trainstops.stationid=(Select stationid from Station where StationName='Multan');
create table cus_tab(
cus_ID int primary key,
name varchar(20)
);

alter table cus_tab
add (p_Description varchar(20));

insert into cus_tab
values(&cus_ID,'&name','&p_Description');

select * from cus_tab;


create table order_Ta(
order_ID int primary key,
cus_ID int,
CONSTRAINT f_key FOREIGN key(cus_ID) REFERENCES cus_tab(cus_ID)
);

insert into order_ta
values(&order_ID,&cus_ID);

select * from order_ta;


create table product_tab(
p_ID int primary key,
p_price int
);

insert into product_tab
values(&p_ID,&p_price);


select * from product_tab;


-- example 1(What is the name and address of the customer who placed order 
-- number 1003?)

SELECT name,cus_ID
FROM cus_tab
 WHERE cus_tab.cus_ID=
 (SELECT order_Ta.cus_ID 
 FROM order_Ta 
 WHERE ORDER_ID=1006);
 
 
-- Query: Which customers have placed orders?

SELECT name
FROM cus_tab 
 WHERE cus_ID IN
 (SELECT DISTINCT cus_ID 
 FROM ORDER_Ta);
 
 
-- Query: Which customers have not placed any orders for computer desks?

SELECT name 
FROM cus_tab 
 WHERE cus_ID NOT IN
 (SELECT cus_ID FROM ORDER_Ta 
WHERE cus_tab.cus_ID = order_ta.cus_ID
AND p_Description='computer desk');


-- Query: What are the orders ID’s for all orders that have included furniture finished in 
-- natural ash?


SELECT DISTINCT cus_ID FROM cus_tab 
WHERE EXISTS (SELECT * FROM order_ta WHERE cus_ID= 
order_ta.cus_ID AND p_Description='computer desk');




-- co-related queries

SELECT p_ID 
 FROM PRODUCT_Tab PA 
 WHERE p_price > ALL
 (SELECT p_price FROM PRODUCT_Tab PB
 WHERE PB.P_ID != PA.P_ID);


-- Using Derived Tables:

SELECT P_ID,p_price 
FROM 
(SELECT AVG(p_PRICE) AVGPRICE FROM PRODUCT_Tab), PRODUCT_Tab 
WHERE p_PRICE > AVGPRICE;

-- -----------------------------------------TASKS---------------------------------------------------------

create table product_tab(
p_ID int primary key,
p_price int
);

insert into product_tab
values(&p_ID,&p_price);


select * from product_tab;

create table order_table2(
orderID int primary key,
p_ID int,
p_des varchar(20),
CONSTRAINT fk1 foreign key(p_ID) references product_tab(p_ID)
);

insert into order_table2
values(&orderID,&p_ID,'&p_des');

select * from order_table2;

create table cus_tab(
cus_ID int primary key,
name varchar(20)
);

alter table cus_tab
add (p_Description varchar(20));

insert into cus_tab
values(&cus_ID,'&name','&p_Description');

select * from cus_tab;


create table order_Ta(
order_ID int primary key,
cus_ID int,
CONSTRAINT f_key FOREIGN key(cus_ID) REFERENCES cus_tab(cus_ID)
);

insert into order_ta
values(&order_ID,&cus_ID);

select * from order_ta;

SELECT name 
FROM cus_tab 
 WHERE cus_ID NOT IN
 (SELECT cus_ID FROM ORDER_Ta 
WHERE cus_tab.cus_ID = order_ta.cus_ID
AND p_Description='computer desk');


SELECT name,cus_ID
FROM cus_tab
 WHERE cus_tab.cus_ID=
 (SELECT order_Ta.cus_ID 
 FROM order_Ta 
 WHERE ORDER_ID=1001);


-- task-3 (What is the total value of orders placed for each furniture product)


select p_price from product_tab
where product_tab.p_ID  IN (select p_ID from order_table2 where p_des='arch');

from traindetails;

SELECT * from booking;


SELECT * from customer_T;

SElect to_char(customerid,'9999')AS customerid,customername,customercontact,customercity, customergender,customeremail,customerpassword from customer_t;