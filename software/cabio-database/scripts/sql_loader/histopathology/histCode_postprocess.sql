/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/indexer_new.sql gene_histopathology
@$LOAD/indexer_new.sql histopathology_tst
@$LOAD/indexes/gene_histopathology.lower.sql
@$LOAD/indexes/gene_histopathology.cols.sql
@$LOAD/indexes/histopathology_tst.lower.sql
@$LOAD/indexes/histopathology_tst.cols.sql
@$LOAD/constraints/gene_histopathology.enable.sql
@$LOAD/triggers/gene_histopathology.enable.sql

EXIT;
