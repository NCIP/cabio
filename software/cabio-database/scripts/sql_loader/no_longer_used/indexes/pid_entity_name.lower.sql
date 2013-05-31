/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PID_ENTINAME_NAME_lwr on PID_ENTITY_NAME(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
