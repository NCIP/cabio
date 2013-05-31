/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENERIC_RTER_GENERIC_RE on GENERIC_ARRAY_GENERIC_REPORTER(GENERIC_REPORTER_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GENERIC_RTER_GENERIC_AR on GENERIC_ARRAY_GENERIC_REPORTER(GENERIC_ARRAY_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
