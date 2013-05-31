/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PID_ENTITEIN_GENE_ID on PID_ENTITY_PROTEIN(GENE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PID_ENTITEIN_PROTEIN_ID on PID_ENTITY_PROTEIN(PROTEIN_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PID_ENTITEIN_PHYSICAL_E on PID_ENTITY_PROTEIN(PHYSICAL_ENTITY_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
