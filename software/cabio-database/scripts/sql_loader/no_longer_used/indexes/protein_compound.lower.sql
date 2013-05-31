/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index PROTEIN_OUND_VALUE_lwr on PROTEIN_COMPOUND(lower(VALUE)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
