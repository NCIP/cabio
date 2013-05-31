/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table SNP_REPORTER disable constraint SYS_C0021185;
alter table SNP_REPORTER disable constraint SYS_C004740;
alter table SNP_REPORTER disable constraint SYS_C004741;
alter table SNP_REPORTER disable constraint SYS_C004742;
alter table SNP_REPORTER disable constraint SNPREPBIGID;

alter table SNP_REPORTER disable primary key;

--EXIT;
