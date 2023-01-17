# SPDX-License-Identifier: LGPL-3.0-or-later
# Copyright (C) 2022 Intel Corporation

# exit when any command fails
set -e
MY_PATH=$(dirname "$0")
pushd ${MY_PATH}

export MARIADB_BASE_IMAGE=mariadb-base

dd if=/dev/urandom bs=16 count=1 > encryption_key


if [ ! -d /tmp/encrypted-data ]; then
    mkdir -p /tmp/mariadb-data
    cp -r /var/lib/mysql/* /tmp/mariadb-data
    gramine-sgx-pf-crypt encrypt -w encryption_key -i /tmp/mariadb-data -o /var/lib/mysql
fi

docker build \
    -f Dockerfile \
    -t ${MARIADB_BASE_IMAGE} .

insecure_key=$(xxd -p encryption_key)
sed -i "/fs.insecure__keys.default*/c fs.insecure__keys.default = \"$insecure_key\"" mariadb.manifest

popd

echo -e '\n\nCreated base image `'$MARIADB_BASE_IMAGE'`.'
