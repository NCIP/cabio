/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GENE_KEYWORD_KEYWORD_lwr on GENE_KEYWORDS(lower(KEYWORD)) PARALLEL NOLOGGING tablespace CABIO;

--EXIT;
