/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table GENE_PROTEIN_TV disable constraint SYS_C004486;
alter table GENE_PROTEIN_TV disable constraint SYS_C004487;

alter table GENE_PROTEIN_TV disable primary key;

--EXIT;
