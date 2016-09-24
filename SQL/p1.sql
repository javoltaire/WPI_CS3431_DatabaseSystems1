/* Authors: Jules Voltaire - javoltaire and Ebenezer Ampiah - */

-- Creating the tables
CREATE TABLE MedicalTitles (
    acronym VARCHAR2(10) PRIMARY KEY,
    titleName VARCHAR2(50)
)

CREATE TABLE Floors (
    floorName VARCHAR2(20),
    building VARCHAR2(20),
    CONSTRAINT uniqueFloor UNIQUE (floorName, building)
)

CREATE TABLE Locations(
    locattionID NUMBER(4,0) PRIMARY KEY,
    xCoord NUMBER(4,0),
    yCoord NUMBER(4,0),
    locationName VARCHAR2(10),
    
    CONSTRAINT uniqueCoord UNIQUE(xCoord, yCoord)
)









CREATE TABLE HealthCareProviders (
    providerID NUMBER,
    firstName VARCHAR2,
    lastName VARCHAR2,
    providerTitle VARCHAR2,
    location VARCHAR2
)