#!/usr/bin/env bash

./flatpak-builder-tools/pip/flatpak-pip-generator --runtime='org.gnome.Sdk//48' --requirements-file='requirements.txt' --output pypi-dependencies
