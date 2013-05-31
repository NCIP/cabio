/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table GENE_RELATIVE_LOCATION disable constraint SYS_C0021104;
alter table GENE_RELATIVE_LOCATION disable constraint SYS_C004489;
alter table GENE_RELATIVE_LOCATION disable constraint SYS_C004490;
alter table GENE_RELATIVE_LOCATION disable constraint SYS_C004491;
alter table GENE_RELATIVE_LOCATION disable constraint SYS_C004492;
alter table GENE_RELATIVE_LOCATION disable constraint SYS_C004493;
alter table GENE_RELATIVE_LOCATION disable constraint SYS_C004494;

alter table GENE_RELATIVE_LOCATION disable primary key;

--EXIT;
