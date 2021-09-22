rem install docker

rem RUN DOCKER
rem docker run -d web-file-browser
rem docker run -p 80:80 --name filebrowser -d filebrowser/filebrowser
call docker_build.bat
docker stop filebrowser
docker run --rm -p 80:80 --name filebrowser -d web-file-browser