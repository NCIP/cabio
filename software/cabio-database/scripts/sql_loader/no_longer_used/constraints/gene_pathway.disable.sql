/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table GENE_PATHWAY disable constraint SYS_C004483;
alter table GENE_PATHWAY disable constraint SYS_C004484;

alter table GENE_PATHWAY disable primary key;

--EXIT;
