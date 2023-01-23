
-- CS4400: Introduction to Database Systems (Fall 2021)
-- Phase III: Stored Procedures & Views [v0] Tuesday, November 9, 2021 @ 12:00am EDT
-- Team Kavin Phan (kphan32@gatech.edu)
-- Team Member Name (GT username)
-- Team Member Name (GT username)
-- Adrian Harris (aharris334)
-- Directions:
-- Please follow all instructions for Phase III as listed on Canvas.
-- Fill in the team number and names and GT usernames for all members above.

-- Use cs4400_phase3_stored_procedures_template_v1.sql to create the database

-- ID: 1a
-- Name: register_customer
drop procedure if exists register_customer;
delimiter //
create procedure register_customer (
    in i_email varchar(50),
    in i_first_name varchar(100),
    in i_last_name varchar(100),
    in i_password varchar(50),
    in i_phone_number char(12),
    in i_cc_number varchar(19),
    in i_cvv char(3),
    in i_exp_date date,
    in i_location varchar(50)
) 
sp_main: begin
	if i_email in (select Email from travel_reservation_service.Clients) and i_email in (SELECT Email FROM travel_reservation_service.Accounts)
		then insert into travel_reservation_service.Customer values (i_email, i_cc_number, i_cvv, i_exp_date, i_location);
	else
		insert into travel_reservation_service.Accounts values (i_email, i_first_name, i_last_name, i_password);
		insert into travel_reservation_service.Clients values (i_email, i_phone_number);
		insert into travel_reservation_service.Customer values (i_email, i_cc_number, i_cvv, i_exp_date, i_location);
	end if;
    
end //
delimiter ;

-- call register_customer('adrian@hotmail.com', 'Adrian', 'Harris', 'iiiiii', '123-456-7890', '1111-2222-3333-4444', '123', '2021-06-06', 'Bill Street');
-- call register_customer('falcon@gmail.com', 'Samuel', 'Wilson', 'password22', '777-469-5347', '9121 2762 7467 5215', '809', '2022-05-11', 'Baton Rouge'); 

-- ID: 1b
-- Name: register_owner
drop procedure if exists register_owner;
delimiter //
create procedure register_owner (
    in i_email varchar(50),
    in i_first_name varchar(100),
    in i_last_name varchar(100),
    in i_password varchar(50),
    in i_phone_number char(12)
) 
sp_main: begin
	if i_email in (select Email from travel_reservation_service.Clients) and i_email in (SELECT Email FROM travel_reservation_service.Accounts)
		then insert into travel_reservation_service.Owners values (i_email, i_cc_number, i_cvv, i_exp_date, i_location);
	else
		insert into travel_reservation_service.Accounts values (i_email, i_first_name, i_last_name, i_password);
		insert into travel_reservation_service.Clients values (i_email, i_phone_number);
		insert into travel_reservation_service.Owners values (i_email);
	end if;
    
end //
delimiter ;
-- call register_owner('bob@hotmail.com', 'Bob', 'Billy', '123454321', '800-000-7000');
-- call register_owner('worldchampion@gmail.com', 'Magnus', 'Carlsen', 'password25', '404-720-5367'); 

-- ID: 1c
-- Name: remove_owner
drop procedure if exists remove_owner;
delimiter //
create procedure remove_owner ( 
    in i_owner_email varchar(50)
)
sp_main: begin
	if i_owner_email in (SELECT distinct Owner_Email FROM travel_reservation_service.Property)
		then leave sp_main;
	elseif i_owner_email in (SELECT Email FROM travel_reservation_service.Customer)
		then delete from travel_reservation_service.Owners where i_owner_email = Email;
	else
		delete from travel_reservation_service.Owners where i_owner_email = Email;
		delete from travel_reservation_service.Clients where i_owner_email = Email;
		delete from travel_reservation_service.Accounts where i_owner_email = Email;
	end if;
    
end //
delimiter ;
-- call remove_owner('bob@hotmail.com')
-- call remove_owner('jseinfeld@gmail.com');

