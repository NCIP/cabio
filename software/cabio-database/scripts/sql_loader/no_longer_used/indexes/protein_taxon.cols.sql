/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PROTEIN_AXON_TAXON_ID on PROTEIN_TAXON(TAXON_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PROTEIN_AXON_PROTEIN_ID on PROTEIN_TAXON(PROTEIN_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
