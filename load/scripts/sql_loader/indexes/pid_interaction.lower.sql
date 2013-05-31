/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PID_INTETION_DISCRIMINA_lwr on PID_INTERACTION(lower(DISCRIMINATOR)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PID_INTETION_MACRO_NAME_lwr on PID_INTERACTION(lower(MACRO_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PID_INTETION_SOURCE_lwr on PID_INTERACTION(lower(SOURCE)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