-- ID: 2a
-- Name: schedule_flight
drop procedure if exists schedule_flight;
delimiter //
create procedure schedule_flight (
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_from_airport char(3),
    in i_to_airport char(3),
    in i_departure_time time,
    in i_arrival_time time,
    in i_flight_date date,
    in i_cost decimal(6, 2),
    in i_capacity int,
    in i_current_date date
)
sp_main: begin
	if i_airline_name not in (select Airline_Name from travel_reservation_service.Airline)
		then leave sp_main; 
	elseif i_from_airport not in (select Airport_Id from travel_reservation_service.Airport)
		then leave sp_main;
	elseif i_to_airport not in (select Airport_Id from travel_reservation_service.Airport)
		then leave sp_main;
	elseif i_current_date > i_flight_date
		then leave sp_main;
	elseif i_arrival_time <= i_departure_time
		then leave sp_main;
	end if;
		insert into travel_reservation_service.Flight values (i_flight_num, i_airline_name, i_from_airport, i_to_airport, i_departure_time,
        i_arrival_time, i_flight_date, i_cost, i_capacity);
end //
delimiter ;

-- call schedule_flight('50', 'Delta Airlines', 'ATL', 'LGA', '13:00:00', '14:00:00', '2021-12-30', 600, 100, '2021-12-01');
-- call schedule_flight('52', 'Delta', 'ATL', 'LGA', '13:00:00', '14:00:00', '2021-12-30', 600, 100, '2021-12-01'); 
-- call schedule_flight('3', 'Southwest Airlines', 'MIA', 'DFW', '130000', '160000', '2021-10-18', 350, 125, '2021-10-04');

-- ID: 2b
-- Name: remove_flight
drop procedure if exists remove_flight;
delimiter //
create procedure remove_flight ( 
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_current_date date
) 
sp_main: begin
	if (i_flight_num, i_airline_name) not in (select Flight_Num, Airline_Name from travel_reservation_service.Flight)
		then leave sp_main;
	elseif i_current_date > (select Flight_Date from travel_reservation_service.Flight where i_flight_num = Flight_Num and i_airline_name = Airline_Name)
		then leave sp_main;
	elseif i_flight_num in (SELECT distinct Flight_Num FROM travel_reservation_service.Book)
		then delete from travel_reservation_service.Book where i_flight_num = Flight_Num;
        delete from travel_reservation_service.Flight where i_flight_num = Flight_Num and i_airline_name = Airline_Name;
	else
		delete from travel_reservation_service.Flight where i_flight_num = Flight_Num and i_airline_name = Airline_Name;
	end if;
end //
delimiter ;

-- call remove_flight('1', 'Delta Airlines', '2021-09-01');
-- call remove_flight('2', 'Southwest Airlines', '2021-08-01'); 


-- ID: 3a
-- Name: book_flight
drop procedure if exists book_flight;
delimiter //
create procedure book_flight (
    in i_customer_email varchar(50),
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_num_seats int,
    in i_current_date date
)
sp_main: begin
-- TODO: Implement your solution here
	if (i_flight_num, i_airline_name) not in (select Flight_Num, Airline_Name from travel_reservation_service.Flight)
		then leave sp_main;
	elseif i_customer_email not in (select Email from travel_reservation_service.Customer)
        then leave sp_main;
	elseif i_current_date > (select Flight_Date from travel_reservation_service.Flight 
        where i_flight_num = Flight_Num and i_airline_name = Airline_Name)
        then leave sp_main;
	elseif i_num_seats > ((SELECT Capacity FROM travel_reservation_service.Flight 
		where i_flight_num = Flight_Num and i_airline_name = Airline_Name) - (SELECT sum(Num_seats) FROM travel_reservation_service.Book
		group by Flight_Num
		having Flight_Num = i_flight_num))
        then leave sp_main;
	elseif (SELECT Flight_Date FROM travel_reservation_service.Flight
		where Flight_Num = i_flight_num) in (SELECT Flight_Date FROM travel_reservation_service.Book natural join Flight where Customer = i_customer_email
        and Was_Cancelled = 0)
        then leave sp_main;
	elseif (SELECT Num_seats FROM travel_reservation_service.Book where (i_flight_num, i_airline_name, i_customer_email) = (Flight_Num, Airline_Name, Customer)) + i_num_seats < ((SELECT Capacity FROM travel_reservation_service.Flight 
		where i_flight_num = Flight_Num and i_airline_name = Airline_Name) - (SELECT sum(Num_seats) FROM travel_reservation_service.Book
		group by Flight_Num
		having Flight_Num = i_flight_num))
        then update travel_reservation_service.Book set Num_seats =+ i_num_seats
        where (i_flight_num, i_airline_name, i_customer_email) = (Flight_Num, Airline_Name, Customer);
    elseif (i_flight_num, i_airline_name, i_customer_email) in (SELECT Flight_Num, Airline_Name, Customer FROM travel_reservation_service.Book
		where Was_Cancelled <> 0)
		then leave sp_main;
	else
		insert into travel_reservation_service.Book values (i_customer_email,i_flight_num,i_airline_name,i_num_seats,0);
	end if;
		

