/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index EVIDENCEENCE_SENTENCE_S_lwr on EVIDENCE(lower(SENTENCE_SUBSTR)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EVIDENCEENCE_SENTENCE_S_lwr on EVIDENCE(lower(SENTENCE_STATUS)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EVIDENCEENCE_COMMENTS_lwr on EVIDENCE(lower(COMMENTS)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EVIDENCEENCE_CELLLINE_S_lwr on EVIDENCE(lower(CELLLINE_STATUS)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EVIDENCEENCE_NEGATION_S_lwr on EVIDENCE(lower(NEGATION_STATUS)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
