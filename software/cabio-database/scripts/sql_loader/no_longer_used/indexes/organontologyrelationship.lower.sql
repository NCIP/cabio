/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ORGANONTSHIP_RELATIONSH_lwr on ORGANONTOLOGYRELATIONSHIP(lower(RELATIONSHIP)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
