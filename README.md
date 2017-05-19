# Prepare
This section describes prepare procedures to create and manage swarm cluster in AWS.
## Prerequisite
To use deployment system you need:

* python2
* ansible==2.3.0.0
* awscli==1.11.89

You can install it with:

`pip install -r requirements.txt`

## Changes made in src

To split container and dev environment there was created addition
.properties file in Spring Boot Project

`application-container.properties`

To use `container` profile you need just pass
[SPRING_PROFILES_ACTIVE](https://docs.spring.io/spring-boot/docs/current/reference/html/howto-properties-and-configuration.html#howto-change-configuration-depending-on-the-environment)
 OS environment variable when run project.

## Create vaultpass file
All sensitive variables shoud be stored in encrypted vault_vars.yml file.
It is a simple `key:value` storage file;

`somevar: "text vaule"`

After gilling up this file you need to encrypt it with

`ansible-vault encrypt vault_vars.yml`

after this you can store in any CVS safely.

To have run withou prompt you can use

`echo "password" > .vaultpass`

`.vaultpass` file in `.gitignore` so you can be sure that it would not be pushed in CVS


## Vars

All variables stored in `vars.yml` you can change it if you need.

## Run
Running the project in two steps:

### Preparing swarm cluster

To have swarm running in AWS I have use official docker docs.
They provide us cloudfron template, that I run with ansible.



### Build and deploy app