/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table CGAP_GENE_ALIAS disable constraint SYS_C004325;
alter table CGAP_GENE_ALIAS disable constraint SYS_C004326;

alter table CGAP_GENE_ALIAS disable primary key;

--EXIT;
