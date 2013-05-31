/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SRPK_idx on SOURCE_REFERENCE
(SOURCE_REFERENCE_ID) tablespace CABIO_FUT;
alter table SOURCE_REFERENCE enable constraint SRPK using index SRPK_idx;

alter table SOURCE_REFERENCE enable constraint SYS_C004753;
alter table SOURCE_REFERENCE enable constraint SYS_C004754;
alter table SOURCE_REFERENCE enable constraint SYS_C004755;
alter table SOURCE_REFERENCE enable constraint SRPK;

alter table SOURCE_REFERENCE enable primary key;

--EXIT;
