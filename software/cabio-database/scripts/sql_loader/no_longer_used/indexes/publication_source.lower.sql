/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PUBLICATION__NAME_lwr on PUBLICATION_SOURCE(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PUBLICATION__TITLE_lwr on PUBLICATION_SOURCE(lower(TITLE)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