end //
delimiter ;
-- call book_flight('scooper3@gmail.com','9','Delta Airlines',2,'2021-10-10');
-- call book_flight('swilson@gmail.com','10','Delta Airlines',2,'2021-10-09');
-- call book_flight('scooper3@gmail.com', '2', 'Southwest Airlines', 122, '2021-10-01');

-- ID: 3b
-- Name: cancel_flight_booking
drop procedure if exists cancel_flight_booking;
delimiter //
create procedure cancel_flight_booking ( 
    in i_customer_email varchar(50),
    in i_flight_num char(5),
    in i_airline_name varchar(50),
    in i_current_date date
)
sp_main: begin
-- TODO: Implement your solution here
	if (i_flight_num,i_airline_name) not in (select Flight_Num, Airline_Name from travel_reservation_service.Flight)
		then leave sp_main;
	elseif (i_customer_email, i_flight_num, i_airline_name) in (SELECT Customer, Flight_Num, Airline_Name FROM travel_reservation_service.Book where Was_Cancelled = 0)
		then update travel_reservation_service.Book set travel_reservation_service.Book.Was_Cancelled =+ 1
		where (i_customer_email, i_flight_num, i_airline_name) = (Customer, Flight_Num, Airline_Name);
	end if;

end //
delimiter ;

-- call cancel_flight_booking('scooper3@gmail.com','9','Delta Airlines','2021-10-10');
-- call cancel_flight_booking('bshelton@gmail.com', '4', 'United Airlines', '2021-10-01'); 

-- ID: 3c
-- Name: view_flight
create or replace view view_flight (
    flight_id,
    flight_date,
    airline,
    destination,
    seat_cost,
    num_empty_seats,
    total_spent
) as
SELECT Flight_Num, Flight_Date, Airline_Name, To_Airport, Cost, (Capacity - IFNULL(BOOKED, 0)) as empty_seats, round(((IFNULL(booked, 0) * Cost) + (IFNULL(cancelled, 0) * 0.2 * Cost)), 3) as total FROM 
(SELECT concat(Flight_Num, Airline_Name) as id, Flight_Num, Airline_Name, Flight_Date, To_Airport, Cost, Capacity FROM travel_reservation_service.Flight)
as flight_table 
left join 
(select * from (select id, sum(booked) as booked, avg(cancelled) as cancelled from 
(select concat(book_seats.Flight_Num, book_seats.Airline_Name) as id, booked, cancelled from 
(SELECT Flight_Num, Airline_Name, Num_Seats as 'booked' FROM travel_reservation_service.Book where Was_Cancelled = 0) as book_seats
left join
(select Flight_Num, Airline_Name, Num_Seats as 'cancelled' FROM travel_reservation_service.Book where Was_Cancelled = 1) as cancel_seats
on book_seats.Flight_Num = cancel_seats.Flight_Num and book_seats.Airline_Name = cancel_seats.Airline_Name) as table_1 group by id) as left_table
union 
select id, sum(booked), avg(cancelled) from 
(select concat(cancel_seats.Flight_Num, cancel_seats.Airline_Name) as id, booked, cancelled from 
(SELECT Flight_Num, Airline_Name, Num_Seats as 'booked' FROM travel_reservation_service.Book where Was_Cancelled = 0) as book_seats
right join
(select Flight_Num, Airline_Name, Num_Seats as 'cancelled' FROM travel_reservation_service.Book where Was_Cancelled = 1) as cancel_seats
on book_seats.Flight_Num = cancel_seats.Flight_Num and book_seats.Airline_Name = cancel_seats.Airline_Name) as right_table group by id) as booking_table
on flight_table.id = booking_table.id;

