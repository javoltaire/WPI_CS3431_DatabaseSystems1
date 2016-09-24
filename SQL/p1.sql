/* Authors: Jules Voltaire - javoltaire and Ebenezer Ampiah - */

-- Creating the tables
CREATE TABLE medical_title(
    acronym VARCHAR2(10) PRIMARY KEY,
    title_name VARCHAR2(50)
)

CREATE TABLE floor(
    floor_id INT PRIMARY KEY,
    floor_name VARCHAR2(20),
    floor_building VARCHAR2(20),
    CONSTRAINT uniqueFloor UNIQUE (floor_name, floor_building)
)

CREATE TABLE location(
    locattion_id INT PRIMARY KEY,
    x_coord NUMBER(4,0),
    y_coord NUMBER(4,0),
    location_name VARCHAR2(10),
    
    CONSTRAINT uniqueCoord UNIQUE(xCoord, yCoord)
)









CREATE TABLE HealthCareProviders (
    providerID NUMBER,
    firstName VARCHAR2,
    lastName VARCHAR2,
    providerTitle VARCHAR2,
    location VARCHAR2
)