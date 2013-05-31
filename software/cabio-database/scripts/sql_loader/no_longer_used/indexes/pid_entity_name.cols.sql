/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PID_ENTINAME_PID_PHYSIC on PID_ENTITY_NAME(PID_PHYSICALENTITY_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PID_ENTINAME_NAME on PID_ENTITY_NAME(NAME) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PID_ENTINAME_ID on PID_ENTITY_NAME(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
