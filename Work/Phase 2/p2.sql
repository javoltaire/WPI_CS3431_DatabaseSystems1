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
drop table provider_title CASCADE CONSTRAINTS;


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
    id number PRIMARY KEY,
    x_coord number NOT NULL,
    y_coord number NOT NULL,
    location_name VARCHAR2(30),
    location_type VARCHAR2(15),
    floor char(2) NOT NULL,
    Constraint unique_name UNIQUE(location_name),
    CONSTRAINT unique_coord UNIQUE(x_coord, y_coord, floor, location_name),
    CONSTRAINT check_location_type CHECK (location_type IN ('hallway', 'office', 'service area', 'elevator')),
    CONSTRAINT fk_location_floor FOREIGN KEY (floor) REFERENCES floor(id)
);

-- This a way to connect a location to a every neighboring location, therefore creating edges,
-- So this table essentially stores edges
CREATE TABLE neighbor(
    point_a number NOT NULL,
    point_b number NOT NULL,
    CONSTRAINT u_location_neighbor UNIQUE(point_a, point_b),
    CONSTRAINT fk_point_a_location FOREIGN KEY (point_a) REFERENCES location(id),
    CONSTRAINT fk_point_b_location FOREIGN KEY (point_b) REFERENCES location(id)
);

CREATE TABLE path (
    id number PRIMARY KEY,
    start_location number NOT NULL,
    end_location number NOT NULL,
    CONSTRAINT fk_start_location FOREIGN KEY (start_location) REFERENCES location(id),
    CONSTRAINT fk_end_location FOREIGN KEY (end_location) REFERENCES location(id)
);



CREATE TABLE path_node(
    path_id number NOT NULL,
    location number NOT NULL,
    position number NOT NULL,
    CONSTRAINT u_path UNIQUE(path_id, position),
    CONSTRAINT fk_node_path FOREIGN KEY (path_id) REFERENCES path (id),
    CONSTRAINT fk_node_location FOREIGN KEY (location) REFERENCES location(id)
);

CREATE TABLE provider (
    id number PRIMARY KEY,
    first_name VARCHAR2(25) NOT NULL,
    last_name VARCHAR2(30) NOT NULL,
    location varchar2(30),
    CONSTRAINT fk_provider_location FOREIGN KEY (location) REFERENCES location(location_name)
);

create table provider_title(
    provider_id number not null,
    title varchar2(10) Default 'MD',
    Constraint unique_title_combo UNIQUE (provider_id, title),
    CONSTRAINT fk_provider_title_title FOREIGN KEY (title) REFERENCES title (acronym)
);

