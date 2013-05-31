/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index TRANSCRIRTER_MICROARRAY on TRANSCRIPT_ARRAY_REPORTER(MICROARRAY_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index TRANSCRIRTER_NAME on TRANSCRIPT_ARRAY_REPORTER(NAME) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index TRANSCRIRTER_ID on TRANSCRIPT_ARRAY_REPORTER(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
