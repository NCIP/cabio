/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table BIO_PATHWAYS_TV disable constraint SYS_C0016533;
alter table BIO_PATHWAYS_TV disable constraint PATHWAYS_UNIQ;
alter table BIO_PATHWAYS_TV disable constraint SYS_C004318;
alter table BIO_PATHWAYS_TV disable constraint SYS_C004319;
alter table BIO_PATHWAYS_TV disable constraint SYS_C004320;
alter table BIO_PATHWAYS_TV disable constraint SYS_C004321;
alter table BIO_PATHWAYS_TV disable constraint BPTBIGID;

alter table BIO_PATHWAYS_TV disable primary key;

--EXIT;
