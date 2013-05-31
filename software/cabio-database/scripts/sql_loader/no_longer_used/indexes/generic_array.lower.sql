/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENERIC_RRAY_TYPE_lwr on GENERIC_ARRAY(lower(TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENERIC_RRAY_PLATFORM_lwr on GENERIC_ARRAY(lower(PLATFORM)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENERIC_RRAY_ARRAY_NAME_lwr on GENERIC_ARRAY(lower(ARRAY_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
