IF [%1] == [] GOTO error


docker login
RMDIR /s /q .\dist\

call docker_build.bat

rem RUN DOCKER TO PUBLISH
docker tag web-file-browser:latest registry.aptero.co/web-file-browser:latest
docker push registry.aptero.co/web-file-browser:latest

docker tag web-file-browser:latest registry.aptero.co/web-file-browser:%1
docker push registry.aptero.co/web-file-browser:%1


GOTO :EOF
:error
ECHO incorrect_parameters