/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENE_HISLOGY_CONTEXT_CO on GENE_HISTOPATHOLOGY(CONTEXT_CODE) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENE_HISLOGY_GENE_ID on GENE_HISTOPATHOLOGY(GENE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
