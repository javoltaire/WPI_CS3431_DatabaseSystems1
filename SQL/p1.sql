/* Authors: Jules Voltaire - javoltaire and Ebenezer Ampiah - */

-- Creating the tables
-- Table that will store the title acronyms and their value
CREATE TABLE medical_title(
    acronym VARCHAR2(10) PRIMARY KEY,
    title_name VARCHAR2(50)
)

-- Table that will hold a floor name and the building that it is in.
-- Cannot have the two floors with the same name and building
CREATE TABLE floor(
    floor_id INT PRIMARY KEY,
    floor_name VARCHAR2(20),
    floor_building VARCHAR2(20),
    CONSTRAINT uniqueFloor UNIQUE (floor_name, floor_building)
)

CREATE TABLE health_care_provider(
    provider_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(15) NOT NULL,
    last_name VARCHAR2(20) NOT NULL,
    title VARCHAR2(10) DEFAULT 'MD',
    location INT,
    CONSTRAINT fk_title FOREIGN KEY (title) REFERENCES medical_title(acronym),
    CONSTRAINT fk_prov_location FOREIGN KEY (location) REFERENCES location(location_id)
)

CREATE TABLE Department(
    dept_name VARCHAR2(15) PRIMARY KEY,
    dept_type VARCHAR2(20),
    location INT,
    CONSTRAINT fk_dept_location FOREIGN KEY (location) REFERENCES location(location_id),
    CONSTRAINT check_dept_type CHECK (dept_type IN ('service', 'practice'))  
)





CREATE TABLE location(
    location_id INT PRIMARY KEY,
    x_coord NUMBER(4,0),
    y_coord NUMBER(4,0),
    location_name VARCHAR2(10),
    location_type VARCHAR2(15),             -- Check one of three
    
    
    CONSTRAINT uniqueCoord UNIQUE(xCoord, yCoord)
)