/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index SOURCE_RENCE_SOURCE_REF on SOURCE_REFERENCE(SOURCE_REFERENCE_TYPE) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index SOURCE_RENCE_SOURCE_REF on SOURCE_REFERENCE(SOURCE_REFERENCE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