-- ID: 4a
-- Name: add_property
drop procedure if exists add_property;
delimiter //
create procedure add_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_description varchar(500),
    in i_capacity int,
    in i_cost decimal(6, 2),
    in i_street varchar(50),
    in i_city varchar(50),
    in i_state char(2),
    in i_zip char(5),
    in i_nearest_airport_id char(3),
    in i_dist_to_airport int
) 
sp_main: begin
	if (i_owner_email) not in (select * from travel_reservation_service.Owners)
		then leave sp_main;
	elseif (i_nearest_airport_id) not in (SELECT Airport_Id FROM travel_reservation_service.Airport)
		then insert into travel_reservation_service.Property values (i_property_name, i_owner_email, i_description, i_capacity, i_cost, i_street, i_city, i_state, i_zip);
	elseif (i_property_name, i_owner_email) in (SELECT Property_Name, Owner_Email FROM travel_reservation_service.Property)
		then leave sp_main;
	else 
		insert into travel_reservation_service.Property values (i_property_name, i_owner_email, i_description, i_capacity, i_cost, i_street, i_city, i_state, i_zip);
		insert into travel_reservation_service.Is_Close_To values (i_property_name, i_owner_email, i_nearest_airport_id, i_dist_to_airport);
	end if;
        
end //
delimiter ;

-- call add_property('Stonebrook', 'aharris@gmail.com', 'This place is spacious and quiet.', 100, 300.00, '130 Street', 'Cityville', 'GA', '30332', 'ATL', 20);
-- call add_property('Stonebrook', 'arthurread@gmail.com', 'This place is spacious and quiet.', 100, 300.00, '130 Street', 'Cityville', 'GA', '30332', 'ATL', 20);


-- ID: 4b
-- Name: remove_property
drop procedure if exists remove_property;
delimiter //
create procedure remove_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_current_date date
)
sp_main: begin
	if (i_property_name, i_owner_email) not in (select Property_Name, Owner_Email from travel_reservation_service.Property)
		then leave sp_main;
	elseif i_current_date <= (select max(End_Date) from travel_reservation_service.Reserve where i_property_name = Property_Name and Was_Cancelled = 0)
        then leave sp_main;
	else
		delete from travel_reservation_service.Reserve where i_property_name = Property_Name and i_owner_email = Owner_Email;
		delete from travel_reservation_service.Property where i_property_name = Property_Name and i_owner_email = Owner_Email;
	end if;

end //
delimiter ;

-- call remove_property('Stonebrook', 'arthurread@gmail.com', '2021-02-13');
-- call remove_property('Beautiful San Jose Mansion', 'arthurread@gmail.com', '2020-02-02');
-- call remove_property('LA Lakers Property', 'lebron6@gmail.com', '2021-10-22');
-- call remove_property('LA Lakers Property', 'lebron6@gmail.com', '2023-10-22');

