# burpsuite-novnc-docker
BurpSuite Pro running novnc in docker

## Setting things up
- If you already have a prefs.xml file which was created using a 'burp' user then you can just replace prefs.xml in this folder
- If you don't have a prefs.xml file then you'll need to activate BurpSuite within a container by running ```docker-compose build activate && docker-compose up activate```. In order for this to work you'll need to replace the activation key in activate.sh with your burpSuite pro activation key. Once the container is successfully running you can bash into the running docker container and copy the contents of the prefs.xml file in ```/home/burp/.java/userPrefs/burp/```. If you are using VScode then you can do this really easily using the Docker extension; click on the running container and you will be able to explore the files and download the prefs.xml file.

## Running a novnc container
Run ```docker-compose build novnc && docker-compose up novnc```. Once you have done this and the container is running successfully you'll have the following ports available:
- Rest api available at ```http://127.0.0.1:1337/v0.1/```.
- Novnc available at ```http://127.0.0.1:8085/vnc.html```.
- BurpSuite proxy available at ```http://127.0.0.1:8080```.

## Running a rest container
Run ```docker-compose build rest && docker-compose up rest```. Once you have done this and the container is running successfully you'll have the following ports available:
- Rest api available at ```http://127.0.0.1:1337/v0.1/```.
- BurpSuite proxy available at ```http://127.0.0.1:8080```.