/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index URL_SOURENCE_SOURCE_URL_lwr on URL_SOURCE_REFERENCE(lower(SOURCE_URL)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index URL_SOURENCE_SOURCE_REF_lwr on URL_SOURCE_REFERENCE(lower(SOURCE_REFERENCE_TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
