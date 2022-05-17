# godot-docker

Docker image for Godot builds

## Android build

To use the docker image in Godot project directory:
```
docker run -v <keystore directory>:/root/keys/ -v $(pwd):/root/project/ -v <output directory>:/root/out/ godot-docker <cmd>
```
It seems that for some reason the Godot export does not work (at least on my machine) unless one would first `cd` to the project directory, 
so for example we could create script called `build.sh` in the Godot project directory with following contents:

```
#!/bin/sh
cd /root/project
godot -v --export-debug Android /root/out/myapk.apk
```

And then run the docker container like this:
```
docker run -v <keystore directory>:/root/keys/ -v $(pwd):/root/project/ -v <output directory>:/root/out/ godot-docker sh /root/project/build.sh
```