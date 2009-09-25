#!/bin/sh
PROJECT=rpm-build-altlinux-compat
git push --all $@ git.eter:packages/$PROJECT.git
git push --all $@ git.alt:packages/$PROJECT.git
git push --tags $@ git.eter:packages/$PROJECT.git
git push --tags $@ git.alt:packages/$PROJECT.git
