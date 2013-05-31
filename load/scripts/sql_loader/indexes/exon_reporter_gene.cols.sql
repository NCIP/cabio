/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index EXON_REPGENE_GENE_ID on EXON_REPORTER_GENE(GENE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EXON_REPGENE_EXON_REPOR on EXON_REPORTER_GENE(EXON_REPORTER_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
