# STOCK MARKET ANALYSIS

# create Database
Create database Assignment;

# Use the created Database
USE `Assignment`;
set SQL_SAFE_UPDATES = 0;  # This ensures that columns are updated without error 



# The given Stock Market tables are imported completely using Import Table Wizard 
#under the same name as given

# Creating Stock tables
# table from Bajaj Auto
CREATE TABLE bajaj1
  AS (SELECT str_to_date(Date,'%e-%M-%Y') as Date, `Close Price`
  FROM `Bajaj Auto`
  ORDER BY (Date));

# Table from Eicher Motors
  CREATE TABLE Eicher1
	AS (SELECT str_to_date(Date,'%e-%M-%Y') as Date, `Close Price`
	FROM `Eicher Motors`
	ORDER BY (Date)); 

#Table from Hero Motocorp
CREATE TABLE Hero1
  AS (SELECT str_to_date(Date,'%e-%M-%Y') as Date, `Close Price`
  FROM `Hero Motocorp`
  ORDER BY (Date));
  
 # Table from TCS 
  CREATE TABLE TCS1
	AS (SELECT str_to_date(Date,'%e-%M-%Y') as Date, `Close Price`
	FROM `TCS`
	ORDER BY (Date));
  
 # Table from Infosys
   
  CREATE TABLE Infosys1
	AS (SELECT str_to_date(Date,'%e-%M-%Y') as Date, `Close Price`
	FROM `Infosys`
	ORDER BY (Date));
  
  # table from TVS
  CREATE TABLE TVS1
	AS (SELECT str_to_date(Date,'%e-%M-%Y') as Date, `Close Price`
	FROM `TVS Motors`
	ORDER BY (Date));
  
  #Dislpaying the columns in bajaj1
  Select * from bajaj1;
  
 
 # Altering the tables to include 20 DAY and 50 DAY Moving Averages columns

alter table bajaj1
    add `20 DAY MA` Decimal(10,2),
    add `50 DAY MA` Decimal(10,2);

alter table Eicher1
	add `20 DAY MA` Decimal(10,2),
	add`50 DAY MA` Decimal(10,2);
    
alter table Hero1
	add `20 DAY MA` Decimal(10,2),
	add`50 DAY MA` Decimal(10,2);
    
alter table Infosys1
	add `20 DAY MA` Decimal(10,2),
	add`50 DAY MA` Decimal(10,2);

alter table TCS1
	add `20 DAY MA` Decimal(10,2),
	add`50 DAY MA` Decimal(10,2);
    
alter table TVS1
	add `20 DAY MA` Decimal(10,2),
	add`50 DAY MA` Decimal(10,2);
    
# Updating the tables with Moving Average values 


   UPDATE bajaj1 b 
    JOIN (
           SELECT Date,avg(`Close Price`) over(order by Date rows 19 preceding) AS ave1,
           avg(`Close Price`) over(order by Date rows 49 preceding) AS ave2
           FROM bajaj1
		 )b1
    ON b1.Date=b.Date
    SET b.`20 DAY MA`=round(b1.ave1,2),  b.`50 DAY MA`=round(b1.ave2,2);
    
   UPDATE Eicher1 e
    JOIN (
           SELECT Date,avg(`Close Price`) over(order by Date rows 19 preceding) AS ave1,
           avg(`Close Price`) over(order by Date rows 49 preceding) AS ave2
           FROM Eicher1
		 )e1
    ON e1.Date=e.Date
    SET e.`20 DAY MA`=round(e1.ave1,2),  e.`50 DAY MA`=round(e1.ave2,2);    
    
    UPDATE Hero1 h
    JOIN (
           SELECT Date,avg(`Close Price`) over(order by Date rows 19 preceding) AS ave1,
           avg(`Close Price`) over(order by Date rows 49 preceding) AS ave2
           FROM Hero1
		 )h1
    ON h1.Date=h.Date
    SET h.`20 DAY MA`=round(h1.ave1,2),  h.`50 DAY MA`=round(h1.ave2,2);  
    
	UPDATE Infosys1 i
    JOIN (
           SELECT Date,avg(`Close Price`) over(order by Date rows 19 preceding) AS ave1,
           avg(`Close Price`) over(order by Date rows 49 preceding) AS ave2
           FROM Infosys1
		 )i1
    ON i1.Date=i.Date
    SET i.`20 DAY MA`=round(i1.ave1,2),  i.`50 DAY MA`=round(i1.ave2,2); 
    
	UPDATE TCS1 t
    JOIN (
           SELECT Date,avg(`Close Price`) over(order by Date rows 19 preceding) AS ave1,
           avg(`Close Price`) over(order by Date rows 49 preceding) AS ave2
           FROM TCS1
		 )t1
    ON t1.Date=t.Date
    SET t.`20 DAY MA`=round(t1.ave1,2),  t.`50 DAY MA`=round(t1.ave2,2); 
    
	UPDATE TVS1 tv
    JOIN (
           SELECT Date,avg(`Close Price`) over(order by Date rows 19 preceding) AS ave1,
           avg(`Close Price`) over(order by Date rows 49 preceding) AS ave2
           FROM TVS1
		 )tv1
    ON tv1.Date=tv.Date
    SET tv.`20 DAY MA`=round(tv1.ave1,2),  tv.`50 DAY MA`=round(tv1.ave2,2); 
    
    
 # Creating the master table using Date as the Common Key
  CREATE TABLE master 
    AS (
      SELECT Date,b.`Close Price` as Bajaj, t.`Close Price` as TCS, tv.`Close Price` as TVS,
	  i.`Close Price` as Infosys, e.`Close Price` as Eicher,h.`Close Price` as `Hero`
	  FROM bajaj1 b
      INNER JOIN TCS1 t
      USING(Date)
      INNER JOIN  TVS1 tv
	  USING(Date)
	  INNER JOIN Infosys1 i
      USING(Date)
      INNER JOIN Eicher1 e
      USING(Date)
      INNER JOIN Hero1 h
      USING(Date)
);
# Creating Tables with BUY/ SELL Signal
# If a sign change is found in successive rows, 
#it indicates a cross.(Golden cross- +ve, Death cross -ve sign change)
CREATE TABLE bajaj2
    AS(SELECT  Date,`Close Price`,
	      (case 
			when (`20 DAY MA` - `50 DAY MA`) > 0 and (LAG(`20 DAY MA`,1) OVER () - LAG(`50 DAY MA`,1)OVER()) <=0
			then 'BUY'
			when (`20 DAY MA` - `50 DAY MA`) < 0 and (LAG(`20 DAY MA`,1) OVER () - LAG(`50 DAY MA`,1)OVER()) >=0
			then 'SELL'
			else 'HOLD'
			end) as 'Signal'
   FROM bajaj1);

