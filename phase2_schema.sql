DROP DATABASE IF EXISTS reservations;
CREATE DATABASE IF NOT EXISTS reservations;
USE reservations;

drop table if exists Admin;
CREATE TABLE Admin (
	email varchar(50) NOT NULL,
    fname varchar(100) NOT NULL,
    lname varchar(100) NOT NULL,
    password varchar(50) NOT NULL,
    primary key (email)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Owner;
CREATE TABLE Owner (
	email varchar(50) NOT NULL,
    fname varchar(100) NOT NULL,
    lname varchar(100) NOT NULL,
    password varchar(50) NOT NULL,
    phone_number varchar(15) NOT NULL UNIQUE,
    primary key (email)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Customer;
CREATE TABLE Customer (
	email varchar(50) NOT NULL,
    fname varchar(100) NOT NULL,
    lname varchar(100) NOT NULL,
    password varchar(50) NOT NULL,
    phone_number varchar(15) NOT NULL UNIQUE,
    credit_card_number varchar(16) NOT NULL UNIQUE,
    exp_date varchar(15) NOT NULL,
    cvv integer(3) NOT NULL,
    current_location varchar(50),
    primary key (email)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Property;
CREATE TABLE Property (
	owner_email varchar(50) NOT NULL,
    name varchar(50) NOT NULL,
    description varchar(299) NOT NULL,
    street varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    state varchar(2) NOT NULL,
    zip integer(5) NOT NULL,
    cost_per_night_per_person integer(5) NOT NULL,
    capacity integer(3) NOT NULL,
    primary key (name, owner_email),
    CONSTRAINT UC_Property UNIQUE (street, city, state, zip),
    CONSTRAINT owner_email FOREIGN KEY (owner_email) REFERENCES Owner (email)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Amenities;
CREATE TABLE Amenities (
	owner_email varchar(50) NOT NULL,
    property_name varchar(50) NOT NULL,
    amenity varchar(50) NOT NULL,
    primary key (owner_email, property_name, amenity),
    CONSTRAINT owner_email2 FOREIGN KEY (owner_email) REFERENCES Owner (email),
    CONSTRAINT property_name FOREIGN KEY (property_name) REFERENCES Property (name)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Airline;
CREATE TABLE Airline (
	name varchar(50) NOT NULL,
    rating float(10) NOT NULL,
    primary key (name)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Airport;
CREATE TABLE Airport (
	airport_ID varchar(3) NOT NULL,
    name varchar(50) NOT NULL,
    time_zone varchar(10) NOT NULL,
    street varchar(50) NOT NULL,
    city varchar(50) NOT NULL,
    state varchar(2) NOT NULL,
    zip varchar(5) NOT NULL,
    primary key (airport_ID),
    CONSTRAINT UC_Airport UNIQUE (name, street, city, state, zip)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Flight;
CREATE TABLE Flight (
	airline_name varchar(50) NOT NULL,
    flight_number varchar(5) NOT NULL,
    departure_time varchar(50) NOT NULL,
    arrival_time varchar(50) NOT NULL,
    date varchar(50) NOT NULL,
    cost_per_seat float(10) NOT NULL,
    capacity integer(3) NOT NULL,
    airport_from varchar(3) NOT NULL,
    airport_to varchar(3) NOT NULL,
    primary key (flight_number, airline_name),
    CONSTRAINT airline_name FOREIGN KEY (airline_name) REFERENCES Airline (name),
    CONSTRAINT airport_from FOREIGN KEY (airport_from) REFERENCES Airport (airport_ID),
    CONSTRAINT airport_to FOREIGN KEY (airport_to) REFERENCES Airport (airport_ID)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Attractions;
CREATE TABLE Attractions (
	airport_nearby varchar(3) NOT NULL,
    attraction varchar(50) NOT NULL,
    primary key (attraction, airport_nearby),
	CONSTRAINT airport_nearby FOREIGN KEY (airport_nearby) REFERENCES Airport (airport_ID)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Close_to;
CREATE TABLE Close_to (
	name varchar(50) NOT NULL,
    owner_email varchar(50) NOT NULL,
    airport varchar(3) NOT NULL,
    distance float(10) NOT NULL,
    primary key (name, owner_email, airport),
    CONSTRAINT property FOREIGN KEY (name, owner_email) REFERENCES Property (name, owner_email),
	CONSTRAINT airport FOREIGN KEY (airport) REFERENCES Airport (airport_ID)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Reserve;
CREATE TABLE Reserve (
	name varchar(50) NOT NULL,
    owner_email varchar(50) NOT NULL,
    customer varchar(50) NOT NULL,
    guest_amount int(2) NOT NULL,
    start_date varchar(50) NOT NULL,
    end_date varchar(50) NOT NULL,
    primary key (name, owner_email, customer),
    CONSTRAINT property1 FOREIGN KEY (name, owner_email) REFERENCES Property (name, owner_email),
	CONSTRAINT customer1 FOREIGN KEY (customer) REFERENCES Customer (email)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Review;
CREATE TABLE Review (
	name varchar(50) NOT NULL,
    owner_email varchar(50) NOT NULL,
    customer varchar(50) NOT NULL,
    content varchar(499),
    score float(5) NOT NULL,
    primary key (name, owner_email, customer),
    CONSTRAINT property2 FOREIGN KEY (name, owner_email) REFERENCES Property (name, owner_email),
	CONSTRAINT customer2 FOREIGN KEY (customer) REFERENCES Customer (email)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Book;
CREATE TABLE Book (
    customer varchar(50) NOT NULL,
    airline_name varchar(50) NOT NULL,
    flight_number varchar(5) NOT NULL,
    number_of_seats int(3) NOT NULL,
    primary key (customer, flight_number, airline_name),
	CONSTRAINT customer3 FOREIGN KEY (customer) REFERENCES Customer (email),
    CONSTRAINT flight_number FOREIGN KEY (flight_number, airline_name) REFERENCES Flight (flight_number, airline_name)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Customer_Rating;
CREATE TABLE Customer_Rating (
    customer varchar(50) NOT NULL,
    owner varchar(50) NOT NULL,
    score float(5),
    primary key (customer, owner),
	CONSTRAINT customer4 FOREIGN KEY (customer) REFERENCES Customer (email),
    CONSTRAINT owner FOREIGN KEY (owner) REFERENCES Owner (email)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;

drop table if exists Owner_Rating;
CREATE TABLE Owner_Rating (
    customer varchar(50) NOT NULL,
    owner varchar(50) NOT NULL,
    score float(5),
    primary key (customer, owner),
	CONSTRAINT customer5 FOREIGN KEY (customer) REFERENCES Customer (email),
    CONSTRAINT owner1 FOREIGN KEY (owner) REFERENCES Owner (email)
) ENGINE = InnoDB default CHARSET = utf8mb4 COLLATE= utf8mb4_0900_ai_ci;


-- INSERT QUERIES BELOW --

INSERT INTO Admin (email, fname, lname, password)
VALUES
  ("mmoss1@travelagency.com","Mark","Moss","password1"),
  ("asmith@travelagency.com","Aviva","Smith","password2");
 
INSERT INTO Owner (email, fname, lname, password, phone_number)
VALUES
  ("mscott22@gmail.com","Michael","Scott","password3","555-123-4567"),
  ("arthurread@gmail.com","Arthur","Read","password4","555-234-5678"),
  ("jwayne@gmail.com","John","Wayne","password5","555-345-6789"),
  ("gburdell3@gmail.com","George","Burdell","password6","555-456-7890"),
  ("mj23@gmail.com","Michael","Jordan","password7","555-567-8901"),
  ("lebron6@gmail.com","Lebron","James","password8","555-678-9012"),
  ("msmith5@gmail.com","Michael","Smith","password9","555-789-0123"),
  ("ellie2@gmail.com","Ellie","Johnson","password10","555-890-1234"),
  ("scooper3@gmail.com","Sheldon","Cooper","password11","678-123-4567"),
  ("mgeller5@gmail.com","Monica","Geller","password12","678-234-5678"),
  ("cbing10@gmail.com","Chandler","Bing","password13","678-345-6789"),
  ("hwmit@gmail.com","Howard","Wolowitz","password14","678-456-7890");
 
INSERT INTO Customer (email, fname, lname, password, phone_number, credit_card_number, cvv, exp_date)
VALUES
  ("scooper3@gmail.com","Sheldon","Cooper","password11","678-123-4567","6518555974461663",551,"Feb 2024"),
  ("mgeller5@gmail.com","Monica","Geller","password12","678-234-5678","2328567043101965",644,"March 2024"),
  ("cbing10@gmail.com","Chandler","Bing","password13","678-345-6789","8387952398279291",201,"Feb 2023"),
  ("hwmit@gmail.com","Howard","Wolowitz","password14","678-456-7890","6558859698525299",102,"April 2023"),
  ("swilson@gmail.com","Samantha","Wilson","password16","770-123-4567","9383321241981836",455,"Aug 2022"),
  ("aray@tiktok.com","Addison","Ray","password17","770-234-5678","3110266979495605",744,"Aug 2022"),
  ("cdemilio@tiktok.com","Charlie","Demilio","password18","770-345-6789","2272355540784744",606,"Feb 2025"),
  ("bshelton@gmail.com","Blake","Shelton","password19","770-456-7890","9276763978834273",862,"Sept 2023"),
  ("lbryan@gmail.com","Luke","Bryan","password20","770-567-8901","4652372688643798",258,"May 2023"),
  ("tswift@gmail.com","Taylor","Swift","password21","770-678-9012","5478842044367471",857,"Dec 2024"),
  ("jseinfeld@gmail.com","Jerry","Seinfeld","password22","770-789-0123","3616897712963372",295,"June 2022"),
  ("maddiesmith@gmail.com","Madison","Smith","password23","770-890-1234","9954569863556952",794,"July 2022"),
  ("johnthomas@gmail.com","John","Thomas","password24","404-770-5555","7580327437245356",269,"Oct 2025"),
  ("boblee15@gmail.com","Bob","Lee","password25","404-678-5555","7907351371614248",858,"Nov 2025");
 
INSERT INTO Property (name, owner_email, description, capacity, cost_per_night_per_person, street, city, state, zip)
VALUES
  ("Atlanta Great Property","scooper3@gmail.com","This is right in the middle of Atlanta near many attractions!",4,600,"2nd St","ATL","GA",30008),
  ("House near Georgia Tech","gburdell3@gmail.com","Super close to bobby dodde stadium!",3,275,"North Ave","ATL","GA",30008),
  ("New York City Property","cbing10@gmail.com","A view of the whole city. Great property!",2,750,"123 Main St","NYC","NY",10008),
  ("Statue of Libery Property","mgeller5@gmail.com","You can see the statue of liberty from the porch",5,1000,"1st St","NYC","NY",10009),
  ("Los Angeles Property","arthurread@gmail.com","",3,700,"10th St","LA","CA",90008),
  ("LA Kings House","arthurread@gmail.com","This house is super close to the LA kinds stadium!",4,750,"Kings St","La","CA",90011),
  ("Beautiful San Jose Mansion","arthurread@gmail.com","Huge house that can sleep 12 people. Totally worth it!",12,900,"Golden Bridge Pkwt","San Jose","CA",90001),
  ("LA Lakers Property","lebron6@gmail.com","This house is right near the LA lakers stadium. You might even meet Lebron James!",4,850,"Lebron Ave","LA","CA",90011),
  ("Chicago Blackhawks House","hwmit@gmail.com","This is a great property!",3,775,"Blackhawks St","Chicago","IL",60176),
  ("Chicago Romantic Getaway","mj23@gmail.com","This is a great property!",2,1050,"23rd Main St","Chicago","IL",60176),
  ("Beautiful Beach Property","msmith5@gmail.com","You can walk out of the house and be on the beach!",2,975,"456 Beach Ave","Miami","FL",33101),
  ("Family Beach House","ellie2@gmail.com","You can literally walk onto the beach and see it from the patio!",6,850,"1132 Beach Ave","Miami","FL",33101),
  ("Texas Roadhouse","mscott22@gmail.com","This property is right in the center of Dallas, Texas!",3,450,"17th Street","Dallas","TX",75043),
  ("Texas Longhorns House","mscott22@gmail.com","You can walk to the longhorns stadium from here!",10,600,"1125 Longhorns Way","Dallas","TX",75001);
 
INSERT INTO Amenities (property_name, owner_email, amenity)
VALUES
  ("Atlanta Great Property","scooper3@gmail.com","A/C & Heating"),
  ("Atlanta Great Property","scooper3@gmail.com","Pets allowed"),
  ("Atlanta Great Property","scooper3@gmail.com","Wifi & TV"),
  ("Atlanta Great Property","scooper3@gmail.com","Washer and Dryer"),
  ("House near Georgia Tech","gburdell3@gmail.com","Wifi & TV"),
  ("House near Georgia Tech","gburdell3@gmail.com","Washer and Dryer"),
  ("House near Georgia Tech","gburdell3@gmail.com","Full Kitchen"),
  ("New York City Property","cbing10@gmail.com","A/C & Heating"),
  ("New York City Property","cbing10@gmail.com","Wifi & TV"),
  ("Statue of Libery Property","mgeller5@gmail.com","A/C & Heating"),
  ("Statue of Libery Property","mgeller5@gmail.com","Wifi & TV"),
  ("Los Angeles Property","arthurread@gmail.com","A/C & Heating"),
  ("Los Angeles Property","arthurread@gmail.com","Pets allowed"),
  ("Los Angeles Property","arthurread@gmail.com","Wifi & TV"),
  ("LA Kings House","arthurread@gmail.com","A/C & Heating"),
  ("LA Kings House","arthurread@gmail.com","Wifi & TV"),
  ("LA Kings House","arthurread@gmail.com","Washer and Dryer"),
  ("LA Kings House","arthurread@gmail.com","Full Kitchen"),
  ("Beautiful San Jose Mansion","arthurread@gmail.com","A/C & Heating"),
  ("Beautiful San Jose Mansion","arthurread@gmail.com","Pets allowed"),
  ("Beautiful San Jose Mansion","arthurread@gmail.com","Wifi & TV"),
  ("Beautiful San Jose Mansion","arthurread@gmail.com","Washer and Dryer"),
  ("Beautiful San Jose Mansion","arthurread@gmail.com","Full Kitchen"),
  ("LA Lakers Property","lebron6@gmail.com","A/C & Heating"),
  ("LA Lakers Property","lebron6@gmail.com","Wifi & TV"),
  ("LA Lakers Property","lebron6@gmail.com","Washer and Dryer"),
  ("LA Lakers Property","lebron6@gmail.com","Full Kitchen"),
  ("Chicago Blackhawks House","hwmit@gmail.com","A/C & Heating"),
  ("Chicago Blackhawks House","hwmit@gmail.com","Wifi & TV"),
  ("Chicago Blackhawks House","hwmit@gmail.com","Washer and Dryer"),
  ("Chicago Blackhawks House","hwmit@gmail.com","Full Kitchen"),
  ("Chicago Romantic Getaway","mj23@gmail.com","A/C & Heating"),
  ("Chicago Romantic Getaway","mj23@gmail.com","Wifi & TV"),
  ("Beautiful Beach Property","msmith5@gmail.com","A/C & Heating"),
  ("Beautiful Beach Property","msmith5@gmail.com","Wifi & TV"),
  ("Beautiful Beach Property","msmith5@gmail.com","Washer and Dryer"),
  ("Family Beach House","ellie2@gmail.com","A/C & Heating"),
  ("Family Beach House","ellie2@gmail.com","Pets allowed"),
  ("Family Beach House","ellie2@gmail.com","Wifi & TV"),
  ("Family Beach House","ellie2@gmail.com","Washer and Dryer"),
  ("Family Beach House","ellie2@gmail.com","Full Kitchen"),
  ("Texas Roadhouse","mscott22@gmail.com","A/C & Heating"),
  ("Texas Roadhouse","mscott22@gmail.com","Pets allowed"),
  ("Texas Roadhouse","mscott22@gmail.com","Wifi & TV"),
  ("Texas Roadhouse","mscott22@gmail.com","Washer and Dryer"),
  ("Texas Longhorns House","mscott22@gmail.com","A/C & Heating"),
  ("Texas Longhorns House","mscott22@gmail.com","Pets allowed"),
  ("Texas Longhorns House","mscott22@gmail.com","Wifi & TV"),
  ("Texas Longhorns House","mscott22@gmail.com","Washer and Dryer"),
  ("Texas Longhorns House","mscott22@gmail.com","Full Kitchen");
 
INSERT INTO Airport (airport_ID, name, time_zone, street, city, state, zip)
VALUES
  ("ATL","Atlanta Hartsfield Jackson Airport","EST","6000 N Terminal Pkwy","Atlanta","GA",30320),
  ("JFK","John F Kennedy International Airport","EST","455 Airport Ave","Queens","NY",11430),
  ("LGA","Laguardia Airport","EST","790 Airport St","Queens","NY",11371),
  ("LAX","Lost Angeles International Airport","PST","1 World Way","Los Angeles","CA",90045),
  ("SJC","Norman Y. Mineta San Jose International Airport","PST","1702 Airport Blvd","San Jose","CA",95110),
  ("ORD","O'Hare International Airport","CST","10000 W O'Hare Ave","Chicago","IL",60666),
  ("MIA","Miami International Airport","EST","2100 NW 42nd Ave","Miami","FL",33126),
  ("DFW","Dallas International Airport","CST","2400 Aviation DR","Dallas","TX",75261);
 
INSERT INTO Airline (name, rating)
VALUES
  ("Delta Airlines",4.7),
  ("Southwest Airlines",4.4),
  ("American Airlines",4.6),
  ("United Airlines",4.2),
  ("JetBlue Airways",3.6),
  ("Spirit Airlines",3.3),
  ("WestJet",3.9),
  ("Interjet",3.7);
 
INSERT INTO Close_to (name, owner_email, airport, distance)
VALUES
  ("Atlanta Great Property","scooper3@gmail.com","ATL",12),
  ("House near Georgia Tech","gburdell3@gmail.com","ATL",7),
  ("New York City Property","cbing10@gmail.com","JFK",10),
  ("Statue of Libery Property","mgeller5@gmail.com","JFK",8),
  ("New York City Property","cbing10@gmail.com","LGA",25),
  ("Statue of Libery Property","mgeller5@gmail.com","LGA",19),
  ("Los Angeles Property","arthurread@gmail.com","LAX",9),
  ("LA Kings House","arthurread@gmail.com","LAX",12),
  ("Beautiful San Jose Mansion","arthurread@gmail.com","SJC",8),
  ("Beautiful San Jose Mansion","arthurread@gmail.com","LAX",30),
  ("LA Lakers Property","lebron6@gmail.com","LAX",6),
  ("Chicago Blackhawks House","hwmit@gmail.com","ORD",11),
  ("Chicago Romantic Getaway","mj23@gmail.com","ORD",13),
  ("Beautiful Beach Property","msmith5@gmail.com","MIA",21),
  ("Family Beach House","ellie2@gmail.com","MIA",19),
  ("Texas Roadhouse","mscott22@gmail.com","DFW",8),
  ("Texas Longhorns House","mscott22@gmail.com","DFW",17);
 
INSERT INTO Attractions (airport_nearby, attraction)
VALUES
  ("ATL","The Coke Factory"),
  ("ATL","The Georgia Aquarium"),
  ("JFK","The Statue of Liberty"),
  ("JFK","The Empire State Building"),
  ("LGA","The Statue of Liberty"),
  ("LGA","The Empire State Building"),
  ("LAX","Lost Angeles Lakers Stadium"),
  ("LAX","Los Angeles Kings Stadium"),
  ("SJC","Winchester Mystery House"),
  ("SJC","San Jose Earthquakes Soccer Team"),
  ("ORD","Chicago Blackhawks Stadium"),
  ("ORD","Chicago Bulls Stadium"),
  ("MIA","Crandon Park Beach"),
  ("MIA","Miami Heat Basketball Stadium"),
  ("DFW","Texas Longhorns Stadium"),
  ("DFW","The Original Texas Roadhouse");
 
INSERT INTO Flight (flight_number, airline_name, airport_from, airport_to, departure_time, arrival_time, date, cost_per_seat, capacity)
VALUES
  (1,"Delta Airlines","ATL","JFK","10:00 AM","12:00 PM","10/18/2021",400,150),
  (2,"Southwest Airlines","ORD","MIA","10:30 AM","2:30 PM","10/18/2021",350,125),
  (3,"American Airlines","MIA","DFW","1:00 PM","4:00 PM","10/18/2021",350,125),
  (4,"United Airlines","ATL","LGA","4:30 PM","6:30 PM","10/18/2021",400,100),
  (5,"JetBlue Airways","LGA","ATL","11:00 AM","1:00 PM","10/19/2021",400,130),
  (6,"Spirit Airlines","SJC","ATL","12:30 PM","9:30 PM","10/19/2021",650,140),
  (7,"WestJet","LGA","SJC","1:00 PM","4:00 PM","10/19/2021",700,100),
  (8,"Interjet","MIA","ORD","7:30 PM","9:30 PM","10/19/2021",350,125),
  (9,"Delta Airlines","JFK","ATL","8:00 AM","10:00 AM","10/20/2021",375,150),
  (10,"Delta Airlines","LAX","ATL","9:15 AM","6:15 PM","10/20/2021",700,110),
  (11,"Southwest Airlines","LAX","ORD","12:07 PM","7:07 PM","10/20/2021",600,95),
  (12,"United Airlines","MIA","ATL","3:35 PM","5:35 PM","10/20/2021",275,115);
 
INSERT INTO Reserve (name, owner_email, customer, start_date, end_date, guest_amount)
VALUES
  ("House near Georgia Tech","gburdell3@gmail.com","swilson@gmail.com","10/19/2021","10/25/2021",3),
  ("New York City Property","cbing10@gmail.com","aray@tiktok.com","10/18/2021","10/23/2021",2),
  ("New York City Property","cbing10@gmail.com","cdemilio@tiktok.com","10/24/2021","10/30/2021",2),
  ("Statue of Libery Property","mgeller5@gmail.com","bshelton@gmail.com","10/18/2021","10/22/2021",4),
  ("Los Angeles Property","arthurread@gmail.com","lbryan@gmail.com","10/19/2021","10/25/2021",2),
  ("Beautiful San Jose Mansion","arthurread@gmail.com","tswift@gmail.com","10/19/2021","10/22/2021",10),
  ("LA Lakers Property","lebron6@gmail.com","jseinfeld@gmail.com","10/19/2021","10/24/2021",4),
  ("Chicago Blackhawks House","hwmit@gmail.com","maddiesmith@gmail.com","10/19/2021","10/23/2021",2),
  ("Chicago Romantic Getaway","mj23@gmail.com","aray@tiktok.com","11/1/2021","11/7/2021",2),
  ("Beautiful Beach Property","msmith5@gmail.com","cbing10@gmail.com","10/18/2021","10/25/2021",2),
  ("Family Beach House","ellie2@gmail.com","hwmit@gmail.com","10/18/2021","10/28/2021",5);
 
INSERT INTO Book (customer, flight_number, airline_name, number_of_seats)
VALUES
  ("swilson@gmail.com",5,"JetBlue Airways",3),
  ("aray@tiktok.com",1,"Delta Airlines",2),
  ("bshelton@gmail.com",4,"United Airlines",4),
  ("lbryan@gmail.com",7,"WestJet",2),
  ("tswift@gmail.com",7,"WestJet",2),
  ("jseinfeld@gmail.com",7,"WestJet",4),
  ("maddiesmith@gmail.com",8,"Interjet",2),
  ("cbing10@gmail.com",2,"Southwest Airlines",2),
  ("hwmit@gmail.com",2,"Southwest Airlines",5);
 
INSERT INTO Review (name, owner_email, customer, content, score)
VALUES
  ("House near Georgia Tech","gburdell3@gmail.com","swilson@gmail.com","This was so much fun. I went and saw the coke factory, the falcons play, GT play, and the Georgia aquarium. Great time! Would highly recommend!",5),
  ("New York City Property","cbing10@gmail.com","aray@tiktok.com","This was the best 5 days ever! I saw so much of NYC!",5),
  ("Statue of Libery Property","mgeller5@gmail.com","bshelton@gmail.com","This was truly an excellent experience. I really could see the Statue of Liberty from the property!",4),
  ("Los Angeles Property","arthurread@gmail.com","lbryan@gmail.com","I had an excellent time!",4),
  ("Beautiful San Jose Mansion","arthurread@gmail.com","tswift@gmail.com","We had a great time, but the house wasn't fully cleaned when we arrived",3),
  ("LA Lakers Property","lebron6@gmail.com","jseinfeld@gmail.com","I was disappointed that I did not meet lebron james",2),
  ("Chicago Blackhawks House","hwmit@gmail.com","maddiesmith@gmail.com","This was awesome! I met one player on the chicago blackhawks!",5);
 
INSERT INTO Customer_Rating (owner, customer, score)
VALUES
  ("gburdell3@gmail.com","swilson@gmail.com",5),
  ("cbing10@gmail.com","aray@tiktok.com",5),
  ("mgeller5@gmail.com","bshelton@gmail.com",3),
  ("arthurread@gmail.com","lbryan@gmail.com",4),
  ("arthurread@gmail.com","tswift@gmail.com",4),
  ("lebron6@gmail.com","jseinfeld@gmail.com",1),
  ("hwmit@gmail.com","maddiesmith@gmail.com",2);
 
INSERT INTO Owner_Rating (owner, customer, score)
VALUES
  ("gburdell3@gmail.com","swilson@gmail.com",5),
  ("cbing10@gmail.com","aray@tiktok.com",5),
  ("mgeller5@gmail.com","bshelton@gmail.com",4),
  ("arthurread@gmail.com","lbryan@gmail.com",4),
  ("arthurread@gmail.com","tswift@gmail.com",3),
  ("lebron6@gmail.com","jseinfeld@gmail.com",2),
  ("hwmit@gmail.com","maddiesmith@gmail.com",5);
