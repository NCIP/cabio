/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/indexes/nucleic_acid_sequence.cols.sql;
@$LOAD/indexes/nucleic_acid_sequence.lower.sql;
@$LOAD/constraints/nucleic_acid_sequence.enable.sql;
@$LOAD/triggers/nucleic_acid_sequence.enable.sql;
ANALYZE TABLE nucleic_acid_sequence COMPUTE STATISTICS;

EXIT;
