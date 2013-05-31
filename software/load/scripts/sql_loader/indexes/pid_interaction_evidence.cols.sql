/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PID_INTEENCE_EVIDENCE_I on PID_INTERACTION_EVIDENCE(EVIDENCE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PID_INTEENCE_INTERACTIO on PID_INTERACTION_EVIDENCE(INTERACTION_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
