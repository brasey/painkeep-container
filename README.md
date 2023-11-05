# painkeep-container

## What is this

I run a Quake Painkeep server in GCP using a container. This is that container.

The binary that runs Quake is [mvdsv](https://github.com/QW-Group/mvdsv).

There is a mounted volume called `/painkeep`, this is where all the files needed for the game are kept. This allows me to upgrade the OS and system-level dependencies at the container level, while maintaining the game files separately. Unfortunately this creates a chicken-and-egg situation; when the container first starts up there are no game files. So to bootstrap, fire up the container and copy all the files from somewhere to `/painkeep`, then you should be good to go.

## Container build process

These notes are for me and my process, you'll probably have to change a lot of stuff to make them useful for you.

Note that I'm using the tag `mvdsv-0.36` to indicate that version of the binary.

Connect to my GCP project

```shell
gcloud auth login
gcloud config set project painkeep
```

Update some stuff, like `FROM` image version, or just build the container again to get latest `dnf` updates. Then,

```shell
docker build -t painkeep:mvdsv-0.36 .
docker tag painkeep gcr.io/painkeep/painkeep:mvdsv-0.36
docker push gcr.io/painkeep/painkeep:mvdsv-0.36
gcloud compute instances reset painkeep
```

## Run the server locally

You need all the game directories local (`id1`, `logs`, `Painkeep`, `qw`). I just put them in the same location as this repo.

Check the numerical UID owner:group of the local files: you'll need to alter the `Dockerfile` to match. Note that this is likely different from the UIDs on the host where your container is going to end up running, so you'll have to know what the owner:group is there too, and eventually build your container using those IDs.

Start the server like this:

```shell
docker run -it -v ./:/painkeep -p 127.0.0.1:27500:27500/udp painkeep:mvdsv-0.36
```
