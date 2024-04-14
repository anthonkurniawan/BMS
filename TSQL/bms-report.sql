
USE BMS3;

DROP TABLE IF EXISTS comment;
CREATE TABLE comment ( id int(10) NOT NULL auto_increment,report_id int(10) NOT NULL,submit_date datetime,
comment varchar(1000),isReject int(1),position varchar(50),username varchar(50),fullname varchar(100), PRIMARY KEY (id) ); 

insert into comment values ('1','159','2014-10-27 00:00:00','sssss','0','int','eng','engineering user 1' );
insert into comment values ('2','159','2014-10-27 00:01:00','yyyyyyyyyy','0','spv_eng','eng_spv1','Engineer Supervisor 1' );
insert into comment values ('3','158','2014-05-23 00:00:00','coba lagi tong','1','spv_qa','qa_spv1','Quality Assurance Supervisor 1' );
insert into comment values ('4','158','2014-05-23  00:00:00','test','0','int','eng','engineering user 1' );
insert into comment values ('5','129','2014-05-02','TEST DEV AHU2','0','int','eng','initiator engineering1' );
insert into comment values ('6','150','2014-05-05','kkkkkkkkkkkkkkk','0','int','eng','initiator engineering1' );
insert into comment values ('7','158','2014-05-24','cobadeh','0','int','eng','initiator engineering1' );
insert into comment values ('8','129','2014-05-02','REPLY FROM SPV ENG','0','spv_eng','eng_spv1','supervisor engineering' );
insert into comment values ('9','158','2014-05-21','ok','0','spv_eng','eng_spv1','supervisor engineering' );
insert into comment values ('10','129','2014-05-02','REPLY SPV QA','0','spv_qa','qa_spv1','supervisor QA' );
insert into comment values ('11','129','2014-05-03','revisi ahu2','0','int','eng','initiator engineering1' );
insert into comment values ('12','160','2014-11-02','test&nbsp;<b style="line-height: 1.5em;">text bold&nbsp;</b><span style="font-size: 15px; line-height: 1.5em;">lin</span><span style="font-size: 15px; line-height: 1.5em;">k</span></a></span></font></sup></span></span></span></span></span><p></p><p><ol><li><span style="line-height: 22.5px;">satu</span></li><li><span style="line-height: 22.5px;">dua</span></li></ol></p>','0','int','eng','engineering user 1' );
insert into comment values ('13','161','2014-11-02','text normal <b>bold </b><i>italic</i> <u>underline</u> <sup>superscript</sup>&nbsp;<font color="#0000ff"><span style="color: rgb(255, 0, 0);">color&nbsp;<span style="color:rgb(0,0,0);undefined">&nbsp;<font color="#000000"><a href="http://facebook.com">link</a></font></span></span></font><p><ol><li>satu</li><li>dua</li></ol></p>','0','int','eng','engineering user 1' );
insert into comment values ('14','162','2014-11-04','test lagi','0','int','eng','engineering user 1' );
insert into comment values ('15','150','2014-11-04','test rejct','1','spv_eng','eng_spv1','Engineer Supervisor 1' );
insert into comment values ('16','159','2014-11-04','sip','0','spv_qa','qa_spv1','Quality Assurance Supervisor 1' );
insert into comment values ('17','162','2015-04-17','aaaaaaasssssssssss','0','spv_eng','eng_spv1','Engineer Supervisor 1' );
insert into comment values ('18','162','2015-04-17','','0','spv_eng','eng_spv1','Engineer Supervisor 1' );
insert into comment values ('19','162','2015-04-17','sss','0','spv_eng','eng_spv1','Engineer Supervisor 1' );
insert into comment values ('20','162','2015-04-17','eee','0','spv_eng','eng_spv1','Engineer Supervisor 1' );
insert into comment values ('22','163','2015-07-08','','0','admin_eng','admin','administrator BAS' );
insert into comment values ('23','164','2015-07-08','','0','admin_eng','admin','administrator BAS' );
insert into comment values ('21','162','2015-04-17','ttt','0','spv_eng','eng_spv1','Engineer Supervisor 1' );


DROP TABLE IF EXISTS rate_time;
CREATE TABLE rate_time ( time int(10) NOT NULL,ket varchar(20) NOT NULL ); 

insert into rate_time values ('1800','30 Minutes' );

DROP TABLE IF EXISTS report;
CREATE TABLE report ( id int(10) NOT NULL auto_increment,unit varchar(20),dept varchar(20),date date,status int(10),
submit_date_int datetime,note_int varchar(255),sign_int varchar(30),sign_int_full varchar(30),submit_date_spv_int datetime,
note_spv_int varchar(255),sign_spv_int varchar(30),sign_spv_int_full varchar(30),submit_date_spv_eng datetime,note_spv_eng varchar(255),
sign_spv_eng varchar(30),sign_spv_eng_full varchar(30),submit_date_spv_qa datetime,note_spv_qa varchar(255),sign_spv_qa varchar(30),
sign_spv_qa_full varchar(30),progress int(10), PRIMARY KEY (id) ); 