-- ID: 5a
-- Name: reserve_property
drop procedure if exists reserve_property;
delimiter //
create procedure reserve_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_start_date date,
    in i_end_date date,
    in i_num_guests int,
    in i_current_date date
)
sp_main: begin
	if i_current_date > i_start_date
		then leave sp_main;
	elseif (i_property_name, i_owner_email) not in (select Property_Name, Owner_Email from travel_reservation_service.Property)
        then leave sp_main;
	elseif i_customer_email not in (select Email from travel_reservation_service.Customer)
        then leave sp_main;
	elseif (SELECT Capacity FROM travel_reservation_service.Property where Property_Name = i_property_name)
        - (SELECT sum(Num_Guests) 
        FROM travel_reservation_service.Reserve
        where Start_Date <= i_start_date and end_Date >= i_end_date
        and (Property_Name, Owner_Email) = (i_property_name, i_owner_email) and Was_Cancelled = 0) < i_num_guests
        then leave sp_main;
	elseif (SELECT Capacity FROM travel_reservation_service.Property where Property_Name = i_property_name) < i_num_guests
        then leave sp_main;
	elseif (i_customer_email) in (SELECT Customer FROM travel_reservation_service.Reserve where start_Date <= i_start_date and End_Date >= i_end_date)
		then leave sp_main;
	end if;
    
		insert into travel_reservation_service.Reserve values (i_property_name, i_owner_email, i_customer_email, i_start_date, i_end_date, i_num_guests, 0);
        
end //
delimiter ;

-- call reserve_property('New York City Property', 'cbing10@gmail.com', 'tswift@gmail.com', '2022-09-09', '2022-09-17', '1', '2022-09-01');
-- call reserve_property('Beautiful San Jose Mansion', 'arthurread@gmail.com', 'johnthomas@gmail.com', '2021-10-19', '2021-10-22', 1, '2021-10-01');

-- ID: 5b
-- Name: cancel_property_reservation
drop procedure if exists cancel_property_reservation;
delimiter //
create procedure cancel_property_reservation (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_current_date date
)
sp_main: begin
	if (i_property_name, i_owner_email, i_customer_email) not in (select Property_Name, Owner_Email, Customer from travel_reservation_service.Reserve)
		then leave sp_main;
	elseif i_current_date >= (select Start_Date from travel_reservation_service.Reserve where (Property_Name, Owner_Email, Customer) = (i_property_name, i_owner_email, i_customer_email))
        then leave sp_main;
	elseif (i_property_name, i_owner_email, i_customer_email) in (select Property_Name, Owner_Email, Customer from travel_reservation_service.Reserve where Was_Cancelled = 1)
		then leave sp_main;
	end if;
    
		update travel_reservation_service.Reserve set Was_Cancelled = 1
        where (Property_Name, Owner_Email, Customer) = (i_property_name, i_owner_email, i_customer_email);
        
end //
delimiter ;

-- call cancel_property_reservation('Beautiful Beach Property', 'msmith5@gmail.com', 'tswift@gmail.com', '2021-10-10');
-- call cancel_property_reservation('Beautiful Beach Property', 'msmith5@gmail.com', 'cbing10@gmail.com', '2021-10-01');


-- ID: 5c
-- Name: customer_review_property
drop procedure if exists customer_review_property;
delimiter //
create procedure customer_review_property (
    in i_property_name varchar(50),
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_content varchar(500),
    in i_score int,
    in i_current_date date
)
sp_main: begin
	if (i_property_name, i_owner_email, i_customer_email) not in (select Property_Name, Owner_Email, Customer from 
    travel_reservation_service.Reserve where Was_Cancelled = 0)
		then leave sp_main;
	elseif i_current_date < (select Start_Date from travel_reservation_service.Reserve 
        where (Property_Name, Owner_Email, Customer) = (i_property_name, i_owner_email, i_customer_email))
        then leave sp_main;
	elseif (i_property_name, i_owner_email, i_customer_email) in (SELECT Property_Name, Owner_Email, Customer FROM travel_reservation_service.Review)
		then leave sp_main;
	end if;
    
		insert into travel_reservation_service.Review values (i_property_name, i_owner_email, i_customer_email, i_content, i_score);
        
end //
delimiter ;

