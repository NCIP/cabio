/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table GO_ONTOLOGY disable constraint SYS_C0021108;
alter table GO_ONTOLOGY disable constraint SYS_C004512;
alter table GO_ONTOLOGY disable constraint SYS_C004513;
alter table GO_ONTOLOGY disable constraint SYS_C004514;
alter table GO_ONTOLOGY disable constraint GOOBIGID;
alter table GO_ONTOLOGY disable constraint GONODUPS;

alter table GO_ONTOLOGY disable primary key;

--EXIT;
