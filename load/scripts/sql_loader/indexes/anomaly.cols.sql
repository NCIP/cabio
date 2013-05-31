/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ANOMALYMALY_CONTEXT_CO on ANOMALY(CONTEXT_CODE) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index ANOMALYMALY_ANOMALY_TY on ANOMALY(ANOMALY_TYPE) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index ANOMALYMALY_TARGET_ID on ANOMALY(TARGET_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index ANOMALYMALY_ANOMALY_ID on ANOMALY(ANOMALY_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
