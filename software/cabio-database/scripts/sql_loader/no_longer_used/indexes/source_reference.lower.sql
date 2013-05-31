/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index SOURCE_RENCE_SOURCE_REF_lwr on SOURCE_REFERENCE(lower(SOURCE_REFERENCE_TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
