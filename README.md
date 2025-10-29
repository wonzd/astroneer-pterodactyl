# Astroneer Dedicated Server (in a container)

[![Docker Pulls](https://img.shields.io/docker/pulls/wonzd/astroneer_pterodactyl.svg)](https://hub.docker.com/r/wonzd/astroneer_pterodactyl)
[![Docker stars](https://img.shields.io/docker/stars/wonzd/astroneer_pterodactyl.svg)](https://hub.docker.com/r/wonzd/astroneer_pterodactyl)

A docker image to allow Astroneer Dedicated Server to run inside of Pterodactyl using a modified version of [astroneer-pterodactyl](https://github.com/birdhimself/astroneer-docker), which was based on [AstroTuxLauncher](https://github.com/birdhimself/AstroTuxLauncher). The source code is [available on GitHub](https://github.com/wonzd/astroneer-pterodactyl/).

I created this fork because the [official Astroneer egg](https://github.com/pelican-eggs/games-steamcmd/tree/main/astroneer) failed to start the server, causing the process to hang and then exit. This issue is resolved in this version by using AstroTuxLauncher for reliable server running and updating.

**Supports encryption as well as Intel/AMD CPUs, should run on ARM CPUs**

## How to use

### Importing the pterodactyl egg
1. Download the `.json` file from this repository
2. Open your pterodactyl panel
3. Navigate to Admin (gear icon) -> Nests
4. You may wish to create a new nest with the `Create New` button, however this is not necessary
5. Select `Import Egg`, select your downloaded egg file, then choose the nest this egg will be associated with
6. Finally, import the egg

### Creating the server
Create the server as normal, ensuring you select the imported egg.

The minimum recommended settings are:
* **RAM:** 1.5 GB (1536 MB)
* **Storage:** 5 GB (5120 MB). Note that storage requirements may increase with larger save files.

## Configuration

### Environment

The following environment variables are **hardcoded** into the Docker image. If you require them to be changed from their default setting, you must:
1. Rebuild the Docker image with the appropriate changes made in the `Dockerfile`.
2. Push the new image to a registry (e.g., docker.io).
3. Change the Pterodactyl Egg container image setting to match your custom repository.

| Variable             | Description                                          | Hardcoded Value |
|----------------------|------------------------------------------------------|-----------------|
| `DEBUG`              | Enables debug logging                                | `false`         |
| `DISABLE_ENCRYPTION` | Disables connection encryption                       | `false`         |
| `FORCE_CHOWN`        | `chown`s the `AstroTuxLauncher` folder on startup    | `false`         |

### Server settings

Most server settings can be found in the `AstroServerSettings.ini` file inside the `AstroTuxLauncher/AstroneerServer/Astro/Saved/Config/WindowsServer` folder. It's recommended to stop the server (via the pterodactyl GUI) before editing this file to make sure it's not overwritten the next time the server shuts down.

**NOTE: `AstroTuxLauncher/AstroneerServer/Astro/Saved/Config/WindowsServer` is not an absolute directory, as the permenant directory for pteordactyl is located in /home/container as shown in the GUI**

I'm not listing all settings here (but be sure to check [this post on the official Astroneer blog](https://blog.astroneer.space/p/astroneer-dedicated-server-details/) for more information), but some of the more interesting ones are:

| Key                             | Description                                                                              |
|---------------------------------|------------------------------------------------------------------------------------------|
| `ServerName`                    | Name of the server in the server list                                                    |
| `ServerPassword`                | If set, this password is required to join the server                                     |
| `ActiveSaveFileDescriptiveName` | Name of the active savegame; can be changed to create a new save or load an existing one |

## Variants

### Registries

The image is available from **docker.io**:

| Registry  | Full image name                        |
|-----------|----------------------------------------|
| docker.io | `wonzd/astroneer_pterodactyl:latest`   |

### Available tags

| Tag            | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| `latest`       | Latest version for general use. Recommended in most cases.                       |
| `experimental` | Not currently available. Version with experimental features and changes . Will eventually become `latest`. |

### Architectures

This should support both `amd64` (Intel/AMD CPUs) and `arm64` (e.g. Raspberry Pi, Apple) architectures, however only `amd64` has been tested. The correct image variant should be pulled automatically.

## Encryption support

As of Wine 10.6 and GnuTLS 3.8.3, server encryption is supported. Encryption is enabled by default, which cannot easily be changed. If you wish to change this, follow the steps mentioned in **Environment**

## Configuring clients (if encryption is disabled)

Should you choose to disable encryption, clients will need to be configured accordingly.

To disable encryption, you need to edit the file `Engine.ini` located in `%localappdata%\Astro\Saved\Config\WindowsNoEditor`. Make sure the game isn't running and add the following lines to the file:

```ini
[SystemSettings]
net.AllowEncryption=False
```

## Making yourself admin

Shutdown the server (via the pterodactyl GUI) and edit the file `AstroServerSetting.ini` located in `/AstroTuxLauncher/AstroneerServer/Astro/Saved/Config/WindowsServer/AstroServerSettings.ini`. Change the value of `OwnerName` to your Steam name and make sure `OwnerGuid` is set to `0`. It should look like this:

```ini
OwnerName=My Steam Username
OwnerGuid=0
```

Start the server and make sure you join it before anyone else, as the game will automatically assign the admin/owner role to the first player joining.

## If you can't progress past the first mission

If you can't progress past the first mission, you have to start a new game via the "Server admin" tab after connecting to the server. Click on "Manage game session" followed by "Start a new game" (and confirm by clicking "Start a new game" in the popout):

![Server admin > Manage game session](./readme_assets/new_game_1.png)\
_Server admin > Manage game session_

![Start a new game > Start a new game](./readme_assets/new_game_2.png)\
_Start a new game > Start a new game_
