/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index DISEASE_SHIP_RELATIONSH_lwr on DISEASE_RELATIONSHIP(lower(RELATIONSHIP)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
