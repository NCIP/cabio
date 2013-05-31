/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PID_INTEN_EC_EVIDENCE_C on PID_INTERACTION_EC(EVIDENCE_CODE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PID_INTEN_EC_INTERACTIO on PID_INTERACTION_EC(INTERACTION_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
