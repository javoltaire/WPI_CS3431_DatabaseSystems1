/* Authors: Jules Voltaire - javoltaire and Ebenezer Ampiah - ekampiah */
-- Dropping fk contraints to be able to drop tables
alter table health_care_provider drop constraint fk_prov_location;
alter table health_care_provider drop constraint fk_title;
alter table hospital_department drop constraint fk_departtment_location;
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
drop table hospital_department;
drop table location;
drop table location_neighbor;
drop table route;
drop table route_edge;
drop table health_care_provider;

set linesize 200;

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
    location_name VARCHAR2(40),
    location_type VARCHAR2(15),
    floor INT NOT NULL,
    CONSTRAINT location_unique_coord UNIQUE(x_coord, y_coord, floor, location_name),
    CONSTRAINT check_hospital_location_type CHECK (location_type IN ('hallway', 'office', 'service area')),
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
    first_name VARCHAR2(25) NOT NULL,
    last_name VARCHAR2(30) NOT NULL,
    title VARCHAR2(10) DEFAULT 'MD',
    location INT,
    CONSTRAINT fk_title FOREIGN KEY (title) REFERENCES medical_title(acronym),
    CONSTRAINT fk_prov_location FOREIGN KEY (location) REFERENCES location(id)
);

CREATE TABLE hospital_department(
    dept_name VARCHAR2(15) PRIMARY KEY,
    dept_type VARCHAR2(20),
    location INT,
    CONSTRAINT fk_departtment_location FOREIGN KEY (location) REFERENCES location(id),
    CONSTRAINT check_department_type CHECK (dept_type IN ('service', 'practice'))  
);

insert into medical_title values('MD','Doctor of Medicine');
insert into medical_title values('NP','Nurse practitioner');
insert into medical_title values('WHNP','Womens Health Nurse Practitioner');
insert into medical_title values('PA-C','Physician Assistant Certified');
insert into medical_title values('MS','Master of Science');
insert into medical_title values('RDN',' Registered Dietitian Nutritionist');
insert into medical_title values('LDN',' Licensed Dietitian Nutritionist');
insert into medical_title values('RN','Registered Nurse');
insert into medical_title values('CCC-A','Certificate of Clinical Competence in Audiology');
insert into medical_title values('Au.D','Doctor of Audiology');
insert into medical_title values('LCSW','Licensed (Independent) Clinical Social Worker');
insert into medical_title values('RD','Registered Dietitian');
insert into medical_title values('DO','Doctor of Osteopathy');
insert into medical_title values('MEd','Doctor of Medicine');
insert into medical_title values('LADC I','Licensed Alcohol and Drug Counselor I');
insert into medical_title values('PhD','Doctor of Philosophy');

insert into floor values (1, '1st Floor', 'Faulkner Hospital');
insert into floor values (2, '3rd Floor', 'Faulkner Hospital');

insert into location values (67,-2,-3,'Chapel','office',2);
insert into location values (70,-2,-2,'Hillside Elevators','service area',2);
insert into location values (69,-1,-3,'Kiosk Location','service area',2);
insert into location values (61,-1,-1,'Gift Shop','service area',2);
insert into location values (60,-1,0,'Huros Auditorium','service area',2);
insert into location values (48,-1,1,'H303','hallway',2);
insert into location values (62,-1,2,'Atrium Elevators','service area',2);
insert into location values (25,-1,3,'Colorectal Surgery','service area',2);
insert into location values (63,-1,3,'3A','office',2);
insert into location values (72,0,-4,'Shuttle Pickup','service area',2);
insert into location values (50,0,-2,'H305','hallway',2);
insert into location values (46,0,-1,'H301','hallway',2);
insert into location values (28,0,0,'Emergency Department','service area',1);
insert into location values (45,0,0,'H300','hallway',2);
insert into location values (47,0,1,'H302','hallway',2);
insert into location values (49,0,2,'H304','hallway',2);
insert into location values (68,0,-3,'Hillside Lobby','service area',2);
insert into location values (71,1,-3,'Volunteer Services','office',2);
insert into location values (1,1,1,'Atrium Café','service area',2);
insert into location values (29,1,1,'H100','hallway',1);
insert into location values (66,1,1,'Cafeteria','service area',1);
insert into location values (26,1,2,'Dialysis Clinic','service area',1);
insert into location values (31,1,2,'H102','hallway',1);
insert into location values (64,1,2,'3B','office',2);
insert into location values (32,1,4,'H103','hallway',1);
insert into location values (30,2,1,'H101','hallway',1);
insert into location values (21,2,2,'Dialysis Clinic','service area',2);
insert into location values (27,2,2,'Doherty Conference Room','service area',1);
insert into location values (51,2,2,'Family Center','office',1);
insert into location values (65,2,2,'3C','office',2);
insert into location values (53,3,-2,'Endoscopy','office',1);
insert into location values (41,3,-1,'H112','hallway',1);
insert into location values (33,3,1,'H104','hallway',1);
insert into location values (52,3,3,'Patient Registration','office',1);
insert into location values (34,4,1,'H105','hallway',1);
insert into location values (57,4,5,'StarBucks','service area',1);
insert into location values (43,5,-3,'H114','hallway',1);
insert into location values (58,5,4,'Kiosk Location','service area',1);
insert into location values (44,6,-3,'H115','hallway',1);
insert into location values (39,6,-2,'H110','hallway',1);
insert into location values (40,6,-1,'H111','hallway',1);
insert into location values (35,6,1,'H106','hallway',1);
insert into location values (42,6,4,'H113','hallway',1);
insert into location values (56,6,5,'Atrium Lobby','service area',1);
insert into location values (59,6,6,'Atrium Main Entrance','service area',1);
insert into location values (54,7,0,'Preoperation Evaluation','office',1);
insert into location values (38,8,-2,'H109','hallway',1);
insert into location values (36,8,1,'H107','hallway',1);
insert into location values (55,9,-2,'Day Surgery','office',1);
insert into location values (37,9,1,'H108','hallway',1);
insert into location values (73,4,0,'Blood Draw Testing','office',1);
insert into location values (74,6,0,'H116','hallway',1);
insert into location values (75,8,2,'H117','hallway',1);
insert into location values (76,9,0,'Radiology','office',1);

