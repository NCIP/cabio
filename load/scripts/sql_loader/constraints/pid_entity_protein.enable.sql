/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021151_idx on PID_ENTITY_PROTEIN
(GENE_ID,PROTEIN_ID,PHYSICAL_ENTITY_ID) tablespace CABIO_FUT;
alter table PID_ENTITY_PROTEIN enable constraint SYS_C0021151 using index SYS_C0021151_idx;
create unique index SYS_C0016502_idx on PID_ENTITY_PROTEIN
(PROTEIN_ID,PHYSICAL_ENTITY_ID) tablespace CABIO_FUT;
alter table PID_ENTITY_PROTEIN enable constraint SYS_C0016502 using index SYS_C0016502_idx;

alter table PID_ENTITY_PROTEIN enable constraint SYS_C0016474;
alter table PID_ENTITY_PROTEIN enable constraint SYS_C0016475;
alter table PID_ENTITY_PROTEIN enable constraint SYS_C0021151;
alter table PID_ENTITY_PROTEIN enable constraint SYS_C0021151;
alter table PID_ENTITY_PROTEIN enable constraint SYS_C0021151;
alter table PID_ENTITY_PROTEIN enable constraint SYS_C0016502;
alter table PID_ENTITY_PROTEIN enable constraint SYS_C0016502;

alter table PID_ENTITY_PROTEIN enable primary key;

--EXIT;
