/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index VOCABULARY_GENERAL_TERM on VOCABULARY(GENERAL_TERM) tablespace CABIO_FUT;
create index VOCABULARY_CORE_TERM on VOCABULARY(CORE_TERM) tablespace CABIO_FUT;
create index VOCABULARY_VOCABULARY_ID on VOCABULARY(VOCABULARY_ID) tablespace CABIO_FUT;

--EXIT;
