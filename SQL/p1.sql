/* Authors: Jules Voltaire - javoltaire and Ebenezer Ampiah - ekampiah */

-- Dropping tables in case they were created
drop table title CASCADE CONSTRAINTS ;
drop table floor CASCADE CONSTRAINTS ;
drop table service CASCADE CONSTRAINTS ;
drop table location CASCADE CONSTRAINTS ;
drop table neighbor CASCADE CONSTRAINTS ;
drop table path CASCADE CONSTRAINTS ;
drop table path_node CASCADE CONSTRAINTS ;
drop table provider CASCADE CONSTRAINTS ;

drop view filter_offices;

set linesize 200;

-- Creating the tables
-- Table that will store the title acronyms and their value
CREATE TABLE title (
    acronym VARCHAR2(10) PRIMARY KEY,
    title_name VARCHAR2(50) NOT NULL
);

-- Table that will hold a floor name and the building that it is in.
-- Cannot have the two floors with the same name and building
CREATE TABLE floor(
    id char (2) PRIMARY KEY,
    floor_level number(2,0) NOT NULL,
    building VARCHAR2(20) NOT NULL,
    CONSTRAINT unique_floor UNIQUE (floor_level, building)
);

-- Table that will hold individual locations on the map based on coordinates
CREATE TABLE location(
    id INT PRIMARY KEY,
    x_coord INT NOT NULL,
    y_coord INT NOT NULL,
    location_name VARCHAR2(40),
    location_type VARCHAR2(15),
    floor char(2) NOT NULL,
    CONSTRAINT unique_coord UNIQUE(x_coord, y_coord, floor, location_name),
    CONSTRAINT check_location_type CHECK (location_type IN ('hallway', 'office', 'service area')),
    CONSTRAINT fk_location_floor FOREIGN KEY (floor) REFERENCES floor(id)
);

-- This a way to connect a location to a every neighboring location, therefore creating edges,
-- So this table essentially stores edges
CREATE TABLE neighbor(
    point_a INT NOT NULL,
    point_b INT NOT NULL,
    CONSTRAINT u_location_neighbor UNIQUE(point_a, point_b),
    CONSTRAINT fk_point_a_location FOREIGN KEY (point_a) REFERENCES location(id),
    CONSTRAINT fk_point_b_location FOREIGN KEY (point_b) REFERENCES location(id)
);

CREATE TABLE path (
    id INT PRIMARY KEY,
    start_location INT NOT NULL,
    end_location INT NOT NULL,
    CONSTRAINT fk_start_location FOREIGN KEY (start_location) REFERENCES location(id),
    CONSTRAINT fk_end_location FOREIGN KEY (end_location) REFERENCES location(id)
);



CREATE TABLE path_node(
    path_id INT NOT NULL,
    location INT NOT NULL,
    position INT NOT NULL,
    CONSTRAINT u_path UNIQUE(path_id, position),
    CONSTRAINT fk_node_path FOREIGN KEY (path_id) REFERENCES path (id),
    CONSTRAINT fk_node_location FOREIGN KEY (location) REFERENCES location(id)
);

CREATE TABLE provider (
    id INT PRIMARY KEY,
    first_name VARCHAR2(25) NOT NULL,
    last_name VARCHAR2(30) NOT NULL,
    title VARCHAR2(10) DEFAULT 'MD',
    location INT,
    CONSTRAINT fk_provider_title FOREIGN KEY (title) REFERENCES title (acronym),
    CONSTRAINT fk_provider_location FOREIGN KEY (location) REFERENCES location(id)
);

CREATE TABLE service (
    name VARCHAR2(15) PRIMARY KEY,
    type VARCHAR2(20),
    location INT,
    CONSTRAINT fk_service_location FOREIGN KEY (location) REFERENCES location(id),
    CONSTRAINT service_type_check CHECK (type IN ('service', 'practice'))
);

