
#!/bin/sh
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/bin
if [ $# -ne 0 ]
then
   JAVA_HOME=$1
fi
_RUNJAVA=$JAVA_HOME/bin/java
CLASSPATH="$CLASSPATH":
JAVA_OPTS="-Xms164m -Xmx512m -Dfile.encoding=UTF-8"
export _RUNJAVA
export CLASSPATH
export JAVA_OPTS

sh ./startwsdoc.sh $1
