DROP DATABASE IF EXISTS Assetmgmt;
CREATE DATABASE Assetmgmt;
USE Assetmgmt;

CREATE TABLE product (
    id INT NOT NULL AUTO_INCREMENT,
    model_name VARCHAR(45) NOT NULL,
    manufacturer INT NOT NULL,
    type INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE manufacturer (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE types (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE asset (
    id INT NOT NULL AUTO_INCREMENT,
    serialnumber INT NOT NULL,
    purchaseDate DATE NOT NULL,
    product_id INT NOT NULL,
    workplace_id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE software (
    id INT NOT NULL AUTO_INCREMENT,
    serial_number varchar(11) not null,
    Version VARCHAR(5) NOT NULL,
    product_id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE softwarecatalogue (
    serial_number INT NOT NULL,
    software_id INT NOT NULL
);

CREATE TABLE workplace (
    id INT NOT NULL AUTO_INCREMENT,
	department_id INT NOT NULL,
    PRIMARY KEY (id)
    
);

CREATE TABLE department (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(25) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE employee (
    id INT NOT NULL AUTO_INCREMENT,
    firstname VARCHAR(45) NOT NULL,
    lastname VARCHAR(45) NOT NULL,
    birthdate DATE NOT NULL,
    sex INT NOT NULL,
    address_id INT NOT NULL,
	workplace_id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE sex (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE address (
    id INT NOT NULL AUTO_INCREMENT,
    street VARCHAR(100) NOT NULL,
    street_nr INT(5) NOT NULL,
    zip_code INT(5) NOT NULL,
    city VARCHAR(45) NOT NULL,
    PRIMARY KEY (id)
);

ALTER TABLE product ADD FOREIGN KEY (manufacturer) REFERENCES manufacturer(id);
ALTER TABLE product ADD FOREIGN KEY (type) REFERENCES types(id);
ALTER TABLE asset ADD FOREIGN KEY (product_id) REFERENCES product(id);
ALTER TABLE asset ADD FOREIGN KEY (workplace_id) REFERENCES workplace(id);
ALTER TABLE software ADD FOREIGN KEY (product_id) REFERENCES product(id);
ALTER TABLE softwarecatalogue ADD constraint primary key (serial_number,software_id);
ALTER TABLE softwarecatalogue ADD FOREIGN KEY (serial_number) REFERENCES asset(id);
ALTER TABLE softwarecatalogue ADD FOREIGN KEY (software_id) REFERENCES software(id);
ALTER TABLE employee ADD FOREIGN KEY (workplace_id) REFERENCES workplace(id);
ALTER TABLE employee ADD FOREIGN KEY (sex) REFERENCES sex(id);
ALTER TABLE employee ADD FOREIGN KEY (address_id) REFERENCES address(id);
ALTER TABLE workplace ADD FOREIGN KEY (department_id) REFERENCES department(id);

/*Insert Data*/
LOAD DATA INFILE 'C:/CSV/types.csv'
INTO TABLE types
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:/CSV/manufacturers.csv'
INTO TABLE manufacturer
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:/CSV/products.csv'
INTO TABLE product
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:/CSV/software.csv'
INTO TABLE software
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:/CSV/addresses.csv'
INTO TABLE address
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:/CSV/departments.csv'
INTO TABLE department
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:/CSV/workplaces.csv'
INTO TABLE workplace
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:/CSV/sexes.csv'
INTO TABLE sex
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:/CSV/employees.csv'
INTO TABLE employee
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:/CSV/assets.csv'
INTO TABLE asset
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

LOAD DATA INFILE 'C:/CSV/softwarecatalogue.csv'
INTO TABLE softwarecatalogue
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

/*View 1*/
create view Hardware_List as
select manufacturer.name as 'Hersteller', product.model_name as 'Modellname', asset.serialnumber as 'Serialnumber' from product
join manufacturer on manufacturer.id
join asset on asset.id
where product.id = asset.product_id and product.manufacturer = manufacturer.id;

/*View 2*/
create view Employee_Hardware_List as
select employee.firstname as 'Firstname', employee.lastname as 'Lastname', asset.serialnumber as 'Seriennummer', product.model_name as 'Modell' from asset
join product on product.id
join workplace on workplace.id
join employee on employee.id
where asset.product_id = product.id and asset.workplace_id = workplace.id and employee.workplace_id = workplace.id;

/*View 3*/
create view Departement_Employee_List as
select department.name as 'Department', employee.firstname as 'Firstname', employee.lastname as 'Lastname', workplace.id as 'Büro', asset.serialnumber as 'Asset', product.model_name as 'Modell' from employee
join workplace on workplace.id
join department on department.id
join asset on asset.id
join product on product.id
where employee.workplace_id = workplace.id and workplace.department_id = department.id and asset.workplace_id = workplace.id and asset.product_id = product.id;

/*View 4*/
create view Most_Used_Software as
select department.name as 'Department', product.model_name as 'Software Name', count(product.id) as 'Anzahl' from department
join workplace on workplace.id
join asset on asset.id
join softwarecatalogue on softwarecatalogue.serial_number
join software on software.id
join product on product.id
where department.id = workplace.department_id 
and asset.workplace_id = workplace.id 
and asset.id = softwarecatalogue.serial_number 
and softwarecatalogue.software_id = software.id
and software.product_id = product.id
group by department.name;

select * from hardware_list;

select * from employee_hardware_list
where employee_hardware_list.Lastname = "Muster";

select * from departement_employee_list where departement_employee_list.Department = 'HR';

select * from most_used_software where most_used_software.Department = 'HR';

/*create user*/
DROP USER IF EXISTS hr@’localhost’;
create user hr@’localhost’ identified by '123';
grant all privileges on employee to hr@’localhost’;
grant all privileges on address to hr@’localhost’;
grant all privileges on sex to hr@’localhost’;
grant all privileges on department to hr@’localhost’;
grant all privileges on workplace to hr@’localhost’;

DROP USER IF EXISTS sw@’localhost’;
create user sw@’localhost’ identified by '123';
grant all privileges on software to sw@’localhost’;
grant all privileges on softwarecatalogue to sw@’localhost’;
grant all privileges on product to sw@’localhost’;
grant all privileges on asset to sw@’localhost’;
grant all privileges on assetmgmt.types to sw@’localhost’;
grant SELECT on workplace to sw@’localhost’;
grant SELECT on department to sw@’localhost’;
grant SELECT on employee to sw@’localhost’;

DROP USER IF EXISTS hm@’localhost’;
create user hm@’localhost’ identified by '123';
grant all privileges on product to hm@’localhost’;
grant all privileges on asset to hm@’localhost’;
grant all privileges on manufacturer to hm@’localhost’;
grant all privileges on assetmgmt.types to hm@’localhost’;
grant SELECT on workplace to hm@’localhost’;
grant SELECT on department to hm@’localhost’;
grant SELECT on employee to hm@’localhost’;

DROP USER IF EXISTS guest@’localhost’;
create user guest@’localhost’ identified by '123';
grant SELECT on employee to guest@’localhost’;
grant SELECT on workplace to guest@’localhost’;

/*Transaktion weisst neuen Arbeitsplatz zu welcher noch nicht besetzt ist. Es könnte sein das zwei hr user den neuen Mitarbeiter anlegen wollen.*/
start transaction;
select * from employee;

select @emptyWorkplace := w.id from workplace as w
join employee as e on w.id <> e.workplace_id
group by e.id limit 1;

insert into employee (firstname, lastname,birthdate,sex,address_id,workplace_id)
values ('Kevin','Meier','1980.03.01',1,1,@emptyWorkplace);
commit;

DROP procedure IF EXISTS `newEmployee`; 
DELIMITER // 
CREATE PROCEDURE newEmployee(
Firstname varchar (45),
Lastname varchar (45),
Sex int,
Birthday date,
Street varchar(100),
HouseNr int,
PLZ int,
City varchar(45)) 
BEGIN 
	insert into address (street,street_nr,zip_code,city)
    values (Street,HouseNr,PLZ,City);
    select a.id from address as a
    where a.street = Street AND a.zip_code = PLZ;
    END// 
    DELIMITER ;

/*Stored Procedure 1 Neuer Mitarbeiter*/
DROP procedure IF EXISTS `newEmployee`; 
DELIMITER // 
CREATE PROCEDURE newEmployee(
Firstname varchar (45),
Lastname varchar (45),
Sex varchar(15),
Birthday date,
Street varchar(100),
HouseNr int,
PLZ int,
City varchar(45)) 
BEGIN 
   
	insert into address (street,street_nr,zip_code,city)
    values (Street,HouseNr,PLZ,City);
    
    select @adressID := a.id from address as a
    where a.street = Street AND a.zip_code = PLZ
    Limit 1;
    
    select @sexID := s.id from sex as s
    where s.name = Sex;
    
    select @workplace_id := w.id from workplace as w
	join employee as e on w.id <> e.workplace_id	
	group by e.id limit 1;
    
    insert into employee (firstname,lastname,birthdate,sex,address_id,workplace_id)
    values (Firstname,Lastname,Birthday,@sexID,@adressID,@workplace_id);
    END// 
    DELIMITER ;

call newEmployee("Oliver","Czabala","Male","2019.04.05","OliStrasse",50,1456,"testcity");
select * from employee;

/*Stored Procedure 2 neues Asset*/
DROP procedure IF EXISTS `newAsset`; 
DELIMITER // 
CREATE PROCEDURE newAsset(
Firstname varchar (45),
Lastname varchar (45),
Serialnumber int(11),
BuyDate date,
ModellName varchar(45)) 
BEGIN 
    
    select @productID := p.id from product as p
    where p.model_name = ModellName;
    
    select @workplaceID := e.workplace_id from employee as e
    where e.firstname = Firstname AND e.lastname = Lastname;
    
    insert into asset (serialnumber,purchaseDate,product_id,workplace_id)
    values (Serialnumber,BuyDate,@productID,@workplaceID);
    END// 
    DELIMITER ;

call newAsset("Oliver","Czabala",555666777,"2019.06.13","Word");
select * from asset;

/*Stored Procedure 3 neuem Mitarbeiter Hr rechte geben*/
DROP procedure IF EXISTS `newHRRight`; 
DELIMITER // 
CREATE PROCEDURE newHRRight(
username varchar(45)) 
BEGIN 
	set @test = username;
	DROP USER IF EXISTS test@’localhost’;
	create user test@’localhost’ identified by '123';
	grant all privileges on employee to test@’localhost’;
	grant all privileges on address to test@’localhost’;
	grant all privileges on sex to test@’localhost’;
	grant all privileges on department to test@’localhost’;
	grant all privileges on workplace to test@’localhost’;
	
    select "HR right granted.";
    END// 
    DELIMITER ;
call newHRRight('oliver');
SELECT user FROM mysql.user;