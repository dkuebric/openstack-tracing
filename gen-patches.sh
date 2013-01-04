#!/bin/bash

REPOS="cinder glance horizon keystone nova"

for repo in `echo $REPOS`; do
    cd ../$repo
    git diff -p stable/folsom > ../openstack-tracing/patches/$repo.patch
done
