/* Authors: Jules Voltaire - javoltaire and Ebenezer Ampiah - */
-- Dropping fk contraints to be able to drop tables
alter table health_care_provider drop constraint fk_prov_location;
alter table health_care_provider drop constraint fk_title;
alter table department drop constraint fk_dept_location;
alter table route_edge drop constraint fk_route;
alter table route_edge drop constraint fk_edge;
alter table route drop constraint fk_start;
alter table route drop constraint fk_end;
alter table location_neighbor drop constraint fk_location;
alter table location_neighbor drop constraint fk_neighbor;
alter table location drop constraint fk_floor;
-- Dropping tables in case they were created
drop table medical_title;
drop table floor;
drop table location;
drop table location_neighbor;
drop table route;
drop table route_edge;
drop table health_care_provider;
drop table department;


-- Creating the tables
-- Table that will store the title acronyms and their value
CREATE TABLE medical_title(
    acronym VARCHAR2(10) PRIMARY KEY,
    title_name VARCHAR2(50) NOT NULL
);

-- Table that will hold a floor name and the building that it is in.
-- Cannot have the two floors with the same name and building
CREATE TABLE floor(
    floor_id INT PRIMARY KEY,
    floor_name VARCHAR2(20) NOT NULL,
    floor_building VARCHAR2(20) NOT NULL,
    CONSTRAINT unique_floor UNIQUE (floor_name, floor_building)
);

-- Table that will hold individual locations on the map based on coordinates
CREATE TABLE location(
    id INT PRIMARY KEY,
    x_coord INT NOT NULL,
    y_coord INT NOT NULL,
    location_name VARCHAR2(10),
    location_type VARCHAR2(15),
    floor INT NOT NULL,
    CONSTRAINT unique_coord UNIQUE(x_coord, y_coord, floor),
    CONSTRAINT check_location_type CHECK (location_type IN ('hallway', 'office', 'service_area')),
    CONSTRAINT fk_floor FOREIGN KEY (floor) REFERENCES floor(floor_id)
);

-- This a way to connect a location to a every neighboring location, therefore creating edges,
-- So this table essentially stores edges
CREATE TABLE location_neighbor(
    id INT PRIMARY KEY,
    location INT NOT NULL,
    neighbor INT NOT NULL,
    CONSTRAINT unique_location_neighbor UNIQUE(location, neighbor),
    CONSTRAINT fk_location FOREIGN KEY (location) REFERENCES location(id),
    CONSTRAINT fk_neighbor FOREIGN KEY (neighbor) REFERENCES location(id)
);

CREATE TABLE route(
    route_id INT PRIMARY KEY,
    start_location INT NOT NULL,
    end_location INT NOT NULL,
    CONSTRAINT fk_start FOREIGN KEY (start_location) REFERENCES location(id),
    CONSTRAINT fk_end FOREIGN KEY (end_location) REFERENCES location(id)
);

CREATE TABLE route_edge(
    route INT NOT NULL,
    edge INT NOT NULL,
    position INT NOT NULL,
    CONSTRAINT unique_path UNIQUE(route, edge, position),
    CONSTRAINT fk_route FOREIGN KEY (route) REFERENCES route(route_id),
    CONSTRAINT fk_edge FOREIGN KEY (edge) REFERENCES location_neighbor(id)
);

CREATE TABLE health_care_provider(
    provider_id INT PRIMARY KEY,
    first_name VARCHAR2(15) NOT NULL,
    last_name VARCHAR2(20) NOT NULL,
    title VARCHAR2(10) DEFAULT 'MD',
    location INT,
    CONSTRAINT fk_title FOREIGN KEY (title) REFERENCES medical_title(acronym),
    CONSTRAINT fk_prov_location FOREIGN KEY (location) REFERENCES location(id)
);

CREATE TABLE department(
    dept_name VARCHAR2(15) PRIMARY KEY,
    dept_type VARCHAR2(20),
    location INT,
    CONSTRAINT fk_dept_location FOREIGN KEY (location) REFERENCES location(id),
    CONSTRAINT check_dept_type CHECK (dept_type IN ('service', 'practice'))  
);

