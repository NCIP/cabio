/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/indexes/snp_tv.lower.sql
@$LOAD/indexes/snp_tv.cols.sql

@$LOAD/constraints/snp_tv.enable.sql
@$LOAD/triggers/snp_tv.enable.sql

ANALYZE TABLE snp_tv COMPUTE STATISTICS;

EXIT;
