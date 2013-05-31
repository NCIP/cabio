/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index EVIDENCECODE_EVIDENCE_C_lwr on EVIDENCE_CODE(lower(EVIDENCE_CODE)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
