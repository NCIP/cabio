/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index DATABASEENCE_SUMMARY_lwr on DATABASE_CROSS_REFERENCE(lower(SUMMARY)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index DATABASEENCE_SOURCE_TYP_lwr on DATABASE_CROSS_REFERENCE(lower(SOURCE_TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index DATABASEENCE_CROSS_REFE_lwr on DATABASE_CROSS_REFERENCE(lower(CROSS_REFERENCE_ID)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index DATABASEENCE_SOURCE_NAM_lwr on DATABASE_CROSS_REFERENCE(lower(SOURCE_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index DATABASEENCE_TYPE_lwr on DATABASE_CROSS_REFERENCE(lower(TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
