/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table HOMOLOGOUS_ASSOCIATION disable constraint HA_SP;
alter table HOMOLOGOUS_ASSOCIATION disable constraint SYS_C0021113;
alter table HOMOLOGOUS_ASSOCIATION disable constraint SYS_C004538;
alter table HOMOLOGOUS_ASSOCIATION disable constraint SYS_C004539;
alter table HOMOLOGOUS_ASSOCIATION disable constraint SYS_C004540;
alter table HOMOLOGOUS_ASSOCIATION disable constraint SYS_C004541;
alter table HOMOLOGOUS_ASSOCIATION disable constraint HABIGID;

alter table HOMOLOGOUS_ASSOCIATION disable primary key;

--EXIT;
