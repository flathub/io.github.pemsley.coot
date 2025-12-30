#!/usr/bin/env bash

./flatpak-builder-tools/pip/flatpak-pip-generator \
    --runtime='org.gnome.Sdk//49' \
    --requirements-file='requirements.txt' \
    --output=pypi-dependencies \
    --checker-data
