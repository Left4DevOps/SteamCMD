# Steamcmd Docker Image
Steamcmd in a ready to run docker image. For your convenience, there are two symlinks you can copy or mount:
* `/steamapps`
* `/config`

## Run interactively 

```shell
docker run -it --name steamcmd left4devops/steamcmd
```

[Valve steamcmd wiki](https://developer.valvesoftware.com/wiki/SteamCMD#SteamCMD_Login)

## Install a game
Mount a directory, login (as `gaben`in this example, some games allow you to download after logging in as `anonymous`) and download a game (`222860`, Left 4 Dead 2 Dedicated Server). You can lookup other App IDs on [SteamDB](https://steamdb.info).

```shell
docker run -it -v $(pwd)/steamapps:/steamapps --name steamcmd left4devops/steamcmd +login gaben +app_update 222860 +quit
```

## Generate a logged in config.vdf
This can be used to avoid providing your credentials when logging in to install authenticated content.

```shell
docker run -it --name steamcmd left4devops/steamcmd +login gaben +quit
docker cp steamcmd:/config/config.vdf .
docker rm steamcmd
```

## Authenticated download, then copy into another image
Download using this image, then copy the output to a new image without any credentials to clean up.

Example `Dockerfile`
```dockerfile
FROM left4devops/steamcmd AS credentials
RUN --mount=type=secret,uid=1000,gid=1000,id=steam,target=/config/config.vdf \
    ./steamcmd.sh +login gaben +app_update 222860 +quit

FROM rockylinux/rockylinux:9-minimal AS game
COPY --chown=1000:1000 --from=credentials \
    "/steamapps/common/Left 4 Dead 2 Dedicated Server" \
    /l4d2
```

Provide the credentials for the above `docker build --secret id=steam,src="$(pwd)/config.vdf"  .`

# Build this image
```shellx
docker build -t left4devops/steamcmd .
```