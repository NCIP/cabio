/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PID_PATHTION_INTERACTIO on PID_PATHWAY_INTERACTION(INTERACTION_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PID_PATHTION_PATHWAY_ID on PID_PATHWAY_INTERACTION(PATHWAY_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
