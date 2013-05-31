/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index RELATIVETION_DISTANCE_lwr on RELATIVE_LOCATION(lower(DISTANCE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index RELATIVETION_ORIENTATIO_lwr on RELATIVE_LOCATION(lower(ORIENTATION)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