insert into title values('MD','Doctor of Medicine');
insert into title values('NP','Nurse practitioner');
insert into title values('WHNP','Womens Health Nurse Practitioner');
insert into title values('PA-C','Physician Assistant Certified');
insert into title values('MS','Master of Science');
insert into title values('RDN',' Registered Dietitian Nutritionist');
insert into title values('LDN',' Licensed Dietitian Nutritionist');
insert into title values('RN','Registered Nurse');
insert into title values('CCC-A','Certificate of Clinical Competence in Audiology');
insert into title values('Au.D','Doctor of Audiology');
insert into title values('LCSW','Licensed (Independent) Clinical Social Worker');
insert into title values('RD','Registered Dietitian');
insert into title values('DO','Doctor of Osteopathy');
insert into title values('MEd','Doctor of Medicine');
insert into title values('LADC I','Licensed Alcohol and Drug Counselor I');
insert into title values('PhD','Doctor of Philosophy');

insert into floor values ('F1', 1, 'Faulkner Hospital');
insert into floor values ('F3', 3, 'Faulkner Hospital');

insert into location values (63,-1,3,'3A','office','F3');
insert into location values (64,1,2,'3B','office','F3');
insert into location values (65,2,2,'3C','office','F3');
insert into location values (1,1,1,'Atrium Café','service area','F3');
insert into location values (62,-1,2,'Atrium Elevators','service area','F3');
insert into location values (56,6,5,'Atrium Lobby','service area','F1');
insert into location values (59,6,6,'Atrium Main Entrance','service area','F1');
insert into location values (73,4,0,'Blood Draw Testing','office','F1');
insert into location values (66,1,1,'Cafeteria','service area','F1');
insert into location values (67,-2,-3,'Chapel','office','F3');
insert into location values (55,9,-2,'Day Surgery','office','F1');
insert into location values (26,1,2,'Dialysis Clinic','service area','F1');
insert into location values (21,2,2,'Dialysis Clinic','service area','F3');
insert into location values (27,2,2,'Doherty Conference Room','service area','F1');
insert into location values (28,0,0,'Emergency Department','service area','F1');
insert into location values (53,3,-2,'Endoscopy','office','F1');
insert into location values (51,2,2,'Family Center','office','F1');
insert into location values (61,-1,-1,'Gift Shop','service area','F3');
insert into location values (29,1,1,'H100','hallway','F1');
insert into location values (30,2,1,'H101','hallway','F1');
insert into location values (31,1,2,'H102','hallway','F1');
insert into location values (32,1,4,'H103','hallway','F1');
insert into location values (33,3,1,'H104','hallway','F1');
insert into location values (34,4,1,'H105','hallway','F1');
insert into location values (35,6,1,'H106','hallway','F1');
insert into location values (36,8,1,'H107','hallway','F1');
insert into location values (37,9,1,'H108','hallway','F1');
insert into location values (38,8,-2,'H109','hallway','F1');
insert into location values (39,6,-2,'H110','hallway','F1');
insert into location values (40,6,-1,'H111','hallway','F1');
insert into location values (41,3,-1,'H112','hallway','F1');
insert into location values (42,6,4,'H113','hallway','F1');
insert into location values (43,5,-3,'H114','hallway','F1');
insert into location values (44,6,-3,'H115','hallway','F1');
insert into location values (74,6,0,'H116','hallway','F1');
insert into location values (75,8,2,'H117','hallway','F1');
insert into location values (45,0,0,'H300','hallway','F3');
insert into location values (46,0,-1,'H301','hallway','F3');
insert into location values (47,0,1,'H302','hallway','F3');
insert into location values (48,-1,1,'H303','hallway','F3');
insert into location values (49,0,2,'H304','hallway','F3');
insert into location values (50,0,-2,'H305','hallway','F3');
insert into location values (70,-2,-2,'Hillside Elevators','service area','F3');
insert into location values (68,0,-3,'Hillside Lobby','service area','F3');
insert into location values (60,-1,0,'Huros Auditorium','service area','F3');
insert into location values (69,-1,-3,'Kiosk Location','service area','F3');
insert into location values (58,5,4,'Kiosk Location','service area','F1');
insert into location values (52,3,3,'Patient Registration','office','F1');
insert into location values (54,7,0,'Preoperation Evaluation','office','F1');
insert into location values (76,9,0,'Radiology','office','F1');
insert into location values (72,0,-4,'Shuttle Pickup','service area','F3');
insert into location values (57,4,5,'StarBucks','service area','F1');
insert into location values (71,1,-3,'Volunteer Services','office','F3');


