/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ANOMALYMALY_ANOMALY_TY_lwr on ANOMALY(lower(ANOMALY_TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
