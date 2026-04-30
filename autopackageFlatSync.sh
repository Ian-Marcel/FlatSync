#!/usr/bin/env bash

if [ "${PWD##*/}" != "FlatSync" ]; then
    printf "Erro: FlatSync not found! \n"
    exit 1
else
    cd ..
    tar -zcf FlatSync.tar.gz FlatSync
    mv FlatSync.tar.gz ~/Downloads/
    cd FlatSync
fi
