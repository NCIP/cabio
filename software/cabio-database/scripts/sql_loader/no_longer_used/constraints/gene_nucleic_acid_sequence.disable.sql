/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table GENE_NUCLEIC_ACID_SEQUENCE disable constraint SYS_C004480;
alter table GENE_NUCLEIC_ACID_SEQUENCE disable constraint SYS_C004481;

alter table GENE_NUCLEIC_ACID_SEQUENCE disable primary key;

--EXIT;
