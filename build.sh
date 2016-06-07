#!/bin/bash
_grafana_version=$1
_grafana_tag=$2
_release_build=false

ARCH=$( uname -m )
if [ -z "${_grafana_version}" ]; then
	source GRAFANA_VERSION
	_grafana_version=$GRAFANA_VERSION
	_grafana_tag=$GRAFANA_VERSION
	_release_build=true
fi

echo "GRAFANA_VERSION: ${_grafana_version}"
echo "DOCKER TAG: ${_grafana_tag}"
echo "RELEASE BUILD: ${_release_build}"

if [ ${ARCH} == "x86_64" ]
then
	docker build --build-arg GRAFANA_VERSION=${_grafana_version} \
		--tag "grafana/grafana:${_grafana_tag}" -f Dockerfile .
elif [ ${ARCH} == "ppc64le" ]
then
	docker build --tag "grafana/grafana:${_grafana_tag}" -f Dockerfile.ppc64le .
fi

if [ $_release_build == true ]; then
	if [ ${ARCH} == "x86_64" ]; then
		docker build --build-arg GRAFANA_VERSION=${_grafana_version} \
			--tag "grafana/grafana:latest" -f Dockerfile .
	elif [ ${ARCH} == "ppc64le" ]; then
		docker build --tag "grafana/grafana:latest" -f Dockerfile.ppc64le .
	fi
fi
