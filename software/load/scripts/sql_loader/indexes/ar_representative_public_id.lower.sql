/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index AR_REPREC_ID_GENECHIP_A_lwr on AR_REPRESENTATIVE_PUBLIC_ID(lower(GENECHIP_ARRAY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_REPREC_ID_REPRESENTA_lwr on AR_REPRESENTATIVE_PUBLIC_ID(lower(REPRESENTATIVE_PUBLIC_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index AR_REPREC_ID_PROBE_SET__lwr on AR_REPRESENTATIVE_PUBLIC_ID(lower(PROBE_SET_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
