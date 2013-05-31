/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table GENE_GENEALIAS disable constraint SYS_C0016566;
alter table GENE_GENEALIAS disable constraint SYS_C004470;

alter table GENE_GENEALIAS disable primary key;

--EXIT;
