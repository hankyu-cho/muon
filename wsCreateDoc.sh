#!/bin/sh              

 #
 # Copyright 2021 by HK.JO    
 #
 #ident  "wsCreateDoc.sh         1.0    2021/04/12

 #
 # 웹스퀘어5에서 사용하는 WDocs실행 스크립트. JDK 경로 인자를 주는 경우 해당 경로의 java실행. 
 # setenv 역활을 하며 startwsdoc.sh에서 jar화일을 실행한다.  $# -ne 의 사용법 예시


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
