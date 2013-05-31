/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index CLONE_TVE_TV_TYPE_lwr on CLONE_TV(lower(TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index CLONE_TVE_TV_CLONE_NAME_lwr on CLONE_TV(lower(CLONE_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
