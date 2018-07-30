## get_iplayer on Docker

Disappointed with the current availability of get_iplayer in docker, I set my self the task of creating my first docker container.

For now, this uses the plain Ubuntu image, so is huge for a very simply perl program - definitely needs the packages trimming.  I've added a testing branch to the github repo so that I can experiment with either other base images to see if I can get this reduced in size - current uncompressed ubuntu is around 400mb.

# Usage
    docker create \
    --name get_iplayer \
    -p 8181:8181 \
    -v /etc/localtime:/etc/localtime:ro \
    -v </path/to/config>:/root/.get_iplayer \
    -v </path/to/downloads>:/root/output \
    kolonuk/get_iplayer

* Backup your current config and recordings.
* Mount `/root/.get_iplayer` to your config directory.  This should incoude your `options` file and `pvr` directory.  If starting from scratch, you can manually edit the `options` file created here.
* Mount `/root/output` to your recordings location.

**WARNING - get_iplayer stores cookies in your browser for some default settings.  Because of this, at least try to see if you can find those cookies and remove them BEFORE loading the newly installed container.**

# Start
Upon first start, it will download the latest get_iplayer scripts from the official github repo <https://github.com/get-iplayer/get_iplayer>.  This is different from other docker containers in that when the version of get_iplayer is not static, you just need to re-create this container and it will have the latest version from the get_iplayer repo.  Currently, it just grabs the raw source code, but the next step is to actually check the releases and upgrade when a new release is available.

**Watchtower <https://github.com/v2tec/watchtower> will not update this container to the latest version of get_iplayer.  Until Docker introduces monitoring of alternative github repos for automated builds (to trigger watchtower), this is the best you can get.**  To update, either delete `/root/get_iplayer*` in the container, or recreate it - I use Portainer <https://hub.docker.com/r/portainer/portainer/> and just hit the `Recreate` button.

* When starting this for the first time, it will create some nice newbie default options (enable whitespace in filenames, etc.).
* When starting this using existing configuration files, it will forcibly change the output location to the container's output volume location, thus hopefully, it should "just work".

# Issues
* Report issues with this dockerfile <https://github.com/kolonuk/get_iplayer/issues>
* Report issues with the get_iplayer script <https://squarepenguin.co.uk/forums/>

# About me
Just a small-time tinkerer of almost anything computer-related (servers, raspi, networks, programming, android, etc.).  I am active on various places on the net, like StackExchange, github, and some mailing lists, etc., so ping me a message about anything - if I don't know, I'll know where to go to find out!

# Todo
1. Check different base os's for Dockerfile
2. Remove as much gumf as possible
3. Auto update check script for the get_iplayer github repo releases
