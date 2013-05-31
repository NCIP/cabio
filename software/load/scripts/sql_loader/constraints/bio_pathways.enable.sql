/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index PATHPK_idx on BIO_PATHWAYS
(PATHWAY_ID) tablespace CABIO_FUT;
alter table BIO_PATHWAYS enable constraint PATHPK using index PATHPK_idx;

alter table BIO_PATHWAYS enable constraint SYS_C004313;
alter table BIO_PATHWAYS enable constraint SYS_C004314;
alter table BIO_PATHWAYS enable constraint SYS_C004315;
alter table BIO_PATHWAYS enable constraint SYS_C004316;
alter table BIO_PATHWAYS enable constraint PATHPK;

alter table BIO_PATHWAYS enable primary key;

--EXIT;
