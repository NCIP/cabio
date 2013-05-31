/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index CGAP_GENLIAS_ALIAS_lwr on CGAP_GENE_ALIAS(lower(ALIAS)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
