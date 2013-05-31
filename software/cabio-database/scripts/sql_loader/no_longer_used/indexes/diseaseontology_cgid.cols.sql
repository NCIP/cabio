/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index DISEASEONTOLO_ID on DISEASEONTOLOGY_CGID(ID) tablespace CABIO_MAP;
create index DISEASEONTOLO_DISEASEONTOLOGY on DISEASEONTOLOGY_CGID(DISEASEONTOLOGY) tablespace CABIO_MAP;
create index DISEASEONTOLO_EVS_ID on DISEASEONTOLOGY_CGID(EVS_ID) tablespace CABIO_MAP;

--EXIT;
