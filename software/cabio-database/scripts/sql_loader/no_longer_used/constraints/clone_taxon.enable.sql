/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index PK_CLONE_TAXON_idx on CLONE_TAXON
(TAXON_ID,CLONE_ID) tablespace CABIO_FUT;
alter table CLONE_TAXON enable constraint PK_CLONE_TAXON using index PK_CLONE_TAXON_idx;

alter table CLONE_TAXON enable constraint SYS_C004341;
alter table CLONE_TAXON enable constraint SYS_C004342;
alter table CLONE_TAXON enable constraint PK_CLONE_TAXON;
alter table CLONE_TAXON enable constraint PK_CLONE_TAXON;

alter table CLONE_TAXON enable primary key;

--EXIT;
