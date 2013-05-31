/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index PATHWAYS_UNIQ_idx on BIO_PATHWAYS_TV
(SOURCE,TAXON,PATHWAY_NAME) tablespace CABIO_FUT;
alter table BIO_PATHWAYS_TV enable constraint PATHWAYS_UNIQ using index PATHWAYS_UNIQ_idx;
create unique index PK_BIO_PATHWAYS_TV_idx on BIO_PATHWAYS_TV
(PATHWAY_ID) tablespace CABIO_FUT;
alter table BIO_PATHWAYS_TV enable constraint PK_BIO_PATHWAYS_TV using index PK_BIO_PATHWAYS_TV_idx;

alter table BIO_PATHWAYS_TV enable constraint SYS_C0016533;
alter table BIO_PATHWAYS_TV enable constraint PATHWAYS_UNIQ;
alter table BIO_PATHWAYS_TV enable constraint PATHWAYS_UNIQ;
alter table BIO_PATHWAYS_TV enable constraint PATHWAYS_UNIQ;
alter table BIO_PATHWAYS_TV enable constraint SYS_C004318;
alter table BIO_PATHWAYS_TV enable constraint SYS_C004319;
alter table BIO_PATHWAYS_TV enable constraint SYS_C004320;
alter table BIO_PATHWAYS_TV enable constraint SYS_C004321;
alter table BIO_PATHWAYS_TV enable constraint PK_BIO_PATHWAYS_TV;

alter table BIO_PATHWAYS_TV enable primary key;

--EXIT;
