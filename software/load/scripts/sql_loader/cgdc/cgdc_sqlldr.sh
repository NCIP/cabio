#!/bin/sh
cd $CABIO_DIR/scripts/parse/cgdc

# combines all diseases and agents
sh combine_data.sh

# converts this combined to wellFormed.xml
perl xmlCorrecter.pl combined.xml wellFormed.xml

# parse this clean file  
perl xmlParser.pl wellFormed.xml 
cd $LOAD/cgdc
sqlplus $1 @cgdc_preprocess.sql;
$SQLLDR $1 readsize=1000000  rows=100000 control=Agent.ctl log=Agent.log bad=Agent.bad direct=true  errors=5000 skip=1 
$SQLLDR $1 readsize=1000000  rows=100000 control=DiseaseOntology.ctl log=DiseaseOntology.log bad=DiseaseOntology.bad direct=true  errors=5000 skip=1 

$SQLLDR $1 readsize=1000000  rows=100000 control=RoleCode.ctl log=RoleCode.log bad=RoleCode.bad direct=true  errors=5000 skip=1 

$SQLLDR $1 readsize=1000000  rows=100000 control=EvidenceCode.ctl log=EvidenceCode.log bad=EvidenceCode.bad direct=true  errors=5000 skip=1 
$SQLLDR $1 readsize=1000000 control=Evidence.ctl log=Evidence.log bad=Evidence.bad direct=true errors=5000 skip=1 
$SQLLDR $1 readsize=1000000 control=Gene_GeneAlias.ctl log=Gene_GeneAlias.log bad=Gene_GeneAlias.bad direct=true errors=5000 skip=1 

$SQLLDR $1 readsize=1000000 rows=100000 control=Gene_Agent.ctl log=Gene_Agent.log bad=Gene_Agent.bad direct=true  errors=5000 skip=1 
$SQLLDR $1 readsize=1000000 rows=100000 control=Gene_DiseaseOntology.ctl log=Gene_DiseaseOntology.log bad=Gene_DiseaseOntology.bad direct=true  errors=5000 skip=1 
$SQLLDR $1 readsize=1000000 rows=100000 control=Gene_Role.ctl log=Gene_Role.log bad=Gene_Role.bad direct=true  errors=5000 skip=1 
$SQLLDR $1 readsize=1000000 rows=100000 control=GAE.ctl log=Gene_Agent_Evidence.log bad=Gene_Agent_Evidence.bad direct=true  errors=5000 skip=1 
$SQLLDR $1 readsize=1000000 rows=100000 control=GDE.ctl log=Gene_Disease_Evidence.log bad=Gene_Disease_Evidence.bad direct=true  errors=5000 skip=1 
$SQLLDR $1 readsize=1000000 rows=100000 control=Gene_Evidence.ctl log=Gene_Evidence.log bad=Gene_Evidence.bad direct=true  errors=5000 skip=1 

$SQLLDR $1 readsize=1000000 rows=100000 control=EvidenceEvidenceCode.ctl log=EvidenceEvidenceCode.log bad=EvidenceEvidenceCode.bad direct=true  errors=5000 skip=1 

$SQLLDR $1 readsize=1000000 rows=100000 control=MissingAgentEVSIds.ctl log=MissingAgentEVSIds.log bad=MissingAgentEVSIds.bad direct=true  errors=5000 skip=1 
$SQLLDR $1 readsize=1000000 rows=100000 control=MissingDiseaseOntology.ctl log=MissingDiseaseOntology.log bad=MissingDiseaseOntology.bad direct=true  errors=5000 skip=1 
$SQLLDR $1 readsize=1000000 rows=100000 control=Agent_NSC.ctl log=Agent_NSC.log bad=Agent_NSC.bad direct=true  errors=5000 skip=1 
wait
$SQLPLUS $1 @cgdc_postprocess.sql;
$SQLPLUS $1 @histologycode_update.sql;
$SQLPLUS $1 @agent_update.sql;
$SQLPLUS $1 @cgdc_load.sql;

