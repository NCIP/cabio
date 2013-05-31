/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index CLONE_TAAXON_TAXON_ID on CLONE_TAXON(TAXON_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index CLONE_TAAXON_CLONE_ID on CLONE_TAXON(CLONE_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
