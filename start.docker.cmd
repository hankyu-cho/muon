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

::Docker Container 이름
set DOCKER_CON=air_html5

::도커 디렉토리와 Windows PC 디렉토리와의 마운트 경로 지정. Windows PC의 경로 설정방식에 주의할것. 
set WEBS-LOG=/c/air/log/tomcat-log:/usr/local/tomcat/logs

::Browser 설치경로를 기존 패스에 추가함
set B-PATH=C:\Air\prod\Application\

::Browser 실행옵션
set "B-ARG=http;?/localhost:8080?system=air&emergency=Y --windowName=exec"

::------전역변수 설정 끝------::

::Docker Desktop 실행을 위한 조건 확인
::task list에서 imagename으로 검색해서 docker desktop.exe 프로세스가 로드 되어 있는지 확인.
::image name에 공백이 들어있기 때문에 해당부분 처리하는 EXE_ 부분이 필요하다.(stackoverflow에서 가이드)
::프로세스가 기동하고 Docker Desktop의 대쉬보드가 로드 될때까지 timeout 시간만큼 대기한다. 
echo.
echo image load check
set EXE=Docker Desktop.exe
FOR /F %%x IN ("%EXE%") do set EXE_=%%x
FOR /F %%x IN ('tasklist /NH /FI "IMAGENAME eq %EXE%"') DO IF NOT %%x == %EXE_% (
		echo %EXE% is not running
		call "C:\Program Files\Docker\Docker\frontend\Docker Desktop.exe" 2>&1
		timeout 35
)

:: 기존에 이미지와 컨테이너가 로드 되어 있다면 모두 삭제 한다. 
echo 기존사용 이미지와 컨테이너 삭제
    FOR /F %%i IN ('docker ps -aq --filter "ancestor=%DOCKER_IMG%"') do docker rm -f %%i
    docker rmi -f %DOCKER_IMG%
    echo Docker delete.. complete           

:: 미리 설정된 이름의 도커카일을 로드한다. 
echo 도커 파일 load
    docker load -i %DOCKER_FILE%
    pause

:: 도커 컨테이너를 실행한다. 도커 내부의 was 영역의 로그를 Windows PC의 특정 디렉토리와 마운트하여 저장한다.(컨테이너 종료 이후에도 로그를 보존한다.)
:: 
echo.
echo 도커 컨테이너 실행
       docker run -d -v %DOCKER_CON% -items --name %DOCKER_CON% -p 8080:8080 %DOCKER_IMG%
      
:: 라이센스가 변경되는경우 컨테이너에 반영후 재기동
echo 도커 컨테이너에 변경된 라이센스 파일 복사후 컨테이너 재기동 
docker cp license.websquare5 %DOCKER_CON%:/usr/local/tomcat/webapps/ROOT/WEB-INF/websquare_home/license
docker stop %DOCKER_CON%
docker start %DOCKER_CON%

echo.
echo 컨테이너가 실행중입니다. 브라우저를 실행합니다.
    pause
    path %WMB-PATH%;
    start %WMB-PATH\browser.exe %WMB-ARG%
exit
