# Prepare
This section describes prepare procedures to create and manage swarm cluster in AWS.

![alt text](https://github.com/boskiv/journals/raw/master/cloudcraft-docker-swarm-architecture.png "Docker Swarm Architecture")


## Prerequisite
To use deployment system you need:

* docker
* python2
* awscli==1.11.89
* ansible==2.3.0.0
* boto==2.46.1
* boto3==1.4.4
* docker-py==1.10.6

You can install it with:

`pip install -r requirements.txt`


## Quick start

Make a clean env:
1. docker run -it -v $(pwd):/code -v /var/run/docker.sock:/var/run/docker.sock --rm docker:dind sh
2. cd /code
3. apk update && apk add python py-pip rsync python-dev gcc linux-headers musl-dev openssl-dev libffi-dev openssh-client
4. pip install -U -r requirements.txt
5. aws configure
6. echo password > .vaultpass

Running a project:

1. `ansible-playbook journals-swarm.yml` (10 min first run) (by default 1 manager and 3 worker nodes)
2. (optional) `ansible-playbook journals-swarm.yml -e ClusterSize=5` (3 min)
3. `ansible-playbook journals-build.yml` (10 min first run)
4. `ansible-playbook journals-deploy.yml` (30 sec) (by default 2 replicas of app container)
5. (optional) `ansible-playbook journals-deploy.yml -e app_replicas=5` (30 sec)
6. open file .app-url and go to provided URLs to see cluster status and working app.
7. ...
8. Profit!!!
9. `ansible-playbook journals-clean.yml` (10 min)


# TL;DR;

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

## Use `vault_vars.yml` file

Use vault_vars.yml to store sensivity data:
Such as passwords variables to database connection.

If you want to change passwords you need to
* decrypt vault file `ansible-vault decrypt vault_vars.yml` with default password: `password`
* change values
* encrypt it `ansible-vault encrypt vault_vars.yml` with password that you use in `.vaultpass`
(if there is no .vaultpass file, you will be asked to enter password from cmd)

## Vars

All variables stored in `vars.yml` you can change it if you need.

## Run
Running the project in two steps:

### Preparing swarm cluster

To have swarm running in AWS I have use official docker docs.
They provide us cloudformation template, that I run with ansible.

To able work with AWS you need to export next variable in your console

(http://docs.aws.amazon.com/cli/latest/topic/config-vars.html)
(http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-environment)

```
[default]
aws_access_key_id=foo
aws_secret_access_key=bar
region=us-west-2
```

if there is no ENV variables, ansible will try to use it from `~/.aws/credentials` and `~/.aws/config` files

**Region variable will be import from ENV to aws_region else us-east-1 will be used by default**

To bootstrap swarm cluster you need to run

`ansible-playbook journals-swarm.yml`

Parameters such as inventory file and vaultpass file are comes from `ansible.cfg`

Command will run about 10-15 minutes and provides you fresh new cluster with variables you specified in vars.yml

It also make some tuning against manager node to have possibility accept ansible commands.

When Swarm cluster boots up it use CloudStor plugin to share EFS Volumes between nodes.

Thats give us possibility to use it for uploaded documents.
You can see how it setuped in docker-compose template file used for generation in templates folders.


### Build and deploy app


After your cluster prepared you can run build with:

`ansible-playbook journals-build.yml`

It takes about 8 minutes. It purpose to build docker image from code and
push into private registry created in first step.

after build success you can deploy your app to swarm

`ansible-playbook journals-deploy.yml`

You can specify how mane replicas you need in vars file or from command prompt

`ansible-playbook journals-deploy.yml -e app_replicas=3`



### Viewing result

There are two URLS are provided after deploy. Both of them are generated file `.app-url`

Sample:
```
[App URL]
http://journals-External-W5B2GBW7DYGI-1656267572.us-east-1.elb.amazonaws.com:8080

[Visualizer URL]
http://journals-External-W5B2GBW7DYGI-1656267572.us-east-1.elb.amazonaws.com:8081
```

App URL you can use to trying your app deployed.

Visualizer it's just pretty view of you cluster status.


## Logs
All logs are stored in CloudWatch. There is a stream created.


## Clearing up

After all step you can clear up all stack by running command

`ansible-playbook journals-clean.yml`


# TODO:

* Upload sample pdf document into EFS volume
* refactoring playbooks into one with roles and tags
* make test against deployed app