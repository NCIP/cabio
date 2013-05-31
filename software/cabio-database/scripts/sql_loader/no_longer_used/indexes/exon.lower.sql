/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index EXONEXON_SOURCE_lwr on EXON(lower(SOURCE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index EXONEXON_MANUFACTUR_lwr on EXON(lower(MANUFACTURER_ID)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
