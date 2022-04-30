도커 기동  스크립트

@echo off
:: Docker maanger batch file
:: FileName - go1.cmd
:: Version 1.2
:: Aprig 26, 2022
:: miles <hankyu@inswave.com>


:도스창 제목 설정
title HTML5
::배경색과 문자색 지정
color 9F
::도스창 크기 조정
mode con cols=80 lines=40

::-----Batch file에서  사용하는 전역변수 설정-----::

::Load 해야하는 Docker Image tar File
set DOCKER_FILE=air_html5-v1.tar

::Docker Image 이름
set DOCKER_IMG=air_html5-v1.base

::Browser 설치경로를 기존 패스에 추가함
set B-PATH=C:\Air\prod\Application\

::Browser 실행옵션
set "B-ARG=http;?/localhost:8080?system=air&emergency=Y --windowName=exec"

::------전역변수 설정 끝------::

::Docker Desktop 실행을 위한 조건 확인
echo.
echo image load check
set EXE=Docker Desktop.exe
FOR /F %%x IN ("%EXE%") do set EXE_=%%x
FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %EXE%"') DO IF NOT %%x == %EXE_% (
		echo %EXE% is not running
		call "C:\Program Files\Docker\Docker\frontend \Docker Desktop.exe" 2>&1
		timeout 35
)




echo 기존사용 이미지와 컨테이너 삭제
    FOR /F %%i IN ('docker ps -aq --filter "ancestor=%DOCKER_IMG%"') do docker rm -f %%i
    docker rmi -f %DOCKER_IMG%
    echo Docker delete.. complete           

echo.
echo 도커 파일 load
    docker load -i %DOCKER_FILE%
    pause

echo.
echo 도커 컨테이너 실행
  ::  docker run -d -items --name next_air_html5 -p 8080:8080 %DOCKER_IMG%
      docker run -d -v /usr/local/tomcat/webapps/ROOT/WEB-INF/websquare_home/log:C:\websquare\log -items --name next_air_html5 -p 8080:8080 %DOCKER_IMG%

echo.
echo 도커 컨테이너에 변경된 라이센스 파일 복사
docker cp license.websquare5 next_air_html5:/usr/local/tomcat/webapps/ROOT/WEB-INF/websquare_home/license
docker stop next_air_html5
docker start next_air_html5

echo.
echo Docker Container run
    docker ps -a

echo.
echo 컨테이너가 실행중입니다. 브라우저를 실행합니다.
    pause
    path %WMB-PATH%;
    start %WMB-PATH\W-MatrixDev.exe %WMB-ARG%
exit




