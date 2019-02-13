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
    name_ VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE types (
    id INT NOT NULL,
    parent_id INT NOT NULL,
    name_ VARCHAR(30) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (parent_id) REFERENCES types(id)
);

CREATE TABLE asset (
    id INT NOT NULL AUTO_INCREMENT,
    serialnumber INT NOT NULL,
    purchaseDate DATE NOT NULL,
    productid INT NOT NULL,
    workplace_id INT NOT NULL,
    employee_id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE software (
    id INT NOT NULL AUTO_INCREMENT,
    name_ VARCHAR(45) NOT NULL,
    Version VARCHAR(5) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE softwarecatalog (
    id INT NOT NULL AUTO_INCREMENT,
    serial_number INT NOT NULL,
    software_id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE workplace (
    id INT NOT NULL AUTO_INCREMENT,
    employee_id INT NOT NULL,
    department_id INT NOT NULL,
    PRIMARY KEY (id)
    
);

CREATE TABLE department (
    id INT NOT NULL,
    name_ VARCHAR(25) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE employee (
    id INT NOT NULL,
    firstname VARCHAR(45) NOT NULL,
    lastname VARCHAR(45) NOT NULL,
    birthdate DATE NOT NULL,
    sex INT NOT NULL,
    address_id INT NOT NULL,
    department_id INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE sex (
    id INT NOT NULL AUTO_INCREMENT,
    parent_id INT NOT NULL,
    name VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE address (
    id INT NOT NULL,
    street VARCHAR(100),
    street_nr INT(5),
    zip_code INT(5),
    city VARCHAR(45),
    PRIMARY KEY (id)
);

ALTER TABLE product ADD FOREIGN KEY (manufacturer) REFERENCES manufacturer(id);
ALTER TABLE product ADD FOREIGN KEY (type) REFERENCES types(id);
ALTER TABLE asset ADD FOREIGN KEY (workplace_id) REFERENCES workplace(id);
ALTER TABLE workplace ADD FOREIGN KEY (employee_id) REFERENCES employee(id);
ALTER TABLE workplace ADD FOREIGN KEY (department_id) REFERENCES department(id);
ALTER TABLE employee ADD FOREIGN KEY (sex) REFERENCES sex(id);
ALTER TABLE employee ADD FOREIGN KEY (address_id) REFERENCES address(id);
ALTER TABLE employee ADD FOREIGN KEY (department_id) REFERENCES department(id);