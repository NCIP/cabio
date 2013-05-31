/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PROTEIN_OUND_VALUE on PROTEIN_COMPOUND(VALUE) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PROTEIN_OUND_COMPOUND_I on PROTEIN_COMPOUND(COMPOUND_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
