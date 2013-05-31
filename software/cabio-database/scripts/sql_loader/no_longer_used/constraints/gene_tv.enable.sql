/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021105_idx on GENE_TV
(HUGO_SYMBOL,ENGINEEREDGENE_ID,TAXON_ID,CHROMOSOME_ID,CLUSTER_ID,SYMBOL,FULL_NAME,GENE_ID) tablespace CABIO_FUT;
alter table GENE_TV enable constraint SYS_C0021105 using index SYS_C0021105_idx;
create unique index GTV_PK_idx on GENE_TV
(GENE_ID) tablespace CABIO_FUT;
alter table GENE_TV enable constraint GTV_PK using index GTV_PK_idx;

alter table GENE_TV enable constraint SYS_C0021105;
alter table GENE_TV enable constraint SYS_C0021105;
alter table GENE_TV enable constraint SYS_C0021105;
alter table GENE_TV enable constraint SYS_C0021105;
alter table GENE_TV enable constraint SYS_C0021105;
alter table GENE_TV enable constraint SYS_C0021105;
alter table GENE_TV enable constraint SYS_C0021105;
alter table GENE_TV enable constraint SYS_C0021105;
alter table GENE_TV enable constraint SYS_C004500;
alter table GENE_TV enable constraint SYS_C004501;
alter table GENE_TV enable constraint SYS_C004503;
alter table GENE_TV enable constraint SYS_C004504;
alter table GENE_TV enable constraint GTV_PK;

alter table GENE_TV enable primary key;

--EXIT;
