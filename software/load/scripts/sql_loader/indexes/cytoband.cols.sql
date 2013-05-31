/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index CYTOBANDBAND_CHROMOSOME on CYTOBAND(CHROMOSOME_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index CYTOBANDBAND_PHYSICAL_L on CYTOBAND(PHYSICAL_LOCATION_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index CYTOBANDBAND_NAME on CYTOBAND(NAME) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index CYTOBANDBAND_ID on CYTOBAND(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
