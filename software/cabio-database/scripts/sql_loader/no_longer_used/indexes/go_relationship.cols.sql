/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GO_RELATSHIP_ID on GO_RELATIONSHIP(ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GO_RELATSHIP_RELATIONSH on GO_RELATIONSHIP(RELATIONSHIP) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GO_RELATSHIP_PARENT_ID on GO_RELATIONSHIP(PARENT_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GO_RELATSHIP_CHILD_ID on GO_RELATIONSHIP(CHILD_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
