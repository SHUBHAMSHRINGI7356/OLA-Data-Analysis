create database OLA;
use OLA;
ALTER TABLE ola_booking
ADD COLUMN payment_mode VARCHAR(20);
SET SQL_SAFE_UPDATES = 1;
UPDATE ola_booking
SET payment_mode = ELT(
    FLOOR(1 + RAND() * 5),
    'Cash', 'UPI', 'Card', 'Wallet', 'NetBanking'
);

SELECT 
    *
FROM
    ola_booking;
 # 1. Retrieve all successful bookings:
 CREATE VIEW Successful_Bookings AS
    SELECT 
        *
    FROM
        ola_booking
    WHERE
        `Booking Status` = 'Successful';
 # select * from Successful_Bookings;

 # 2. Find the average ride distance for each vehicle type:
 CREATE VIEW Ride_Distance AS
    SELECT 
        `Vehicle Type`, AVG(`Ride Distance (km)`) AS avg_ride_dis
    FROM
        ola_booking
    GROUP BY `Vehicle Type`;
# select * from Ride_Distance;

#3.Get the total number of cancelled rides by customers:
CREATE VIEW Total_Cancelled_Ride_by_Customers AS
    SELECT 
        COUNT(*) AS Cancelled_Rides_by_C
    FROM
        ola_booking
    WHERE
        `Booking Status` = 'Cancelled by Customer';
#select * from Total_Cancelled_Ride_by_customers;

#4.List the top 5 customers who booked the highest number of rides:
CREATE VIEW Top_Customers AS
    SELECT 
        `Customer ID`,
        COUNT(`Booking ID`) AS Total_Booking_by_Customer
    FROM
        ola_booking
    GROUP BY `Customer ID`
    ORDER BY Total_Booking_by_Customer DESC
    LIMIT 5;
 # select * from Top_Customers;
 
#5. Get the number of rides cancelled by drivers due to personal and car-related issues:
CREATE VIEW Cancel_by_driver_PC AS
    SELECT 
        COUNT(*) AS Driver_Cancel_PC
    FROM
        ola_booking
    WHERE
        `Reason for cancelling by Driver` = 'Personal & Car related issues';
# select * from Cancel_by_driver_PC;

#6.Find the maximum and minimum driver ratings for Prime Sedan bookings: 
CREATE VIEW Driver_Rating_Prime_S AS
    SELECT 
        `Vehicle Type`,
        MAX(`Driver Ratings`) AS Maximum_Rating_P,
        MIN(`Driver Ratings`) AS Minimum_Rating_P
    FROM
        ola_booking
    WHERE
        `Vehicle Type` = 'Prime Sedan'
            AND `Driver Ratings` NOT IN ('NA' , '')
            AND `Driver Ratings` IS NOT NULL;
#select * from Driver_Rating_Prime_S;
		
#7. Retrieve all rides where payment was made using UPI:
CREATE VIEW UPI_Rides AS
    SELECT 
        *
    FROM
        ola_booking
    WHERE
        payment_mode = 'UPI';
# select * from UPI_Rides;

#8. Find the average customer rating per vehicle type:
CREATE VIEW Average_Vehicle_Rating AS
    SELECT 
        `Vehicle Type`, AVG(`Customer Rating`) AS AVG_Customer_R
    FROM
        ola_booking
    GROUP BY `Vehicle Type`;
#select * from Average_Vehicle_Rating; 

#9.Calculate the total booking value of rides completed successfully: 
CREATE VIEW Total_Booking_Value_Successfully AS
    SELECT 
        SUM(`Booking Value (INR)`) AS Booking_Value_Successfully
    FROM
        ola_booking
    WHERE
        `Booking Status` = 'Successful';
 #select * from Total_Booking_Value_Successfully;
 
 #10. List all incomplete rides along with the reason:
 create view Incomplete_Rides_Reason as
 select `Booking ID`,`Incomplete Rides Reason` from ola_booking where`Incomplete Rides` = 1;
 
 select * from Incomplete_Rides_Reason;
 