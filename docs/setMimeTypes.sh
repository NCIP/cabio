find portletOnlineHelp/* -name *.html -exec svn propset svn:mime-type text/html {} \;
find portletOnlineHelp/* -name *.htm -exec svn propset svn:mime-type text/html {} \;
find portletOnlineHelp/* -name *.css -exec svn propset svn:mime-type text/css {} \;

