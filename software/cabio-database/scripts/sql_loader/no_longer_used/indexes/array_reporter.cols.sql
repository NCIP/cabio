/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ARRAY_RERTER_MICROARRAY on ARRAY_REPORTER(MICROARRAY_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index ARRAY_RERTER_NAME on ARRAY_REPORTER(NAME) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index ARRAY_RERTER_ID on ARRAY_REPORTER(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
