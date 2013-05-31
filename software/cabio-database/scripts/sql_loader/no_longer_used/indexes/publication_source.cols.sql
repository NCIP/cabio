/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PUBLICATION_S_ID on PUBLICATION_SOURCE(ID) tablespace CABIO_FUT;
create index PUBLICATION_S_NAME on PUBLICATION_SOURCE(NAME) tablespace CABIO_FUT;
create index PUBLICATION_S_YEAR on PUBLICATION_SOURCE(YEAR) tablespace CABIO_FUT;
create index PUBLICATION_S_VOLUME on PUBLICATION_SOURCE(VOLUME) tablespace CABIO_FUT;
create index PUBLICATION_S_TITLE on PUBLICATION_SOURCE(TITLE) tablespace CABIO_FUT;
create index PUBLICATION_S_START_PAGE on PUBLICATION_SOURCE(START_PAGE) tablespace CABIO_FUT;
create index PUBLICATION_S_END_PAGE on PUBLICATION_SOURCE(END_PAGE) tablespace CABIO_FUT;

--EXIT;
