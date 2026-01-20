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
 CREATE VIEW Incomplete_Rides_Reason AS
    SELECT 
        `Booking ID`, `Incomplete Rides Reason`
    FROM
        ola_booking
    WHERE
        `Incomplete Rides` = 1;
 #select * from Incomplete_Rides_Reason;
  
  #11.Retrieve the top 5 pickup locations based on number of bookings.
  CREATE VIEW Top_Location_P AS
    SELECT 
        `Pickup Location`,
        COUNT(`Booking ID`) AS Total_Number_Booking
    FROM
        ola_booking
    GROUP BY `Pickup Location`
    ORDER BY Total_Number_Booking DESC;
#select * from Top_Location_P;

#12.Identify vehicle types with the highest cancellation rate.
create view Highest_Cancellation_v as
SELECT 
    `Vehicle Type`,
    COUNT(`Booking Status`) AS total_Booking,
    SUM(CASE
        WHEN
            `Booking Status` = 'Cancelled by Customer'
                OR `Booking Status` = 'Cancelled by Driver'
        THEN
            1
        ELSE 0
    END) AS Total_Cancellation,
    ROUND(SUM(CASE
                WHEN
                    `Booking Status` = 'Cancelled by Customer'
                        OR `Booking Status` = 'Cancelled by Driver'
                THEN
                    1
                ELSE 0
            END) / COUNT(*) * 100,
            2) AS Cancellation_Rate
FROM
    ola_booking
GROUP BY `Vehicle Type`
ORDER BY Cancellation_Rate DESC;
#select *  from  Highest_Cancellation_v;

#13.Find the hour of the day with the maximum number of bookings.
CREATE VIEW Hour_of_Day AS
    SELECT 
        HOUR(Time) AS Hours, COUNT(*) AS Total_Hours_Booking
    FROM
        ola_booking
    GROUP BY Hours
    ORDER BY Total_Hours_Booking
    LIMIT 1;
#select * from Hour_of_Day;

#14.Find pickup–drop combinations used more than 30 times.
CREATE VIEW pickup–drop_count AS
    SELECT 
        'Pickup Location', 'Drop Location', COUNT(*) AS total_trip
    FROM
        ola_booking
    GROUP BY 'Pickup Location' , 'Drop Location'
    HAVING COUNT(*) > 30
    ORDER BY total_trip DESC;
# select * from pickup–drop_count;

#15.Find customers who cancelled rides more than 3 times in the month.
create view Fake_Customer as
SELECT 
    `Customer ID`,
    MONTH(Date) AS month_no,
    COUNT(`Cancelled Rides by Customer`) AS Total_cancel
FROM
    ola_booking
GROUP BY month_no , `Customer ID`
HAVING Total_cancel > 3
ORDER BY Total_cancel DESC;

#select * from Fake_Customer;

#16.Identify inactive customers who have only 1 booking for the entire month.
CREATE VIEW Inactive AS
    SELECT 
        `Customer ID`, MONTH(Date) AS month_no, COUNT(*)
    FROM
        ola_booking
    GROUP BY `Customer ID` , month_no
    HAVING COUNT(*) = 1;
#select * from Inactive;

#17.Retrieve all rides where:driver rating >= 4.5 and BUT customer rating <=3.5 
CREATE VIEW rating_mismatch AS
    SELECT 
        *
    FROM
        ola_booking
    WHERE
        `Driver Ratings` >= 4.5
            AND `Customer Rating` <= 3.5;
#select * from rating_mismatch;

 #18.Calculate average revenue per km for each vehicle type.
create view Average_Revenue as
SELECT 
    `Vehicle Type`,
    SUM(`Booking Value (INR)`) /
    SUM(`Ride Distance (km)`) 
     AS AVG_revenue
FROM
    ola_booking
group by `Vehicle Type` 
order by AVG_revenue desc;
#select * from Average_Revenue;

#19.Find ride distance variance (min, max, avg, stddev) for each vehicle type.
create view Distance_var as
SELECT 
    `Vehicle Type`,
    MIN(`Ride Distance (km)`) AS min_distance,
    MAX(`Ride Distance (km)`) AS max_distance,
    AVG(`Ride Distance (km)`) AS avg_distance,
    STDDEV(`Ride Distance (km)`) AS stddev_distance
FROM ola_booking
WHERE 
    `Ride Distance (km)` NOT IN ('NA', '')
    AND `Ride Distance (km)` IS NOT NULL
GROUP BY `Vehicle Type`
#select * from Distance_var;

#20.Get the distribution of booking status per day (success, cancelled, incomplete).
CREATE VIEW Distribution_day AS
    SELECT 
        Date, `Booking Status`, COUNT(*) AS Total_Booking
    FROM
        ola_booking
    GROUP BY Date , `Booking Status`
    ORDER BY Date , `Booking Status`; 
#select * from Distribution_day;

#21.
SELECT
    Date,
    SUM(CASE WHEN `Booking Status` = 'Successful' THEN 1 ELSE 0 END) AS successful_rides,
    COUNT(*) AS total_rides,
    (SUM(CASE WHEN `Booking Status` = 'Successful' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS success_rate_percentage
FROM ola_booking
GROUP BY Date
HAVING success_rate_percentage < 30
ORDER BY success_rate_percentage ASC;