insert into report values ('117','ahu1','eng','2013-10-01 00:00:00','1','2013-10-25','No deviasi','eng','engineering user 1','','','','','','','','','','','','','9' );
insert into report values ('118','ahu1','eng','2013-10-02 00:00:00','2','2013-10-25','aa','eng','engineering user 1','','','','','2013-10-25','ddd','eng_spv1','Engineer Supervisor 1','2013-10-30','hhhhhh','qa_spv1','Quality Assurance Supervisor 1','4' );
insert into report values ('163','equipment','qa','2013-10-02 00:00:00','3','2014-05-23  00:00:00','rrrrrrrrrr','qa','qa int user','','','','','2014-05-23  00:01:00','tttttttttt','eng_spv1','Engineer Supervisor 1','','','','','3' );
insert into report values ('164','wfi','eng','2013-05-28','2','2014-05-23  00:00:00','ddddd','eng','engineering user 1','','','','','','','','','','','','','2' );
insert into report values ('165','ahu2','eng','2013-05-28','2','2014-05-23  00:01:00','ggggggg','eng','engineering user 1','','','','','','','','','','','','','2' );
insert into report values ('122','warehouse','wh','2013-10-01 00:00:00','1','2013-10-25','No deviasi','wh','Warehouse Area','','','','','','','','','','','','','9' );
insert into report values ('123','warehouse','wh','2013-10-02 00:00:00','2','2013-10-25','qq','wh','Warehouse Area','2013-10-25','fff','wh_spv1','Warehouse Supervisor 1','2013-10-25','ff','eng_spv1','Engineer Supervisor 1','2014-05-23  00:00:00','eeeeee','qa_spv1','Quality Assurance Supervisor 1','4' );
insert into report values ('124','warehouse','wh','2013-10-03 00:00:00','2','2013-10-25','gg','wh','Warehouse Area','2013-10-25','jjj','wh_spv1','Warehouse Supervisor 1','2014-05-23  00:01:00','uuuuuuuu','eng_spv1','Engineer Supervisor 1','','','','','3' );
insert into report values ('125','warehouse','wh','2013-10-04 00:00:00','3','2013-10-25','hh','wh','Warehouse Area','2013-10-25','uuu','wh_spv1','Warehouse Supervisor 1','','','','','','','','','4' );
insert into report values ('126','warehouse','wh','2013-10-05 00:00:00','2','2013-10-25','tttt','wh','Warehouse Area','2013-10-30','hh','wh_spv1','Warehouse Supervisor 1','','','','','','','','','2' );
insert into report values ('127','warehouse','wh','2013-10-06 00:00:00','2','2013-10-30','jj','wh','Warehouse Area','','','','','','','','','','','','','1' );
insert into report values ('166','wpu','eng','2013-05-28','2','2014-05-23  00:00:00','aaaaaaa','eng','engineering user 1','','','','','','','','','','','','','2' );
insert into report values ('129','ahu2','eng','2013-10-02 00:00:00','2','2014-05-02','TEST DEV AHU2','eng','engineering user 1','','','','','2014-05-02','REPLY FROM SPV ENG','eng_spv1','Engineer Supervisor 1','2014-05-02','REPLY SPV QA','qa_spv1','Quality Assurance Supervisor 1','4' );
insert into report values ('130','qa','qa','2013-08-01','1','2014-05-02','No deviasi','qa','qa int user','','','','','','','','','','','','','9' );
insert into report values ('131','drycore','pro','2013-05-01','1','2014-05-04','No deviasi','dry_core1','Dry Core user','','','','','','','','','','','','','9' );
insert into report values ('132','sterile','pro','2013-10-01 00:00:00','2','2014-05-04','TEST DEV STERILE1','dry_core1','Dry Core user','2014-05-04','eeeeeeeeeeeeee','dry_spv1','Drycore Supervisor 1','2014-05-04','ddddddddd','eng_spv1','Engineer Supervisor 1','','','','','3' );
insert into report values ('133','goods','pro','2013-10-01 00:00:00','2','2014-05-04','TEST DEV RETAIN1','dry_core1','Dry Core user','2014-05-23  00:00:00','ddddddd','dry_spv1','Drycore Supervisor 1','','','','','','','','','2' );
insert into report values ('134','goods','pro','2013-10-02 00:00:00','3','2014-05-04','TEST DEV2','dry_core1','Dry Core user','2014-05-04','wwwwwwwww','dry_spv1','Drycore Supervisor 1','','','','','','','','','4' );
insert into report values ('135','wpu','eng','2013-05-01','3','2014-05-04','ddddddddd','eng','engineering user 1','','','','','2014-05-04','ooooooooooo','eng_spv1','Engineer Supervisor 1','','','','','4' );
insert into report values ('162','equipment','qa','2013-10-01 00:00:00','2','2014-05-23  00:00:00','ttttttttt','qa','qa int user','','','','','','','','','','','','','2' );
insert into report values ('167','demin','eng','2013-05-28','2','2014-05-23  00:00:00','aaaaaaa
f
g
h','eng','engineering user 1','','','','','','','','','','','','','2' );
insert into report values ('168','ahu1','eng','2013-05-28','2','2014-05-23  00:00:00','sss
ff
g
hh','eng','engineering user 1','','','','','','','','','','','','','2' );
insert into report values ('139','qa','qa','2013-10-05 00:00:00','2','2014-05-05','dddddddddd','qa','qa int user','','','','','2014-05-23  00:00:00','eeeeeeeee','eng_spv1','Engineer Supervisor 1','','','','','3' );
insert into report values ('140','qa','qa','2013-10-01 00:00:00','2','2014-05-05','tttttttttttttt','qa','qa int user','','','','','2014-05-23  00:00:00','eeeeee','eng_spv1','Engineer Supervisor 1','2014-05-23  00:00:00','rrrrrrrrrrrr','qa_spv1','Quality Assurance Supervisor 1','4' );
insert into report values ('141','warehouse','wh','2013-09-01','1','2014-05-05','No deviasi','wh','Warehouse Area','','','','','','','','','','','','','9' );
insert into report values ('142','warehouse','wh','2013-10-07 00:00:00','2','2014-05-05','ffffffffffff','wh','Warehouse Area','','','','','','','','','','','','','1' );
insert into report values ('143','warehouse','wh','2013-10-08 00:00:00','2','2014-05-05','aaaaaaaaaaaaa','wh','Warehouse Area','2014-05-23  00:00:00','WWWWWWWWW','wh_spv1','Warehouse Supervisor 1','','','','','','','','','2' );
insert into report values ('144','drycore','pro','2013-05-02','1','2014-05-05','No deviasi','dry_core1','Dry Core user','','','','','','','','','','','','','9' );
insert into report values ('145','sterile','pro','2013-09-01','1','2014-05-05','No deviasi','dry_core1','Dry Core user','','','','','','','','','','','','','9' );
insert into report values ('146','drycore','pro','2013-10-02 00:00:00','2','2014-05-05','yyyyyyyyyyyy','dry_core1','Dry Core user','','','','','','','','','','','','','1' );
insert into report values ('147','sterile','pro','2013-10-02 00:00:00','2','2014-05-05','iiiiiiiiiiiiii','dry_core1','Dry Core user','2014-05-23  00:00:00','ddddddd','dry_spv1','Drycore Supervisor 1','2014-05-23  00:00:00','yyyyyyyy','eng_spv1','Engineer Supervisor 1','2014-05-23  00:00:00','dddddd','qa_spv1','Quality Assurance Supervisor 1','4' );
insert into report values ('169','drycore','pro','2013-05-28','2','2014-05-23  00:00:00','ssssssssss','dry_core1','Dry Core user','','','','','','','','','','','','','1' );
insert into report values ('170','sterile','pro','2013-05-28','2','2014-05-23  00:00:00','dfdfdfdfdfd fgfgfgfgfg fgggggggggggg hhhhhhhhhh hhhhhhhhhhh jjjjjjjjjjjjjjj ssssssssssss fffffffffffffffff hhhhhhhhhhh jjjjjjjjjjjjj gggggggggggg hhhhhhhhhhh kkkkkkkkk','dry_core1','Dry Core user','','','','','','','','','','','','','1' );
insert into report values ('150','wfi','eng','2013-10-01 00:00:00','2','2014-05-05','kkkkkkkkkkkkkkk','eng','engineering user 1','','','','','','','','','','','','','2' );
insert into report values ('171','goods','pro','2013-05-28','2','2014-05-23  00:00:00','dfdfdfdfdfd fgfgfgfgfg fgggggggggggg hhhhhhhhhh hhhhhhhhhhh jjjjjjjjjjjjjjj ssssssssssss fffffffffffffffff hhhhhhhhhhh jjjjjjjjjjjjj gggggggggggg hhhhhhhhhhh kkkkkkkkk','dry_core1','Dry Core user','','','','','','','','','','','','','1' );
insert into report values ('174','warehouse','wh','2013-05-28','2','2014-05-23  00:00:00','In the interest of pursuing employment opportunity within your prestigious company for the position of  IT (Information Technology), I wish to be considered to fill in that position.','wh','Warehouse Area','','','','','','','','','','','','','1' );
insert into report values ('153','ahu2','eng','2013-10-03 00:00:00','2','2014-05-12','fffffffffffffff','eng','engineering user 1','','','','','','','','','','','','','1' );
insert into report values ('158','wpu','eng','2013-05-02','2','2014-05-23  00:00:00','xxxxxx','eng','engineering user 1','','','','','2014-05-23  00:00:00','ssssssss','eng_spv1','Engineer Supervisor 1','','','','','3' );
insert into report values ('175','qa','qa','2013-05-28','2','2014-05-23  00:00:00','dddddddddddd','qa','qa int user','','','','','','','','','','','','','2' );
insert into report values ('176','laboratory','qa','2013-05-28','2','2014-05-23  00:00:00','hhhhhhhhhhhhh','qa','qa int user','','','','','','','','','','','','','2' );
insert into report values ('177','equipment','qa','2013-05-28','2','2014-05-23  00:00:00','ddddddddd','qa','qa int user','','','','','','','','','','','','','2' );
insert into report values ('178','equipment','qa','2013-05-28','2','2014-05-23  00:00:00','fffffffffffffffff','qa','qa int user','','','','','','','','','','','','','2' );
insert into report values ('179','qa','qa','2013-05-29','2','2014-06-06','rrrrrr','qa','qa int user','','','','','','','','','','','','','2' );
insert into report values ('180','qa','qa','2013-05-01','2','2014-06-06','ee','qa','qa int user','','','','','','','','','','','','','2' );
insert into report values ('161','laboratory','qa','2013-10-01 00:00:00','2','2014-05-23  00:00:00','ssssssss','qa','qa int user','','','','','2014-05-23  00:00:00','sssssssss','eng_spv1','Engineer Supervisor 1','','','','','3' );

DROP TABLE IF EXISTS REPORT_NEW;
CREATE TABLE REPORT_NEW ( id int(10) NOT NULL auto_increment,unit varchar(20) NOT NULL,dept varchar(20) NOT NULL,date date NOT NULL,status int(10) NOT NULL,submit_date datetime NOT NULL,update_date datetime,progress int(10) NOT NULL, PRIMARY KEY (id) ); 

insert into REPORT_NEW values ('159','ahu1','eng','2013-10-01 00:00:00','2','2014-10-27 00:00:00','2014-11-04','4' );
insert into REPORT_NEW values ('129','ahu1','eng','2013-10-02 00:00:00','2','2014-05-02','','4' );
insert into REPORT_NEW values ('150','ahu1','eng','2013-05-28','2','2014-05-05','2014-11-04','0' );
insert into REPORT_NEW values ('158','ahu1','eng','2013-05-28','1','2014-05-23  00:00:00','','0' );
insert into REPORT_NEW values ('160','ahu2','eng','2013-10-01 00:00:00','1','2014-11-02','','2' );
insert into REPORT_NEW values ('161','ahu2','eng','2013-10-02 00:00:00','2','2014-11-02','','2' );
insert into REPORT_NEW values ('162','wfi','eng','2013-10-01 00:00:00','2','2014-11-04','2015-04-17','2' );
insert into REPORT_NEW values ('163','sterile','eng','1900-01-01','0','2015-07-08','','1' );
insert into REPORT_NEW values ('164','sterile','eng','1900-01-01','0','2015-07-08','','1' );

DROP TABLE IF EXISTS REPORT_NEW2;
CREATE TABLE REPORT_NEW2 ( id int(10) NOT NULL auto_increment,unit varchar(20),dept varchar(20),date date,status int(10),submit_date datetime,progress int(10), PRIMARY KEY (id) ); 

insert into REPORT_NEW2 values ('129','ahu2','eng','2013-10-02 00:00:00','2','2014-05-02','4' );
insert into REPORT_NEW2 values ('150','wfi','eng','2013-10-01 00:00:00','2','2014-05-05','2' );
insert into REPORT_NEW2 values ('158','wpu','eng','2013-05-02','2','2014-05-23  00:00:00','3' );
insert into REPORT_NEW2 values ('186','ahu1','eng','2013-10-01 00:00:00','2','2014-10-27 00:00:00','2' );

DROP TABLE IF EXISTS report_old;
CREATE TABLE report_old ( id int(10) NOT NULL auto_increment,unit varchar(5),dept varchar(20),date date,status int(10),submit_date_int datetime,note_int varchar(255),sign_int varchar(30),sign_int_full varchar(30),submit_date_spv_int datetime,note_spv_int varchar(255),sign_spv_int varchar(30),sign_spv_int_full varchar(30),submit_date_spv_eng datetime,note_spv_eng varchar(255),sign_spv_eng varchar(30),sign_spv_eng_full varchar(30),submit_date_spv_qa datetime,note_spv_qa varchar(255),sign_spv_qa varchar(30),sign_spv_qa_full varchar(30),progress int(10), PRIMARY KEY (id) ); 

insert into report_old values ('48','ahu1','eng','2013-05-07','2','2013-05-21','test dev 7','eng','engineering user 1','','','','','','','','','','','','','2' );
insert into report_old values ('31','ahu1','eng','2013-05-01','2','2013-05-21','test dev1','eng','engineering user 1','','','','','2013-05-21','ok dev1','eng_spv1','Engineer Supervisor 1','2013-05-21','ok finish1','qa_spv1','Quality Assurance Supervisor 1','4' );
insert into report_old values ('32','ahu1','eng','2013-05-02','2','2013-05-21','test dev2','eng','engineering user 1','','','','','2013-05-21','ok dev2','eng_spv1','Engineer Supervisor 1','','','','','3' );
insert into report_old values ('33','ahu1','eng','2013-05-03','2','2013-05-21','test dev normal1','eng','engineering user 1','','','','','','','','','','','','','2' );
insert into report_old values ('34','ahu1','eng','2013-05-04','2','2013-05-21','test dev normal2','eng','engineering user 1','','','','','','','','','','','','','2' );
insert into report_old values ('35','ahu1','eng','2013-05-05','1','2013-05-21','No deviasi','eng','engineering user 1','','','','','','','','','','','','','9' );
insert into report_old values ('36','ahu1','eng','2013-05-06','1','2013-05-21','No deviasi','eng','engineering user 1','','','','','','','','','','','','','9' );

DROP TABLE IF EXISTS tagname;
CREATE TABLE tagname ( id int(10) NOT NULL auto_increment,tagname varchar(100),area varchar(100),report varchar(100), PRIMARY KEY (id) ); 

insert into tagname values ('1','XP-SP3.Simulation00001','eng','ahu1' );
insert into tagname values ('2','ASPJAKWR809PGZ.HRN;Horner;mbnet.horner.141-126_in4','prod','sterile' );
insert into tagname values ('3','ASPJAKWR809PGZ.HRN;Horner;mbnet.horner.r126_in3','prod','sterile' );
insert into tagname values ('4','ASPJAKWR809PGZ.HRN;Horner;mbnet.horner.r141_in2','prod','sterile' );
insert into tagname values ('6','SAMPLE.IFIX1_BATCH_BULKFLOW.B_CUALM','wh','' );


CREATE TABLE userlist ( id int(10) NOT NULL auto_increment,username varchar(20) NOT NULL,password varchar(10),fullname varchar(40) NOT NULL,email varchar(50) NOT NULL,dept varchar(10) NOT NULL,position varchar(20) NOT NULL,sign varchar(30),status numeric(3) NOT NULL,spv1 varchar(30),spv2 varchar(30),admin numeric(3) NOT NULL,engineering numeric(3) NOT NULL,warehouse numeric(3) NOT NULL,retained_sample numeric(3) NOT NULL,production numeric(3) NOT NULL, PRIMARY KEY (id) ); 

insert into userlist values ('1','admin','123','administrator BAS','adm@adm.com','eng','admin','48.jpg','1','','','1','1','1','1','1' );
insert into userlist values ('2','eng','123','engineering user 1','engineering@engineering','eng','int','eng.jpg','1','eng_spv1','eng_spv2','0','1','0','0','0' );
insert into userlist values ('3','sterile1','123','sterile int','Sterile@Sterile','sterile','int','','1','sterile_spv1','','0','0','0','0','0' );
insert into userlist values ('4','dry_core1','123','Dry Core user','DryCore@DryCore','pro','int','','1','','','0','0','0','0','1' );
insert into userlist values ('5','goods1','123','qoods int','Finished Goods@Finished Goods','goods','int','','1','goods_spv1','','0','0','0','0','0' );
insert into userlist values ('6','wh','123','Warehouse Area','Warehouse@Warehouse','wh','int','wh.jpg','1','','','0','0','1','0','0' );
insert into userlist values ('7','qa','123','qa int user','qa@qa','qa','int','','1','qa_spv1','','0','0','0','1','0' );
insert into userlist values ('8','sup_adm','123','Super Administrator','super@admin','','admin','','1','','','1','1','1','1','0' );
insert into userlist values ('9','eng_spv1','123','Engineer Supervisor 1','Engineer@Supervisor 1','eng','spv','eng_spv1.jpg','1','','','0','1','0','0','0' );
insert into userlist values ('10','eng_spv2','123','Engineer Supervisor 2','Engineer@Supervisor 2','eng','spv','','1','','','0','1','0','0','0' );
insert into userlist values ('11','eng2','','engineering2','engineering2@engineering','eng','int','','1','eng_spv1','admin','0','1','0','0','0' );
insert into userlist values ('12','dry_spv1','123','Drycore Supervisor 1','Drycore @Production','pro','spv','dry_spv1.jpg','1','','','0','0','0','0','1' );
insert into userlist values ('13','wh_spv1','123','Warehouse Supervisor 1','Warehouse@Supervisor1','wh','spv','wh_spv1.jpg','1','','','0','0','1','0','0' );
insert into userlist values ('14','qa_spv1','123','Quality Assurance Supervisor 1','qa@assurance','qa','spv','qa_spv1.jpg','1','','','0','0','0','1','0' );
insert into userlist values ('15','sterile_spv1','123','Sterile Supervisor','sterile@spv1','pro','spv','sterile_spv1.jpg','0','','','0','0','0','0','0' );
insert into userlist values ('16','goods_spv1','123','Goods Supervisor','Goods@Supervisor','goods','spv','goods_spv1.jpg','1','','','0','0','0','0','0' );
insert into userlist values ('17','dry_spv2','','Drycore Supervisor 2','Drycore@Supervisor2','drycore','spv','','0','','','0','0','0','0','0' );
insert into userlist values ('18','9','9','9','9','9','9','9','9','9','9','1','0','0','0','0' );
insert into userlist values ('19','x','','x','x','eng','int','','1','eng_spv1','','0','1','0','0','0' );
insert into userlist values ('20','xx','','xx1','xx','pro','admin','xx.jpg','0','','','0','1','1','1','1' );
insert into userlist values ('21','qa_spv2','','qa spv2','qa_spv2@qa','qa','spv','','1','','','0','0','0','1','0' );
insert into userlist values ('22','qa_spv3','','qa_spv3','qa_spv3@qa','qa','spv','','1','','','0','0','0','1','0' );
CREATE TABLE userlog ( username varchar(255) NOT NULL,stamp datetime NOT NULL,eventlog varchar(255) NOT NULL ); 

DROP TABLE IF EXISTS SAMPLING_DATA_YEARS; 
CREATE TABLE SAMPLING_DATA_YEARS ( Column_0 varchar(50),Column_1 varchar(50),Column_2 varchar(50) ); 

insert into SAMPLING_DATA_YEARS values ('2011-01-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2011-02-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2011-03-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2011-04-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2011-05-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2011-06-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2011-07-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2011-08-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2011-09-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2011-10-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2011-11-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2011-12-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2012-01-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2012-02-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2012-03-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2012-04-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2012-05-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2012-06-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2012-07-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2012-08-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2012-09-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2012-10-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2012-11-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2012-12-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2013-01-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2013-02-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2013-02-28 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2013-03-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2013-04-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2013-05-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2013-06-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2013-07-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2013-08-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2013-09-01 00:00:00','12292.00','-10617.00' );
insert into SAMPLING_DATA_YEARS values ('2013-10-01 00:00:00','12292.00','-10617.00' );

DROP TABLE IF EXISTS tagname_pfi;
CREATE TABLE tagname_pfi ( tagname varchar(255),area varchar(255),report varchar(255) ); 

insert into tagname_pfi values ('ASPJAKWR809PGZ.YokogawaDX2020.CH1.PV.CH16','eng','demi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.YokogawaDX2020.CH1.PV.CH17','eng','demi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.YokogawaDX2020.CH1.PV.CH18','eng','demi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.YokogawaDX2020.CH1.PV.CH19','eng','demi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.YokogawaDX2020.CH1.PV.CH20','eng','demi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.STILMAS.WFI.P-LT10_1','eng','wpu' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.STILMAS.WFI.P-TE10_1','eng','wpu' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.STILMAS.WFI.P-TE10_2','eng','wpu' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.STILMAS.WFI.P-TE10_5','eng','wpu' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.YokogawaDX2020.CH1.PV.CH12','eng','wpu' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.STILMAS.WFI.P-PT10_1','eng','wpu' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.STILMAS.WFI.W-TE012','eng','wfi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.STILMAS.WFI.W-LE015','eng','wfi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.STILMAS.WFI.W-TE015_1','eng','wfi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.YokogawaDX2020.CH1.PV.CH07','eng','wfi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.STILMAS.WFI.W-TE015_5','eng','wfi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.YokogawaDX2020.CH1.PV.CH10','eng','wfi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.YokogawaDX2020.CH1.PV.CH11','eng','wfi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.YokogawaDX2020.CH1.PV.CH08','eng','wfi' );
insert into tagname_pfi values ('ASPJAKWR809PGZ.STILMAS.WFI.W-PT020','eng','wfi' );
insert into tagname_pfi values ('Fix32.ACS1.AHU14A_SUPPLYAIR.F_CV','eng','ahu1' );
insert into tagname_pfi values ('Fix32.ACS1.AHU14A_FLOW.F_CV','eng','ahu1' );
insert into tagname_pfi values ('Fix32.ACS1.AHU14A_SUPPLYAIR.F_CV','eng','ahu1' );
insert into tagname_pfi values ('Fix32.ACS1.AHU14B_FLOW.F_CV','eng','ahu1' );
insert into tagname_pfi values ('Fix32.ACS1.AHU16_SUPPLYAIR.F_CV','eng','ahu1' );
insert into tagname_pfi values ('Fix32.ACS1.AHU16_HUMIDITY.F_CV','eng','ahu1' );
insert into tagname_pfi values ('Fix32.ACS1.AHU16_FLOW.F_CV','eng','ahu1' );
insert into tagname_pfi values ('Fix32.ACS1.AHU17_SUPPLYAIR.F_CV','eng','ahu1' );
insert into tagname_pfi values ('Fix32.ACS1.AHU94_SUPPLYAIR.F_CV','eng','ahu1' );
insert into tagname_pfi values ('Fix32.ACS1.AHU94_HUMIDITY.F_CV','eng','ahu1' );
insert into tagname_pfi values ('Fix32.ACS1.AHU94_FLOW.F_CV','eng','ahu1' );
insert into tagname_pfi values ('Fix32.ACS1.AHU24_1_SUPPLYAIR.F_CV','eng','ahu2' );
insert into tagname_pfi values ('Fix32.ACS1.AHU24_1_FLOW.F_CV','eng','ahu2' );
insert into tagname_pfi values ('Fix32.ACS1.AHU24_2_SUPPLYAIR.F_CV','eng','ahu2' );
insert into tagname_pfi values ('Fix32.ACS1.AHU24_2_HUMIDITY.F_CV','eng','ahu2' );
insert into tagname_pfi values ('Fix32.ACS1.AHU24_2_FLOW.F_CV','eng','ahu2' );
insert into tagname_pfi values ('Fix32.ACS1.AHU25_SUPPLYAIR.F_CV','eng','ahu2' );
insert into tagname_pfi values ('Fix32.ACS1.AHU25_FLOW.F_CV','eng','ahu2' );
insert into tagname_pfi values ('Fix32.ACS1.AHU28_SUPPLYAIR.F_CV','eng','ahu2' );
insert into tagname_pfi values ('Fix32.ACS1.AHU28_FLOW.F_CV','eng','ahu2' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM158_TEMP.F_CV','prod','drycore' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM158_HUMIDITY.F_CV','prod','drycore' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM160_TEMP.F_CV','prod','drycore' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM160_HUMIDITY.F_CV','prod','drycore' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM_WIP_TEMP.F_CV','prod','drycore' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM_WIP_RH.F_CV','prod','drycore' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM_311_TEMP.F_CV','prod','drycore' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM_311_RH.F_CV','prod','drycore' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM_321_TEMP.F_CV','prod','drycore' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM314_WIP_TEMP.F_CV','prod','drycore' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM140_TEMP.F_CV','prod','sterile' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM140_HUMIDITY.F_CV','prod','sterile' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM125_PRESSURE.F_CV','prod','sterile' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM126_PRESSURE.F_CV','prod','sterile' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM127_PRESSURE.F_CV','prod','sterile' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM128_PRESSURE.F_CV','prod','sterile' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM140_PRESSURE.F_CV','prod','sterile' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM141_PRESSURE.F_CV','prod','sterile' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM145_PRESSURE.F_CV','prod','sterile' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM129-148_PRESSURE.F_CV','prod','sterile' );
insert into tagname_pfi values ('Fix32.ACS1.FIN_GOOD_X1.F_CV','prod','goods' );
insert into tagname_pfi values ('Fix32.ACS1.FIN_GOOD_X2.F_CV','prod','goods' );
insert into tagname_pfi values ('Fix32.ACS1.FIN_GOOD_X3.F_CV','prod','goods' );
insert into tagname_pfi values ('Fix32.ACS1.FIN_GOOD_X4.F_CV','prod','goods' );
insert into tagname_pfi values ('Fix32.ACS1.FIN_GOOD_X5.F_CV','prod','goods' );
insert into tagname_pfi values ('Fix32.ACS1.FIN_GOOD_X6.F_CV','prod','goods' );
insert into tagname_pfi values ('Fix32.ACS1.FIN_GOOD_X7.F_CV','prod','goods' );
insert into tagname_pfi values ('Fix32.ACS1.RM_WAREHOUSE_X1.F_CV','wh','wh' );
insert into tagname_pfi values ('Fix32.ACS1.RM_WAREHOUSE_X2.F_CV','wh','wh' );
insert into tagname_pfi values ('Fix32.ACS1.RM_WAREHOUSE_X3.F_CV','wh','wh' );
insert into tagname_pfi values ('Fix32.ACS1.RM_WAREHOUSE_X4.F_CV','wh','wh' );
insert into tagname_pfi values ('Fix32.ACS1.RM_WAREHOUSE_X5.F_CV','wh','wh' );
insert into tagname_pfi values ('Fix32.ACS1.RM_WAREHOUSE_X6.F_CV','wh','wh' );
insert into tagname_pfi values ('Fix32.ACS1.COLDBOX_TEMP.F_CV','wh','wh' );
insert into tagname_pfi values ('Fix32.ACS1.FLAMMABLE_TEMP.F_CV','wh','wh' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM133_TEMP.F_CV','wh','wh' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM133_RH.F_CV','wh','wh' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM328_TEMP.F_CV','wh','wh' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM328_RH.F_CV','wh','wh' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM182A_TEMP.F_CV','qa','retained' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM183A_TEMP.F_CV','qa','retained' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM183B_TEMP.F_CV','qa','retained' );
insert into tagname_pfi values ('Fix32.ACS1.SYSTEM_FLOW.F_CV','qa','retained' );
insert into tagname_pfi values ('Fix32.ACS1.SAMPLING_BOOTH_MAT_AIR_LOCK.F_CV','qa','retained' );
insert into tagname_pfi values ('Fix32.ACS1.SAMPLING_BOOTH_GOWNING.F_CV','qa','retained' );
insert into tagname_pfi values ('Fix32.ACS1.REFRIGERATOR1_TEMP.F_CV','qa','equip' );
insert into tagname_pfi values ('Fix32.ACS1.REFRIGERATOR2_TEMP.F_CV','qa','equip' );
insert into tagname_pfi values ('Fix32.ACS1.REFRIGERATOR3_TEMP.F_CV','qa','equip' );
insert into tagname_pfi values ('Fix32.ACS1.REFRIGERATOR4_TEMP.F_CV','qa','equip' );
insert into tagname_pfi values ('Fix32.ACS1.REFRIGERATOR5_TEMP.F_CV','qa','equip' );
insert into tagname_pfi values ('Fix32.ACS1.INCUBATOR1_TEMP.F_CV','qa','equip' );
insert into tagname_pfi values ('Fix32.ACS1.INCUBATOR2_TEMP.F_CV','qa','equip' );
insert into tagname_pfi values ('Fix32.ACS1.INCUBATOR3_TEMP.F_CV','qa','equip' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM210_TEMP.F_CV','qa','lab' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM212_TEMP.F_CV','qa','lab' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM213_TEMP.F_CV','qa','lab' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM253_TEMP.F_CV','qa','lab' );
insert into tagname_pfi values ('Fix32.ACS1.ROOM257_TEMP.F_CV','qa','lab' );
insert into tagname_pfi values ('XP-SP3.Simulation00001','test','' );
insert into tagname_pfi values ('SAMPLE.IFIX1_BATCH_BULKFLOW.B_CUALM','test','' );
insert into tagname_pfi values ('SAMPLE.IFIX1_BATCH_BULKFLOW.F_CV','test','' );
insert into tagname_pfi values ('SAMPLE.IFIX1_BATCH_BULKLEVEL.B_CUALM','test','' );


CREATE TABLE TAGS_DATA_DISTRIBUTION ( tanggal datetime NOT NULL,Simulation00001 decimal(10),IFIX1_BATCH_BULKFLOW decimal(10) ); 
insert into TAGS_DATA_DISTRIBUTION values ('2013-05-28 00:00:00','12292.00','-10617.00' );


CREATE TABLE TAGS_DATA2014 ( tanggal datetime NOT NULL,Simulation00001 decimal(10),IFIX1_BATCH_BULKFLOW decimal(10),test decimal(10) ); 
insert into TAGS_DATA2014 values ('2014-01-01 00:00:00','12292.00','-10617.00','' );
insert into TAGS_DATA2014 values ('2014-01-01 00:30:00','12292.00','-10617.00','' );

CREATE TABLE TAGS_DATA2013 ( tanggal datetime NOT NULL,Simulation00001 decimal(10),IFIX1_BATCH_BULKFLOW decimal(10),test decimal(10) ); 
insert into TAGS_DATA2013 values ('2013-01-01 00:00:00','12292.00','-10617.00','' );
insert into TAGS_DATA2013 values ('2013-01-01 00:30:00','12292.00','-10617.00','' );
