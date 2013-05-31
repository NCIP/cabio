/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table GENE_TARGET disable constraint SYS_C004497;
alter table GENE_TARGET disable constraint SYS_C004498;

alter table GENE_TARGET disable primary key;

--EXIT;
