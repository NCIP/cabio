/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PROTEIN_ENCE_CHECKSUM_lwr on PROTEIN_SEQUENCE(lower(CHECKSUM)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
