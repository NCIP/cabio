/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PID_LOC_LOCATION_lwr on ZSTG_PID_INTR_PARTPANT_LOC(lower(LOCATION)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
