# Prepare
This section describes prepare procedures to create and manage swarm cluster in AWS.
## Prerequisite
To use deployment system you need:

* ansible==2.3.0.0

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

`echo "password" > .vaultpass`
