/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index MARKER_ALIAS_NAME_lwr on MARKER_ALIAS(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
