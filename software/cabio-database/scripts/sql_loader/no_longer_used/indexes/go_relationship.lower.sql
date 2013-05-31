/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GO_RELATSHIP_RELATIONSH_lwr on GO_RELATIONSHIP(lower(RELATIONSHIP)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
