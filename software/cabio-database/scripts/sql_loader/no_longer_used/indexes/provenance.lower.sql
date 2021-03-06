/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PROVENANANCE_OBJECT_IDE_lwr on PROVENANCE(lower(OBJECT_IDENTIFIER)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PROVENANANCE_FULLY_QUAL_lwr on PROVENANCE(lower(FULLY_QUALIFIED_CLASS_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PROVENANANCE_EVIDENCE_C_lwr on PROVENANCE(lower(EVIDENCE_CODE)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
