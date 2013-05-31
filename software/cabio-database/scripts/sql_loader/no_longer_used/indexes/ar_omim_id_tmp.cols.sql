/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_OMIM__TMP_GENECHIP_A on AR_OMIM_ID_TMP(GENECHIP_ARRAY) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_OMIM__TMP_OMIM_ID on AR_OMIM_ID_TMP(OMIM_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_OMIM__TMP_PROBE_SET_ on AR_OMIM_ID_TMP(PROBE_SET_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
