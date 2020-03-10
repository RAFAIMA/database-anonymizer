#!/usr/bin/env bash

set -ex

echo "Installing extension"

if [ "$TRAVIS_PHP_VERSION" == "7.3" ] || [ "$TRAVIS_PHP_VERSION" == "nightly" ] ; then
  pecl install sqlsrv-5.7.0preview
else
  pecl install sqlsrv
fi