-- call customer_review_property('Beautiful Beach Property', 'msmith5@gmail.com', 'cbing10@gmail.com', 'This property was amazing!', 5, '2021-12-19');
-- call customer_review_property('New York City Property', 'cbing10@gmail.com', 'tswift@gmail.com', 'Property is the bomb', 4, '2029-10-19');

-- ID: 5d
-- Name: view_properties
create or replace view view_properties (
    property_name, 
    average_rating_score, 
    description, 
    address, 
    capacity, 
    cost_per_night
) as
select property_name, average_rating_score, description, address, capacity, cost_per_night from (
	(
		select property.Property_Name as property_name, property.Descr as description, concat(property.Street, ', ', property.City, ', ', property.State, ', ', property.Zip) as address, property.Capacity as capacity, property.Cost as cost_per_night
		from property
	)
    as Property_Info_Table

	natural join
    
	(
		select property.Property_Name as property_name, avg(review.Score) as average_rating_score
		from property
		left join review on property.Property_Name = review.Property_name
		group by property.Property_Name
	)
    as Average_Rating_Table
);

-- ID: 5e
-- Name: view_individual_property_reservations
drop procedure if exists view_individual_property_reservations;
delimiter //
create procedure view_individual_property_reservations (
    in i_property_name varchar(50),
    in i_owner_email varchar(50)
)
sp_main: begin
	if (i_property_name, i_owner_email) not in (SELECT Property_Name, Owner_Email FROM travel_reservation_service.Property)
		then create table view_individual_property_reservations (
        property_name varchar(50),
        start_date date,
        end_date date,
        customer_email varchar(50),
        customer_phone_num char(12),
        total_booking_cost decimal(6,2),
        rating_score int,
        review varchar(500));
	else 
		drop table if exists view_individual_property_reservations;
		create table view_individual_property_reservations (
        property_name varchar(50),
        start_date date,
        end_date date,
        customer_email varchar(50),
        customer_phone_num char(12),
        total_booking_cost decimal(6,2),
        rating_score int,
        review varchar(500)
		) as
			select customer_res.Property_Name, Start_Date, End_Date, Email as customer_email, Phone_Number as customer_phone_num, ((End_Date - Start_Date + 1) * total) as total_booking_cost, Score as rating_score, Content as review from Review 
			right join
			(select Property_Name, Owner_Email, Customer, Start_Date, End_Date, Num_Guests, Email, Phone_Number, 
			((((((cast(Was_Cancelled as decimal(10,0)))- 1) * -1 * Cost) + ((cast(Was_Cancelled as decimal(10,0))) * 0.2 * Cost)))) as 'total'
			from (SELECT * FROM travel_reservation_service.Reserve
			join Clients on Reserve.Customer = Clients.Email) as customer_res
			natural join
			(select Property_Name, Cost from travel_reservation_service.Property) as property_cost) as customer_res
			on (Review.Property_Name, Review.Owner_Email, Review.Customer) =  (customer_res.Property_Name, customer_res.Owner_Email, customer_res.Email)
			where customer_res.Property_Name = i_property_name and customer_res.Owner_Email = i_owner_email;
    
	end if;
end //
delimiter ;

-- call view_individual_property_reservations('Beautiful Beach Property', 'msmith5@gmail.com');
-- call view_individual_property_reservations('New York City Property', 'cbing10@gmail.com');



-- ID: 6a
-- Name: customer_rates_owner
drop procedure if exists customer_rates_owner;
delimiter //
create procedure customer_rates_owner (
    in i_customer_email varchar(50),
    in i_owner_email varchar(50),
    in i_score int,
    in i_current_date date
)
sp_main: begin
	if (i_customer_email, i_owner_email) not in (SELECT Customer, Owner_Email FROM travel_reservation_service.Reserve where Was_Cancelled = 0)
		then leave sp_main;
	elseif i_current_date < (SELECT max(End_Date) FROM travel_reservation_service.Reserve where Owner_Email = i_owner_email and Customer = i_customer_email)
        then leave sp_main;
	elseif (i_customer_email, i_owner_email) in (SELECT Customer, Owner_Email FROM travel_reservation_service.Customers_Rate_Owners)
		then leave sp_main;
	elseif i_customer_email not in (SELECT Email FROM travel_reservation_service.Customer)
		then leave sp_main;
	elseif i_owner_email not in (SELECT * FROM travel_reservation_service.Owners)
		then leave sp_main;
	else 
		insert into Customers_Rate_Owners values(i_customer_email, i_owner_email, i_score);
	end if;
        
