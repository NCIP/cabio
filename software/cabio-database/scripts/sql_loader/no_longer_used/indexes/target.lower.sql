/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index TARGETRGET_TARGET_NAM_lwr on TARGET(lower(TARGET_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