insert into neighbor values (48,49);
insert into neighbor values (50,68);
insert into neighbor values (50,69);
insert into neighbor values (50,70);
insert into neighbor values (50,72);
insert into neighbor values (46,50);
insert into neighbor values (46,61);
insert into neighbor values (45,60);
insert into neighbor values (45,47);
insert into neighbor values (45,46);
insert into neighbor values (47,1);
insert into neighbor values (47,48);
insert into neighbor values (49,65);
insert into neighbor values (49,64);
insert into neighbor values (49,63);
insert into neighbor values (49,62);
insert into neighbor values (29,28);
insert into neighbor values (29,64);
insert into neighbor values (29,30);
insert into neighbor values (31,64);
insert into neighbor values (31,51);
insert into neighbor values (31,32);
insert into neighbor values (32,64);
insert into neighbor values (30,66);
insert into neighbor values (30,33);
insert into neighbor values (41,53);
insert into neighbor values (33,52);
insert into neighbor values (34,33);
insert into neighbor values (34,73);
insert into neighbor values (43,44);
insert into neighbor values (58,42);
insert into neighbor values (44,39);
insert into neighbor values (39,40);
insert into neighbor values (40,41);
insert into neighbor values (35,74);
insert into neighbor values (35,36);
insert into neighbor values (35,34);
insert into neighbor values (42,58);
insert into neighbor values (42,35);
insert into neighbor values (42,56);
insert into neighbor values (38,55);
insert into neighbor values (36,75);
insert into neighbor values (37,76);
insert into neighbor values (37,36);

insert into provider values (1,'Christopher','Chiodo','MD',63);
insert into provider values (2,'Yoon Sun','Chun','MD',63);
insert into provider values (3,'Roger','Clark','DO',63);
insert into provider values (4,'Thomas','Cochrane','MD',63);
insert into provider values (5,'Jeffrey','Cohen','MD',63);
insert into provider values (6,'Natalie','Cohen','MD',63);
insert into provider values (7,'Alene','Conant','MD',63);
insert into provider values (8,'Nathan','Connell','MD',63);
insert into provider values (9,'Maria','Copello','MD',63);
insert into provider values (10,'Carleton Eduardo','Corrales','MD',63);
insert into provider values (11,'Garth Rees','Cosgrove','MD',63);
insert into provider values (12,'Lindsay','Cotter','LCSW',64);
insert into provider values (13,'Christopher','Cua','MD',64);
insert into provider values (14,'Carolyn','DAmbrosio','MD',64);
insert into provider values (15,'Harriet','Dann','MD',64);
insert into provider values (16,'Jatin','Dave','MD',64);
insert into provider values (17,'Paul','Davidson','PhD',65);
insert into provider values (18,'Courtney','Dawson','MD',65);
insert into provider values (19,'Sherrie','Divito','PhD',65);
insert into provider values (20,'Meghan','Doherty','LCSW',65);
insert into provider values (21,'Laura','Dominici','MD',65);

select * from service;
select * from title;
select * from floor;
select * from location;
select * from location_neighbor;
select * from path;
select * from path_node;
select * from provider;

---------- Part 2 ---------
create view filter_offices as
(select id as location_id
from location
where location_type not in ('hallway', 'elevator'));

select title, location_id, count(distinct location_id)
from filter_offices, provider
where location_id = provider.location
and title in ('MD', 'RN')
group by title, location_id;


-- Create or Replace Procedure ProviderLocation (LocationName VARCHAR2(50)) Is
-- cursor C1 is
-- select * 
-- from filter_offices, location
-- where filter_offices.location_id = location.id
-- and location.name = LocationName;
--      Begin
--          For rec in C1  Loop
--          dbms_output.put_line('location ' || LocationName)
--             End Loop;
--      End;
-- /

Create or replace Trigger InvalidLocation
before insert on provider
for each row
Begin
select floor_level
from location
where id = (:new.location);

    if(floor_level == 1) then
    dbms_output.put_line('invalid location for provider!');
    end if;
End;
/


insert into provider values (20,'Meghan','Doherty','LCSW',65);
insert into provider values (21,'Laura','Dominici','MD',55);