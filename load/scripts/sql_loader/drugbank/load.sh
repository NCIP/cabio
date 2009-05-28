$SQLLDR $1 readsize=1000000 control=drugbank_drugs.ctl log=drugbank_drugs.log bad=drugbank_drugs.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=drugbank_targets.ctl log=drugbank_targets.log bad=drugbank_targets.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=drugbank_drug_targets.ctl log=drugbank_drug_targets.log bad=drugbank_drug_targets.bad direct=true skip=1 errors=50000
$SQLLDR $1 readsize=1000000 rows=100000 control=drugbank_drug_aliases.ctl log=drugbank_drug_aliases.log bad=drugbank_drug_aliases.bad direct=true skip=1 errors=50000
