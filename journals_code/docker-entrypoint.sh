#!/usr/bin/env bash


/wait-for-it.sh mysql:3306 -- java -jar app.jar