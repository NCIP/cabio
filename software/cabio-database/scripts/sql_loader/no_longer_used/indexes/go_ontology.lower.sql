/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GO_ONTOLLOGY_GO_NAME_lwr on GO_ONTOLOGY(lower(GO_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
