/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_GENKERS_MARKER_ID_lwr on ZSTG_GENE_MARKERS(lower(MARKER_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
