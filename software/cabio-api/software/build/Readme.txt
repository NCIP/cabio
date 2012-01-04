In addition to the content in this directory, you will need the following files:
https://gforge.nci.nih.gov/svnroot/automation/trunk/bda/ivy/bda-ivy-build.xml
https://gforge.nci.nih.gov/svnroot/automation/trunk/bda/ivy/ivy-bda-settings.xml
https://gforge.nci.nih.gov/svnroot/automation/trunk/bda/ivy/ivy-bda.xml

# copy files from here to project, here is ample how to do on linux

export projectdir="$HOME/src/trunk/yourporjecthere/software"

export projectdir="$HOME/src/trunk/coppa/code"

tar cvf - build common --wildcards --exclude .svn --exclude "*~" | (cd $projectdir; tar xvf -)

# 
cd $projectdir
perl -i -pe 's/bda-blueprints-api/yoursubproject/g' *.*
perl -i -pe 's/bda-blueprints-webapp/yoursubproject/g' *.*



cd $projectdir
perl -i -pe 's/bda-blueprints-api/pa-ear/g' *.*
perl -i -pe 's/bda-blueprints-webapp/pa-web/g' *.*