CREATE TABLE service (
    name VARCHAR2(50) PRIMARY KEY,
    type VARCHAR2(20),
    location varchar2(30),
    CONSTRAINT fk_service_location_name FOREIGN KEY (location) REFERENCES location(location_name),
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
insert into title values('LICSW','Licensed (Independent) Clinical Social Worker');
insert into title values('RD','Registered Dietitian');
insert into title values('DO','Doctor of Osteopathy');
insert into title values('MEd','Doctor of Medicine');
insert into title values('LADC I','Licensed Alcohol and Drug Counselor I');
insert into title values('PhD','Doctor of Philosophy');
insert into title values('CPNP','Certified Pediatric Nurse Practitioner');
insert into title values('DPM','Doctor of Podiatric Medicine');
insert into title values('DNP','Doctor of Nursing Practice');

insert into floor values ('F1', 1, 'Faulkner Hospital');
insert into floor values ('F3', 3, 'Faulkner Hospital');
insert into floor values ('F5', 5, 'Faulkner Hospital');

insert into location values (1,-1,3,'3A','office','F3');
insert into location values (2,1,2,'3B','office','F3');
insert into location values (3,2,2,'3C','office','F3');
insert into location values (4,-1,2,'Atrium Elevators','elevator','F3');
insert into location values (5,6,5,'Atrium Lobby','service area','F1');
insert into location values (6,1,1,'H100','hallway','F1');
insert into location values (7,2,1,'H101','hallway','F1');
insert into location values (8,1,2,'H102','hallway','F1');
insert into location values (9,1,4,'H103','hallway','F1');
insert into location values (10,3,1,'H104','hallway','F1');
insert into location values (11,4,1,'H105','hallway','F1');
insert into location values (12,6,1,'H106','hallway','F1');
insert into location values (13,8,1,'H107','hallway','F1');
insert into location values (14,9,1,'H108','hallway','F1');
insert into location values (15,8,-2,'H109','hallway','F1');
insert into location values (16,6,-2,'H110','hallway','F1');
insert into location values (17,6,-1,'H111','hallway','F1');
insert into location values (18,3,-1,'H112','hallway','F1');
insert into location values (19,6,4,'H113','elevator','F1');
insert into location values (20,5,-3,'H114','elevator','F1');
insert into location values (21,6,-3,'H115','hallway','F1');
insert into location values (22,6,0,'H116','hallway','F1');
insert into location values (23,8,2,'H117','hallway','F1');
insert into location values (24,0,0,'H300','hallway','F3');
insert into location values (25,0,-1,'H301','hallway','F3');
insert into location values (26,0,1,'H302','hallway','F3');
insert into location values (27,-1,1,'H303','hallway','F3');
insert into location values (28,0,2,'H304','hallway','F3');
insert into location values (29,0,-2,'Hillside Lobby','hallway','F3');
insert into location values (30,-2,-2,'Hillside Elevators','elevator','F3');

insert into location values (33,-3,5,'5A','office','F5');
insert into location values (34,-2,7,'5B','office','F5');
insert into location values (35,0,7,'5C','office','F5');
insert into location values (36,2,7,'5D','office','F5');
insert into location values (75,3,7,'5E','office','F5');
insert into location values (37,1,3,'5F','office','F5');
insert into location values (38,-1,2,'5G','office','F5');
insert into location values (39,1,1,'5H','office','F5');
insert into location values (40,-1,1,'5I','office','F5');
insert into location values (41,-1,0,'5J','office','F5');
insert into location values (76,1,0,'5K','office','F5');
insert into location values (77,1,-1,'5L','office','F5');
insert into location values (78,2,4,'5SOS','service area','F5');
insert into location values (74,0,-5,'5M','office','F5');
insert into location values (32,-4,-5,'5N','office','F5');
insert into location values (31,-6,-4,'5NICU','service area','F5');
insert into location values (42,-5,-4,'H501','hallway','F5');
insert into location values (43,-4,-4,'H502','hallway','F5');
insert into location values (44,-1,-4,'H503','hallway','F5');
insert into location values (45,0,-4,'H504','hallway','F5');
insert into location values (46,1,-4,'H505','hallway','F5');
insert into location values (47,0,-3,'H506','elevator','F5');
insert into location values (48,0,-2,'H507','hallway','F5');
insert into location values (49,0,-1,'H508','hallway','F5');
insert into location values (50,0,0,'H509','hallway','F5');
insert into location values (79,0,1,'H510','hallway','F5');
insert into location values (80,0,2,'H511','hallway','F5');
insert into location values (81,0,3,'H512','hallway','F5');
insert into location values (82,0,4,'H513','hallway','F5');
insert into location values (83,0,5,'H514','elevator','F5');
insert into location values (84,0,6,'H515','hallway','F5');
insert into location values (85,-1,6,'H516','hallway','F5');
insert into location values (86,1,6,'H517','hallway','F5');
insert into location values (87,2,6,'H518','hallway','F5');
insert into location values (88,-2,6,'H519','hallway','F5');
insert into location values (89,-2,5,'H520','hallway','F5');
insert into location values (90,-2,4,'H521','hallway','F5');
insert into location values (91,2,5,'H522','hallway','F5');
insert into location values (92,2,4,'H523','hallway','F5');

insert into location values (51,1,1,'Atrium Café','service area','F3');
insert into location values (53,6,6,'Atrium Main Entrance','service area','F1');
insert into location values (54,4,0,'Blood Testing','service area','F1');
insert into location values (55,1,1,'Cafeteria','service area','F1');
insert into location values (56,-2,-3,'Chapel','service area','F3');
insert into location values (57,9,-2,'Day Surgery','service area','F1');
insert into location values (58,1,2,'Dialysis Clinic','service area','F1');
insert into location values (60,2,2,'Doherty Conference Room','service area','F1');
insert into location values (61,0,0,'Emergency','service area','F1');
insert into location values (62,3,-2,'Endoscopy','service area','F1');
insert into location values (63,2,2,'Family Center','service area','F1');
insert into location values (65,-1,0,'Huvos','service area','F3');
insert into location values (66,3,3,'Patient Registration','service area','F1');
insert into location values (67,7,0,'Preoperation Evaluation','service area','F1');
insert into location values (68,9,0,'Radiology','service area','F1');
insert into location values (69,0,-4,'Shuttle Pickup','service area','F3');
insert into location values (70,4,5,'StarBucks','service area','F1');
insert into location values (71,1,-3,'Volunteer Services','service area','F3');
insert into location values (72,5,9,'Valet','service area','F1');
insert into location values (73,8,1,'Lab','service area','F1');

insert into neighbor values ( 42,31);
insert into neighbor values ( 43,31);
insert into neighbor values ( 44,74);
insert into neighbor values ( 46,41);
insert into neighbor values ( 47,38);
insert into neighbor values ( 47,39);
insert into neighbor values ( 48,33);
insert into neighbor values ( 49,35);
insert into neighbor values ( 49,34);
insert into neighbor values ( 49,36);
insert into neighbor values ( 4,28);
insert into neighbor values ( 28,1);
insert into neighbor values ( 28,2);
insert into neighbor values ( 28,3);
insert into neighbor values ( 29,30);
insert into neighbor values ( 29,56);
insert into neighbor values ( 29,69);
insert into neighbor values ( 26,65);
-- Elevators to Elevators
insert into neighbor values (47,30);
insert into neighbor values (83,4);
insert into neighbor values (30,20);
insert into neighbor values (4,19);
-- Elevators to Floors
insert into neighbor values (47,45);
insert into neighbor values (83,82);
insert into neighbor values (21,20);
insert into neighbor values (12,19);

insert into provider values (1,'Mohammed','Issa','5S');
insert into provider values (2,'Jennifer','Byrne','3A');
insert into provider values (3,'Lisa','Grossi','3A');
insert into provider values (4,'Elisabeth','Keller','3A');
insert into provider values (5,'Linda','Malone','3A');
insert into provider values (6,'Beverly','Morrison','3A');
insert into provider values (7,'Elizabeth','OConnor','3A');
insert into provider values (8,'Andrew','Saluti','3A');
insert into provider values (9,'David','Scheff','3A');
insert into provider values (10,'Robert','Stacks','3A');
insert into provider values (11,'Mitchell','Tunick','3A');
insert into provider values (12,'Julianne','Viola','3A');
insert into provider values (13,'Harriet','Dann','3B');
insert into provider values (14,'George','Frangieh','3B');
insert into provider values (15,'Bruce','Micley','3B');
insert into provider values (16,'James','Patten','3B');
insert into provider values (17,'James Adam','Greenberg','3C');
insert into provider values (18,'Julie','Miner','3C');
insert into provider values (19,'Sarah','Nadarajah','3C');
insert into provider values (20,'Leila','Schueler','3C');
insert into provider values (21,'Shannon','Smith','3C');
insert into provider values (22,'Trevor','Angell','5D');
insert into provider values (23,'Arnold','Alqueza','5S');
insert into provider values (24,'Nomee','Altschul','5S');
insert into provider values (25,'Shamik','Bhattacharyya','5S');
insert into provider values (26,'Phil','Blazar','5S');
insert into provider values (27,'Eric','Bluman','5S');
insert into provider values (28,'Christopher','Bono','5S');
insert into provider values (29,'Gregory','Brick','5S');
insert into provider values (30,'Mary Anne','Carleen','5S');
insert into provider values (31,'Christopher','Chiodo','5S');
insert into provider values (32,'Garth Rees','Cosgrove','5S');
insert into provider values (33,'Courtney','Dawson','5S');
insert into provider values (34,'Michael','Drew','5S');
insert into provider values (35,'George','Dyer','5S');
insert into provider values (36,'Brandon','Earp','5S');
insert into provider values (37,'Joerg','Ermann','5S');
insert into provider values (38,'Wolfgang','Fitz','5S');
insert into provider values (39,'Michael','Groff','5S');
insert into provider values (40,'Mitchel','Harris','5S');
insert into provider values (41,'Joseph','Hartigan','5S');
insert into provider values (42,'Laurence','Higgins','5S');
insert into provider values (43,'Yi','Lu','5S');
insert into provider values (44,'Elizabeth','Matzkin','5S');
insert into provider values (45,'Mallory','Pingeton','5S');
insert into provider values (46,'Andrew','Schoenfeld','5S');
insert into provider values (47,'Jeremy','Smith','5S');
insert into provider values (48,'Cristin','Taylor','5S');
insert into provider values (49,'Adam','Tenforde','5S');
insert into provider values (50,'Shari','Vigneau','5S');
insert into provider values (51,'Kaitlyn','Whitlock','5S');
insert into provider values (52,'Jay','Zampini','5S');
insert into provider values (53,'Zacharia','Isaac','5S');
insert into provider values (54,'Ehren','Nelson','5S');
insert into provider values (55,'Jason','Yong','5S');
insert into provider values (56,'Nancy','Oliveira','5A');
insert into provider values (57,'Joseph','Groden','5B');
insert into provider values (58,'William','Innis','5B');
insert into provider values (59,'Joshua','Kessler','5B');
insert into provider values (60,'William','Mason','5B');
insert into provider values (61,'Halie','Paperno','5B');
insert into provider values (62,'Mariah','Samara','5B');
insert into provider values (63,'Rebecca','Stone','5B');
insert into provider values (64,'Joseph Jr.','Barr','5C');
insert into provider values (65,'Matthew','Butler','5C');
insert into provider values (66,'Fulton','Kornack','5C');
insert into provider values (67,'Robert','Savage','5C');
insert into provider values (68,'Anthony','Webber','5C');
insert into provider values (69,'Laura','Andromalos','5D');
insert into provider values (70,'Meghan','Ariagno','5D');
insert into provider values (71,'Michael','Belkin','5D');
insert into provider values (72,'Paul','Davidson','5D');
insert into provider values (73,'Katy','Hartman','5D');
insert into provider values (74,'Jennifer','Irani','5D');
insert into provider values (75,'Kellene','Isom','5D');
insert into provider values (76,'Pardon','Kenney','5D');
insert into provider values (77,'Allison','Kleifield','5D');
insert into provider values (78,'Robert','Matthews','5D');
insert into provider values (79,'Neyla','Melnitchouk','5D');
insert into provider values (80,'Matthew','Nehs','5D');
insert into provider values (81,'Erika','Rangel','5D');
insert into provider values (82,'Erin','Reil','5D');
insert into provider values (83,'Malcolm','Robinson','5D');
insert into provider values (84,'Eric','Sheu','5D');
insert into provider values (85,'Brent','Shoji','5D');
insert into provider values (86,'David','Spector','5D');
insert into provider values (87,'Ali','Tavakkoli','5D');
insert into provider values (88,'Ashley','Vernon','5D');
insert into provider values (89,'James','Warth','5F');
insert into provider values (90,'Maria','Warth','5F');
insert into provider values (91,'Eva','Balash','5G');
insert into provider values (92,'Sherrie','Divito','5G');
insert into provider values (93,'Jason','Frangos','5G');
insert into provider values (94,'Colleen','Monaghan','5H');
insert into provider values (95,'Kitty','OHare','5H');
insert into provider values (96,'Niraj','Sharma','5H');
insert into provider values (97,'Dhirendra','Bana','5I');
insert into provider values (98,'David','Cahan','5I');
insert into provider values (99,'Malavalli','Gopal','5I');
insert into provider values (100,'Stephanie','Berman','5J');
insert into provider values (101,'Michael','Healey','5J');
insert into provider values (102,'Karl','Laskowski','5J');
insert into provider values (103,'Katy','Litwak','5J');
insert into provider values (104,'Orietta','Miatto','5J');
insert into provider values (105,'Neil','Wagle','5J');

insert into provider_title values (1,'MD');
insert into provider_title values (2,'RN');
insert into provider_title values (3,'RN');
insert into provider_title values (4,'MD');
insert into provider_title values (5,'DNP');
insert into provider_title values (6,'MD');
insert into provider_title values (7,'MD');
insert into provider_title values (8,'DO');
insert into provider_title values (9,'MD');
insert into provider_title values (10,'MD');
insert into provider_title values (11,'MD');
insert into provider_title values (12,'MD');
insert into provider_title values (13,'MD');
insert into provider_title values (14,'MD');
insert into provider_title values (15,'MD');
insert into provider_title values (16,'MD');
insert into provider_title values (17,'MD');
insert into provider_title values (18,'MD');
insert into provider_title values (19,'WHNP');
insert into provider_title values (20,'MD');
insert into provider_title values (21,'MD');
insert into provider_title values (22,'MD');
insert into provider_title values (23,'MD');
insert into provider_title values (24,'PA-C');
insert into provider_title values (25,'MD');
insert into provider_title values (26,'MD');
insert into provider_title values (27,'MD');
insert into provider_title values (28,'MD');
insert into provider_title values (29,'MD');
insert into provider_title values (30,'PA-C');
insert into provider_title values (31,'MD');
insert into provider_title values (32,'MD');
insert into provider_title values (33,'MD');
insert into provider_title values (34,'MD');
insert into provider_title values (35,'MD');
insert into provider_title values (36,'MD');
insert into provider_title values (37,'MD');
insert into provider_title values (38,'MD');
insert into provider_title values (39,'MD');
insert into provider_title values (40,'MD');
insert into provider_title values (41,'DPM');
insert into provider_title values (42,'MD');
insert into provider_title values (43,'MD');
insert into provider_title values (44,'MD');
insert into provider_title values (45,'PA-C');
insert into provider_title values (46,'MD');
insert into provider_title values (47,'MD');
insert into provider_title values (48,'PA-C');
insert into provider_title values (49,'MD');
insert into provider_title values (50,'PA-C');
insert into provider_title values (51,'PA-C');
insert into provider_title values (52,'MD');
insert into provider_title values (53,'MD');
insert into provider_title values (54,'MD');
insert into provider_title values (55,'MD');
insert into provider_title values (56,'MS');
insert into provider_title values (57,'MD');
insert into provider_title values (58,'MD');
insert into provider_title values (59,'MD');
insert into provider_title values (60,'MD');
insert into provider_title values (61,'Au.D');
insert into provider_title values (62,'MD');
insert into provider_title values (63,'MD');
insert into provider_title values (64,'MD');
insert into provider_title values (65,'DPM');
insert into provider_title values (66,'MD');
insert into provider_title values (67,'MD');
insert into provider_title values (68,'MD');
insert into provider_title values (69,'RD');
insert into provider_title values (70,'RD');
insert into provider_title values (71,'MD');
insert into provider_title values (72,'PhD');
insert into provider_title values (73,'MS');
insert into provider_title values (74,'MD');
insert into provider_title values (75,'MS');
insert into provider_title values (76,'MD');
insert into provider_title values (77,'PA-C');
insert into provider_title values (78,'PA-C');
insert into provider_title values (79,'MD');
insert into provider_title values (80,'MD');
insert into provider_title values (81,'MD');
insert into provider_title values (82,'RD');
insert into provider_title values (83,'MD');
insert into provider_title values (84,'MD');
insert into provider_title values (85,'MD');
insert into provider_title values (86,'MD');
insert into provider_title values (87,'MD');
insert into provider_title values (88,'MD');
insert into provider_title values (89,'MD');
insert into provider_title values (90,'MD');
insert into provider_title values (91,'MD');
insert into provider_title values (92,'MD');
insert into provider_title values (93,'MD');
insert into provider_title values (94,'MD');
insert into provider_title values (95,'MD');
insert into provider_title values (96,'MD');
insert into provider_title values (97,'MD');
insert into provider_title values (98,'MD');
insert into provider_title values (99,'MD');
insert into provider_title values (100,'MD');
insert into provider_title values (101,'MD');
insert into provider_title values (102,'MD');
insert into provider_title values (103,'LICSW');
insert into provider_title values (104,'MD');
insert into provider_title values (105,'MD');
insert into provider_title values (2,'CPNP');
insert into provider_title values (3,'MS');
insert into provider_title values (3,'CPNP');
insert into provider_title values (5,'RN');
insert into provider_title values (5,'CPNP');
insert into provider_title values (56,'RDN');
insert into provider_title values (56,'LDN');
insert into provider_title values (61,'CCC-A');
insert into provider_title values (69,'LDN');
insert into provider_title values (70,'LDN');
insert into provider_title values (73,'RD');
insert into provider_title values (73,'LDN');
insert into provider_title values (75,'RN');
insert into provider_title values (75,'LDN');
insert into provider_title values (82,'LDN');
insert into provider_title values (92,'PhD');

insert into service values ('Information','service','Atrium Lobby');
insert into service values ('Admitting/Registration','service','Atrium Lobby');
insert into service values ('Atrium Café','service','Atrium Lobby');
insert into service values ('Audiology','practice','Lab');
insert into service values ('Cardiac Rehabilitation','practice','Lab');
insert into service values ('Center for Preoperative Evaluation','practice','Preoperation Evaluation');
insert into service values ('Emergency Department','practice','Emergency');
insert into service values ('GI Endoscopy','practice','Endoscopy');
insert into service values ('Laboratory','practice','Lab');
insert into service values ('Patient Financial Services','service','Endoscopy');
insert into service values ('Radiology','practice','Family Center');
insert into service values ('Special Testing','practice','Radiology');
insert into service values ('Taiclet Family Center','service','Blood Testing');
insert into service values ('Valet Parking','service','Valet');
insert into service values ('Roslindale Pediatric Associates ','practice','3A');
insert into service values ('Eye Care Specialists ','practice','3B');
insert into service values ('Suburban Eye Specialists ','practice','3B');
insert into service values ('Obstetrics and Gynecology Associates','practice','3C');
insert into service values ('ATM ','service','Hillside Lobby');
insert into service values ('Cafeteria','service','Hillside Lobby');
insert into service values ('Chapel and Chaplaincy Services','service','Chapel');
insert into service values ('Gift Shop','service','Hillside Lobby');
insert into service values ('Huvos Auditorium','service','Huvos');
insert into service values ('Patient Relations','service','Hillside Lobby');
insert into service values ('Volunteer Services','service','Volunteer Services');
insert into service values ('Brigham and Womens Primary Physicians','practice','5J');
insert into service values ('ICU','practice','5N');
insert into service values ('Inpatient Hemodialysis','practice','5N');
insert into service values ('Outpatient Infusion Center','practice','5N');
insert into service values ('Foot and Ankle Center  ','practice','5S');
insert into service values ('Hand and Upper Extremity Service','service','5S');
insert into service values ('Neurosurgery','practice','5S');
insert into service values ('Orthopedics Center','practice','5S');
insert into service values ('Spine Center','practice','5S');
insert into service values ('Nutrition Clinic','practice','5A');
insert into service values ('Boston ENT Associates','practice','5B');
insert into service values ('Orthopaedics Associates','practice','5C');
insert into service values ('Center for Metabolic Health and Bariatric Surgery','practice','5D');
insert into service values ('Colorectal Surgery','practice','5D');
insert into service values ('General Surgery  ','practice','5D');
insert into service values ('Nutrition - Weight Loss Surgery','practice','5D');
insert into service values ('Psychology - Weight Loss Surgery','practice','5D');
insert into service values ('Surgical Specialties','practice','5D');
insert into service values ('Vascular Surgery  ','practice','5D');
insert into service values ('Brigham Dermatology Associates','practice','5G');
insert into service values ('Family Care Associates','service','5H');
insert into service values ('Sleep Testing Center','service','5M');

select * from service;
select * from title;
select * from floor;
select * from location;
select * from neighbor;
select * from path;
select * from path_node;
select * from provider;
select * from provider_title;

---------- Phase 2 ---------

drop view filter_offices;
drop view count_providers;

--- Part 1 ----
set serveroutput on;

create view filter_offices as
(select location_name
from location
where location_type not in ('hallway', 'elevator'));

select title, location_name, count(location_name)
from filter_offices, provider, provider_title
where location_name = provider.location
and provider.id = provider_title.provider_id
and title in ('MD', 'RN')
group by title, location_name;


create view count_providers as
select location_name, count(*) as provider_count
from provider, location
WHERE location.location_name = provider.location
group by location_name;

Create or replace Function get_provider_count(prov_location varchar2) Return NUMBER Is
     provider_count INTEGER;
     Begin
          SELECT count(*) INTO provider_count
          FROM provider, location
          WHERE location_name = prov_location
       and provider.location = LOCATION_NAME;
          Return(provider_count);
     End;
/


create or replace procedure get_providers
  (provider_location varchar2)
IS
BEGIN
DBMS_OUTPUT.PUT_LINE('number of providers: ' || get_provider_count(provider_location));
END get_providers;
/


---------- Part 2 -----------
Create or replace Trigger invalid_provider_location
before insert or update on provider
for each row
  DECLARE
    f_level INTEGER;
  Begin
    select FLOOR_LEVEL into f_level
    from floor, LOCATION
    where LOCATION.FLOOR = floor.ID
          and :new.LOCATION = location.LOCATION_NAME;
    if(f_level = 1) then
      raise_application_error( -20001, 'Invalid location for provider');
    end if;

  End;
  /

delete from provider where id = 102;
insert into provider values (101,'Ebenezer','Ampiah','Atrium Lobby');
insert into provider values (102,'Jules','Voltaire','5M');

Create or replace Trigger invalid_num_titles
before insert on provider_title
for each row
  DECLARE
    counter number(2, 0);
      ex_custom EXCEPTION;
    PRAGMA EXCEPTION_INIT( ex_custom, -20002 );
  Begin
    select count(*) into counter
    FROM PROVIDER_TITLE
    WHERE provider_id = :new.PROVIDER_ID;
    if(counter = 3) then
      raise_application_error( -20002, 'Too many titles');
    end if;
  End;
  /

delete from provider_title where provider_id = 101;
delete from provider where id = 101;
insert into provider values (101,'Ebenezer','Ampiah','5A');
insert into provider_title values (101,'LICSW');
insert into provider_title values (101,'MD');
insert into provider_title values (101,'PhD');
insert into provider_title values (101,'CPNP'); 

Create or replace Trigger redo_insert
before insert on provider
for each row
  DECLARE
    counter INTEGER;
  Begin
    select count(*) into counter
    FROM provider, LOCATION
    WHERE provider.location = :new.LOCATION;
    if(counter >= 20 and :new.LOCATION != '5A') then
      :new.location := '5A';
    end if;
  End;
  /

delete from provider where id = 103 or id = 104;
insert into provider values (103,'Ebenezer','Ampiah','5S');
insert into provider values (104,'Jules','Voltaire','5M');

create or replace function get_floor_level(location_id number) Return NUMBER Is
     level1 number;
     Begin
          select floor_level into level1
from floor, location
where location.floor = floor.id
and location.id = location_id;
          Return(level1);
     End;
/


Create or replace Trigger neighbor_check
before insert on neighbor
for each row
DECLARE
loc_type varchar2(15);
level1 number;
level2 number;
Begin 
select location_type into loc_type
from location
where id = :new.point_a;
level1 := get_floor_level(:new.point_a);
level2 := get_floor_level(:new.point_b);

if(level1 != level2 and loc_type != 'elevator') then
  raise_application_error(-20003, 'Only elevators can have neighbors on different floors');
end if;
End;
  /

delete from neighbor where point_a = 30 and point_b = 31;
insert into neighbor values (51, 53);
insert into neighbor values (30, 31);