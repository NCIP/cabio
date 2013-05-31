/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index GO_CLOSUSURE_ANCESTOR on GO_CLOSURE(ANCESTOR) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index GO_CLOSUSURE_GO_CODE on GO_CLOSURE(GO_CODE) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
