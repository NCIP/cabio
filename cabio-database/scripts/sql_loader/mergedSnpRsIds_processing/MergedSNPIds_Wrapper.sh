#!/bin/sh

# Download the data
echo "Downloading merged SNPRsIds Data \n";
sh download_MergedSNPRsIdsData_NCBI.sh

echo "Formatting the downloaded file for caBIO"
# Parse / reformat the data
perl MergedSnpRsIds_DataFormatter.pl RsMergeArch.bcp RsMergeArch.bcp.out

echo "Doing database housekeeping operations for concerned tables"
# Drop the indexes and constraints
$ORACLE_HOME/bin/sqlplus $1 @MergedSnpRsIds_DropIndexes.sql

# Load the data into the table using SQL Loader
$SQLLDR $1 readsize=1000000 rows=100000 control=zstg_merged_snp_rsids_mapping_sqlldr.ctl log=zstg_merged_snp_rsids_mapping_sqlldr.log bad=zstg_merged_snp_rsids_mapping_sqlldr.bad direct=true errors=50000

# Re create the indexes and constraints
# Create the temporary table
# Add the mappings to that table and to snp_reporter
$ORACLE_HOME/bin/sqlplus $1 @MergedSnpRsIds_Mapper.sql

exit;

