/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index TARGETRGET_LOCUS_ID on TARGET(LOCUS_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index TARGETRGET_TARGET_NAM on TARGET(TARGET_NAME) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index TARGETRGET_TARGET_TYP on TARGET(TARGET_TYPE) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index TARGETRGET_TARGET_ID on TARGET(TARGET_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
