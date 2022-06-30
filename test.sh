#!/usr/bin/env bash

if [ ! -d "../docker" ]; then
    mkdir ../docker
fi

if [ ! -d "../docker/elasticserach" ]; then
    mkdir ../docker/elasticserach
fi

if [ ! -d "../docker/elasticserach/data" ]; then
    mkdir ../docker/elasticserach/data
fi