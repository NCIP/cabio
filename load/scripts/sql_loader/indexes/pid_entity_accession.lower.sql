/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PID_ENTISION_DATABASE_lwr on PID_ENTITY_ACCESSION(lower(DATABASE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PID_ENTISION_ACCESSION_lwr on PID_ENTITY_ACCESSION(lower(ACCESSION)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
