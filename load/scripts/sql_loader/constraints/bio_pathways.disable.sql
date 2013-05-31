/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table BIO_PATHWAYS disable constraint SYS_C004313;
alter table BIO_PATHWAYS disable constraint SYS_C004314;
alter table BIO_PATHWAYS disable constraint SYS_C004316;

alter table BIO_PATHWAYS disable primary key;

--EXIT;