end //
delimiter ;

-- call customer_rates_owner('tswift@gmail.com', 'cbing10@gmail.com', 5, '2023-03-18');
-- call customer_rates_owner('cbing10@gmail.com', 'msmith5@gmail.com', 3, '2021-10-18');


-- ID: 6b
-- Name: owner_rates_customer
drop procedure if exists owner_rates_customer;
delimiter //
create procedure owner_rates_customer (
    in i_owner_email varchar(50),
    in i_customer_email varchar(50),
    in i_score int,
    in i_current_date date
)
sp_main: begin
	if (i_owner_email, i_customer_email) not in (SELECT Owner_Email, Customer FROM travel_reservation_service.Reserve
	where Was_Cancelled = 0)
		then leave sp_main;
	elseif i_current_date < (SELECT max(End_Date) FROM travel_reservation_service.Reserve
		where Was_Cancelled = 0 and Owner_Email = i_owner_email and Customer = i_customer_email)
        then leave sp_main;
	elseif (i_customer_email, i_owner_email) in (SELECT Customer, Owner_Email FROM travel_reservation_service.Owners_Rate_Customers)
		then leave sp_main;
	else
		insert into Owners_Rate_Customers values(i_owner_email, i_customer_email, i_score);
	end if;
end //
delimiter ;

-- call owner_rates_customer('mgeller5@gmail.com', 'bshelton@gmail.com', 1, '2008-03-15');
-- call customer_rates_owner('cbing10@gmail.com', 'tswift@gmail.com', 5, '2023-12-12');



-- ID: 7a
-- Name: view_airports
create or replace view view_airports (
    airport_id, 
    airport_name, 
    time_zone, 
    total_arriving_flights, 
    total_departing_flights, 
    avg_departing_flight_cost
) as
-- TODO: replace this select query with your solution    
select Airport_ID, Airport_Name, Time_zone, total_arriving_flights, total_departing_flights, avg_departing_flight_cost from (
(select (CASE arrive_airport when not null then arrive_airport else depart_airport end) as airport, COALESCE(total_arriving_flights, 0) as total_arriving_flights, COALESCE(total_departing_flights, 0) as total_departing_flights, avg_departing_flight_cost as avg_departing_flight_cost from
    ( 
		(select To_Airport as arrive_airport, count(To_Airport) as total_arriving_flights
			from Flight
			group by To_Airport
		) as To_Airport_Table right join
		(select From_Airport as depart_airport, count(From_Airport) as total_departing_flights, avg(Cost) as avg_departing_flight_cost
			from Flight
			group by From_Airport
		) as From_Airport_Table on To_Airport_Table.arrive_airport = From_Airport_Table.depart_airport
	 )

union

select (CASE depart_airport when not null then depart_airport else arrive_airport end) as airport, COALESCE(total_arriving_flights, 0) as total_arriving_flights, COALESCE(total_departing_flights, 0) as total_departing_flights, avg_departing_flight_cost as avg_departing_flight_cost from
    ( 
		(select To_Airport as arrive_airport, count(To_Airport) as total_arriving_flights
			from Flight
			group by To_Airport
		) as To_Airport_Table left join
		(select From_Airport as depart_airport, count(From_Airport) as total_departing_flights, avg(Cost) as avg_departing_flight_cost
			from Flight
			group by From_Airport
		) as From_Airport_Table on To_Airport_Table.arrive_airport = From_Airport_Table.depart_airport
)) as datas join airport on airport.Airport_ID = datas.airport
);

