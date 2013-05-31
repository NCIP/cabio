/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENERIC_RTER_CLUSTER_ID_lwr on GENERIC_REPORTER(lower(CLUSTER_ID)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENERIC_RTER_TYPE_lwr on GENERIC_REPORTER(lower(TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENERIC_RTER_NAME_lwr on GENERIC_REPORTER(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
