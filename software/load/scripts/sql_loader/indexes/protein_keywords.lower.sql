/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PROTEIN_ORDS_KEYWORD_lwr on PROTEIN_KEYWORDS(lower(KEYWORD)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