-- ID: 7b
-- Name: view_airlines
create or replace view view_airlines (
    airline_name, 
    rating, 
    total_flights, 
    min_flight_cost
) as
-- TODO: replace this select query with your solution
select airline_name, rating, total_flights, min_flight_cost from (
	(
		select airline.Airline_Name as airline_name, airline.Rating as rating
		from airline
	)
    as Airline_Name_and_Rating_Table

	natural join

	(
		select airline.Airline_Name as airline_name, count(flight.Flight_Num) as total_flights
		from airline
		left join flight on airline.Airline_Name = flight.Airline_Name
		group by airline.Airline_Name
	)
    as Total_Flights_Table
    
    natural join
    
    (
		select airline.Airline_Name as airline_name, min(flight.Cost) as min_flight_cost
		from airline
		left join flight on airline.Airline_Name = flight.Airline_Name
		group by airline.Airline_Name
	)
    as Min_Flight_Cost_Table
);


-- ID: 8a
-- Name: view_customers
create or replace view view_customers (
    customer_name, 
    avg_rating, 
    location, 
    is_owner, 
    total_seats_purchased
) as
-- TODO: replace this select query with your solution
-- view customers
select customer_name, avg_rating, location, is_owner, total_seats_purchased from (
	(
		select customer.Email as customer_email, concat(accounts.First_Name, ' ', accounts.Last_Name) as customer_name, customer.Location as location
		from customer
		join accounts on customer.Email = accounts.Email
	)
    as Name_And_Location_Table

	natural join

	(
		select customer.Email as customer_email, avg(owners_rate_customers.Score) as avg_rating
		from customer
		left join owners_rate_customers on customer.Email = owners_rate_customers.Customer
		group by customer.Email
	)
    as Avg_Rating_Table

	natural join

	(
		select customer.Email as customer_email, count(owners.Email) as is_owner
		from customer
		left join owners on customer.Email = owners.Email
		group by customer.Email
	)
    as Is_Owner_Table

	natural join

	(
		select customer.Email as customer_email, coalesce(sum(book.Num_Seats), 0) as total_seats_purchased
		from customer
		left join book on customer.Email = book.Customer
		group by customer.Email
	)
    as Total_Seats_Purchased_Table
);


-- ID: 8b
-- Name: view_owners
create or replace view view_owners (
    owner_name, 
    avg_rating, 
    num_properties_owned, 
    avg_property_rating
) as
-- TODO: replace this select query with your solution
select owner_name, avg_rating, num_properties_owned, avg_property_rating from (
	(
		select owners.Email as owner_email, concat(accounts.First_Name, ' ', accounts.Last_Name) as owner_name
		from owners
		join accounts on owners.Email = accounts.Email
	)
    as Name_Table

	natural join

	(
		select owners.Email as owner_email, avg(customers_rate_owners.Score) as avg_rating
		from owners
		left join customers_rate_owners on owners.Email = customers_rate_owners.Owner_Email
		group by owners.Email
	)
    as Avg_Rating_Table
    
	natural join
    
	(
		select owners.Email as owner_email, count(property.Property_Name) as num_properties_owned
		from owners
		left join property on owners.Email = property.Owner_Email
		group by owners.Email
	)
    as Num_Properties_Owned_Table
    
	natural join
    
	(
		select owners.Email as owner_email, avg(review.Score) as avg_property_rating
		from owners
		left join review on owners.Email = review.Owner_Email
		group by owners.Email
	)
    as Avg_Property_Rating_Table
);


-- ID: 9a
-- Name: process_date
drop procedure if exists process_date;
delimiter //
create procedure process_date ( 
    in i_current_date date
)
sp_main: begin

update customer c
	join book as b on c.Email = b.Customer
	join flight as f on b.Flight_Num = f.Flight_Num
	join airport as a on f.To_Airport = a.Airport_Id
set c.Location = a.State
where b.Was_Cancelled = 0 and f.Flight_Date = i_current_date;

end //
delimiter ;   

call process_date('2021-10-19');

