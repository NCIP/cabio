/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index LOCATIONN_CH_ASSEMBLY_lwr on LOCATION_CH(lower(ASSEMBLY)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index LOCATIONN_CH_FEATURE_TY_lwr on LOCATION_CH(lower(FEATURE_TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index LOCATIONN_CH_DISCRIMINA_lwr on LOCATION_CH(lower(DISCRIMINATOR)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
