/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index CLONE_RETION_TYPE_lwr on CLONE_RELATIVE_LOCATION(lower(TYPE)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
