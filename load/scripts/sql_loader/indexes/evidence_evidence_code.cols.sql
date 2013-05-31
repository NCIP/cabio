/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index EVIDENCECODE_EVIDENCE_C on EVIDENCE_EVIDENCE_CODE(EVIDENCE_CODE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EVIDENCECODE_EVIDENCE_I on EVIDENCE_EVIDENCE_CODE(EVIDENCE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
