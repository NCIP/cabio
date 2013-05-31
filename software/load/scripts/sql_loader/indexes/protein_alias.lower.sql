/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PROTEIN_LIAS_NAME_lwr on PROTEIN_ALIAS(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
