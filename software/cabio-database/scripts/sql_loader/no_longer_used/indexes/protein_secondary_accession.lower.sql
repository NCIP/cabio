/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PROTEIN_SION_SECONDARY__lwr on PROTEIN_SECONDARY_ACCESSION(lower(SECONDARY_ACCESSION)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