CREATE TABLE Eicher2
    AS(SELECT  Date,`Close Price`,
	       (case 
			when (`20 DAY MA` - `50 DAY MA`) > 0 and (LAG(`20 DAY MA`,1) OVER () - LAG(`50 DAY MA`,1)OVER()) <=0
			then 'BUY'
			when (`20 DAY MA` - `50 DAY MA`) < 0 and (LAG(`20 DAY MA`,1) OVER () - LAG(`50 DAY MA`,1)OVER()) >=0
			then 'SELL'
			else 'HOLD'
			end) as 'Signal'
	   FROM Eicher1);
       
CREATE TABLE Hero2
    AS(SELECT  Date,`Close Price`,
		   (case 
			when (`20 DAY MA` - `50 DAY MA`) > 0 and (LAG(`20 DAY MA`,1) OVER () - LAG(`50 DAY MA`,1)OVER()) <=0
			then 'BUY'
			when (`20 DAY MA` - `50 DAY MA`) < 0 and (LAG(`20 DAY MA`,1) OVER () - LAG(`50 DAY MA`,1)OVER()) >=0
			then 'SELL'
			else 'HOLD'
			end) as 'Signal'
    FROM Hero1);

CREATE TABLE Infosys2
    AS(SELECT  Date,`Close Price`,
	     (case 
			when (`20 DAY MA` - `50 DAY MA`) > 0 and (LAG(`20 DAY MA`,1) OVER () - LAG(`50 DAY MA`,1)OVER()) <=0
			then 'BUY'
			when (`20 DAY MA` - `50 DAY MA`) < 0 and (LAG(`20 DAY MA`,1) OVER () - LAG(`50 DAY MA`,1)OVER()) >=0
			then 'SELL'
			else 'HOLD'
		end) as 'Signal'
	FROM Infosys1);

CREATE TABLE TCS2
    AS(SELECT  Date,`Close Price`,
		   (case 
			when (`20 DAY MA` - `50 DAY MA`) > 0 and (LAG(`20 DAY MA`,1) OVER () - LAG(`50 DAY MA`,1)OVER()) <=0
			then 'BUY'
			when (`20 DAY MA` - `50 DAY MA`) < 0 and (LAG(`20 DAY MA`,1) OVER () - LAG(`50 DAY MA`,1)OVER()) >=0
			then 'SELL'
			else 'HOLD'
			end) as 'Signal'
    FROM TCS1);

CREATE TABLE TVS2
    AS(SELECT  Date,`Close Price`,
		(case 
			when (`20 DAY MA` - `50 DAY MA`) > 0 and (LAG(`20 DAY MA`,1) OVER () - LAG(`50 DAY MA`,1)OVER()) <=0
			then 'BUY'
			when (`20 DAY MA` - `50 DAY MA`) < 0 and (LAG(`20 DAY MA`,1) OVER () - LAG(`50 DAY MA`,1)OVER()) >=0
			then 'SELL'
			else 'HOLD'
			end) as 'Signal'
	   FROM TVS1);

# Creating the User Defined function to return Buy/Sell signal
Delimiter $$

CREATE FUNCTION udf_Signal (d date) 
	RETURNS varchar(4) DETERMINISTIC
	 BEGIN
		DECLARE s varchar(4);
		SET s=(Select `Signal`      # Reading the signal column from bajaj2 Table when the Dates match 
			   from bajaj2
               where Date=d); 
        RETURN s;
	END 
$$

Delimiter ;

# Calling the user defined function
select udf_signal('2015-05-18') as `signal`;
