/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENERIC_RRAY_TYPE on GENERIC_ARRAY(TYPE) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENERIC_RRAY_PLATFORM on GENERIC_ARRAY(PLATFORM) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENERIC_RRAY_ARRAY_NAME on GENERIC_ARRAY(ARRAY_NAME) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENERIC_RRAY_ID on GENERIC_ARRAY(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
