
create index EVIDENCEENCE_SENTENCE_S on EVIDENCE(SENTENCE_SUBSTR) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EVIDENCEENCE_SENTENCE_S on EVIDENCE(SENTENCE_STATUS) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EVIDENCEENCE_COMMENTS on EVIDENCE(COMMENTS) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EVIDENCEENCE_CELLLINE_S on EVIDENCE(CELLLINE_STATUS) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EVIDENCEENCE_NEGATION_S on EVIDENCE(NEGATION_STATUS) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EVIDENCEENCE_PUBMED_ID on EVIDENCE(PUBMED_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EVIDENCEENCE_ID on EVIDENCE(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
