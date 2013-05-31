/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table GENE_TV disable constraint SYS_C0021105;
alter table GENE_TV disable constraint SYS_C004500;
alter table GENE_TV disable constraint SYS_C004501;
alter table GENE_TV disable constraint SYS_C004503;
alter table GENE_TV disable constraint SYS_C004504;
alter table GENE_TV disable constraint GTVBIGID;

alter table GENE_TV disable primary key;

--EXIT;
