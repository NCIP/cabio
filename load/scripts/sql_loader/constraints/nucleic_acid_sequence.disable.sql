/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table NUCLEIC_ACID_SEQUENCE disable constraint SYS_C004613;
alter table NUCLEIC_ACID_SEQUENCE disable constraint SYS_C004614;
alter table NUCLEIC_ACID_SEQUENCE disable constraint SYS_C004615;
alter table NUCLEIC_ACID_SEQUENCE disable constraint SYS_C004616;
alter table NUCLEIC_ACID_SEQUENCE disable constraint SYS_C004617;
alter table NUCLEIC_ACID_SEQUENCE disable constraint SYS_C004618;
alter table NUCLEIC_ACID_SEQUENCE disable constraint SYS_C004619;
alter table NUCLEIC_ACID_SEQUENCE disable constraint SYS_C004620;
alter table NUCLEIC_ACID_SEQUENCE disable constraint NASBIGID;
alter table NUCLEIC_ACID_SEQUENCE disable constraint NASNODUPS;

alter table NUCLEIC_ACID_SEQUENCE disable primary key;

--EXIT;
