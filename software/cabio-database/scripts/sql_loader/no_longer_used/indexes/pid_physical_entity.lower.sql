/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PID_PHYSTITY_DISCRIMINA_lwr on PID_PHYSICAL_ENTITY(lower(DISCRIMINATOR)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