insert into location_neighbor values ( 1,48,49);
insert into location_neighbor values ( 2,50,68);
insert into location_neighbor values ( 3,50,69);
insert into location_neighbor values ( 4,50,70);
insert into location_neighbor values ( 5,50,72);
insert into location_neighbor values ( 6,46,50);
insert into location_neighbor values ( 7,46,61);
insert into location_neighbor values ( 8,45,60);
insert into location_neighbor values ( 9,45,47);
insert into location_neighbor values ( 10,45,46);
insert into location_neighbor values ( 11,47,1);
insert into location_neighbor values ( 12,47,48);
insert into location_neighbor values ( 13,49,65);
insert into location_neighbor values ( 14,49,64);
insert into location_neighbor values ( 15,49,63);
insert into location_neighbor values ( 16,49,62);
insert into location_neighbor values ( 17,29,28);
insert into location_neighbor values ( 18,29,64);
insert into location_neighbor values ( 19,29,30);
insert into location_neighbor values ( 20,31,64);
insert into location_neighbor values ( 21,31,51);
insert into location_neighbor values ( 22,31,32);
insert into location_neighbor values ( 23,32,64);
insert into location_neighbor values ( 24,30,66);
insert into location_neighbor values ( 25,30,33);
insert into location_neighbor values ( 26,41,53);
insert into location_neighbor values ( 27,33,52);
insert into location_neighbor values ( 28,34,33);
insert into location_neighbor values ( 29,34,73);
insert into location_neighbor values ( 30,43,44);
insert into location_neighbor values ( 31,58,42);
insert into location_neighbor values ( 32,44,39);
insert into location_neighbor values ( 33,39,40);
insert into location_neighbor values ( 34,40,41);
insert into location_neighbor values ( 35,35,74);
insert into location_neighbor values ( 36,35,36);
insert into location_neighbor values ( 37,35,34);
insert into location_neighbor values ( 38,42,58);
insert into location_neighbor values ( 39,42,35);
insert into location_neighbor values ( 40,42,56);
insert into location_neighbor values ( 41,38,55);
insert into location_neighbor values ( 42,36,75);
insert into location_neighbor values ( 43,37,76);
insert into location_neighbor values ( 44,37,36);

insert into health_care_provider values (1,'Christopher','Chiodo','MD',63);
insert into health_care_provider values (2,'Yoon Sun','Chun','MD',63);
insert into health_care_provider values (3,'Roger','Clark','DO',63);
insert into health_care_provider values (4,'Thomas','Cochrane','MD',63);
insert into health_care_provider values (5,'Jeffrey','Cohen','MD',63);
insert into health_care_provider values (6,'Natalie','Cohen','MD',63);
insert into health_care_provider values (7,'Alene','Conant','MD',63);
insert into health_care_provider values (8,'Nathan','Connell','MD',63);
insert into health_care_provider values (9,'Maria','Copello','MD',63);
insert into health_care_provider values (10,'Carleton Eduardo','Corrales','MD',63);
insert into health_care_provider values (11,'Garth Rees','Cosgrove','MD',63);
insert into health_care_provider values (12,'Lindsay','Cotter','LCSW',64);
insert into health_care_provider values (13,'Christopher','Cua','MD',64);
insert into health_care_provider values (14,'Carolyn','DAmbrosio','MD',64);
insert into health_care_provider values (15,'Harriet','Dann','MD',64);
insert into health_care_provider values (16,'Jatin','Dave','MD',64);
insert into health_care_provider values (17,'Paul','Davidson','PhD',65);
insert into health_care_provider values (18,'Courtney','Dawson','MD',65);
insert into health_care_provider values (19,'Sherrie','Divito','PhD',65);
insert into health_care_provider values (20,'Meghan','Doherty','LCSW',65);
insert into health_care_provider values (21,'Laura','Dominici','MD',65);

insert into route values (1, 34, 52);
insert into route_edge values (1, 1, 0);
insert into route_edge values (1, 27, 1);

select * from hospital_department;
select * from medical_title;
select * from floor;
select * from location;
select * from location_neighbor;
select * from route;
select * from route_edge;
select * from health_care_provider;
