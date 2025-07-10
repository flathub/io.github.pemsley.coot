#!/usr/bin/env bash

# Cython version corresponding to the specified numpy version must be manually added to pypi-dependencies.json afterwards
./flatpak-builder-tools/pip/flatpak-pip-generator --runtime='org.gnome.Sdk//48' --requirements-file='requirements.txt' --output=pypi-dependencies --ignore-installed=numpy
