caBIO Code Coverage with Emma
-----------------------------

Steps to see code coverage of the unit tests on both client and server:

ant clean
ant build-system
ant -buildfile build-emma.xml instr-system
(deploy instrumented cabio40.war to server)
cd test
ant alltests
cd ..
ant -buildfile build-emma.xml report


References:
http://emma.sourceforge.net/reference/reference.html
http://emma.sourceforge.net/faq.html
http://sourceforge.net/project/shownotes.php?release_id=336859