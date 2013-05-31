/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index NEW_LOCATION_DISCRIMINATO_lwr on NEW_LOCATION_TV_BK(lower(DISCRIMINATOR)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
