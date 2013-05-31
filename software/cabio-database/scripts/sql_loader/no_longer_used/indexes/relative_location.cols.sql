/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index RELATIVETION_SNP_ID on RELATIVE_LOCATION(SNP_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index RELATIVETION_DISTANCE on RELATIVE_LOCATION(DISTANCE) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index RELATIVETION_ORIENTATIO on RELATIVE_LOCATION(ORIENTATION) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index RELATIVETION_ID on RELATIVE_LOCATION(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
