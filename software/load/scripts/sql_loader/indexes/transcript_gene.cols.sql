/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index TRANSCRIGENE_GENE_ID on TRANSCRIPT_GENE(GENE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index TRANSCRIGENE_TRANSCRIPT on TRANSCRIPT_GENE(TRANSCRIPT_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
