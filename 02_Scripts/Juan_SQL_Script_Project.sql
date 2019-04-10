DROP DATABASE IF EXISTS assetmgmt;
CREATE DATABASE assetmgmt;

USE assetmgmt;

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

select * from departement_employee_list where departement_employee_list.Department like '%HR%';

update department set name='HR' where id=1;

select * from most_used_software where most_used_software.Department = 'HR';


sp_GetAllDepartments
// 1. Insert Into ... direkt testen
// 2. Insert Into als sp ohne parameter
// 3. sp um parameter erweitern ... fertifg!
// sp_createdepartment

// sp_selectdepartment(id ...)

// sp_deletedepartment(id ...)


DROP procedure IF EXISTS `new_employee`;
DELIMITER //
CREATE procedure new_employee(firstname_imp VARCHAR(45))
BEGIN
INSERT INTO employee (firstname) VALUES (firstname_imp);
END//
DELIMITER ;

call new_employee('User');