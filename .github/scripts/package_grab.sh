#!/bin/bash

if [[ -z "$FROM_REGISTRY" ]]; then
    echo "::error::Script 'package_grab.sh' Variable FROM_REGISTRY was not set"
    exit 1
fi
if [[ -z "$FROM_TAG" ]]; then
    echo "::error::Script 'package_grab.sh' Variable FROM_TAG was not set"
    exit 1
fi

mkdir -p $RUNNER_TEMP/release_files/upload
cd $RUNNER_TEMP/release_files

DEBArchitectures=('amd64' 'arm64' 'armhf' 'ppc64el')
RPMArchitectures=('amd64' 'ppc64el')
MACArchitectures=('amd64')

for arch in "${DEBArchitectures[@]}"; do
    docker pull ${FROM_REGISTRY}/${arch}_anax_debian:${FROM_TAG}
    imageID=\$(docker create --name temp_image_grab ${FROM_REGISTRY}/${arch}_anax_debian:${FROM_TAG})
    docker cp ${imageID}:debs .
    cp ./debs/* .
    rm -rf ./debs
    docker container rm ${imageID}
    docker image rm ${FROM_REGISTRY}/${arch}_anax_debian:${FROM_TAG}

    tar -czvf upload/horizon-agent-linux-deb-${arch}.tar.gz *.deb
    rm -rf *.deb
done

for arch in "${RPMArchitectures[@]}"; do
    docker pull ${FROM_REGISTRY}/${arch}_anax_rpm:${FROM_TAG}
    imageID=\$(docker create --name temp_image_grab ${FROM_REGISTRY}/${arch}_anax_rpm:${FROM_TAG})
    docker cp ${imageID}:RPMS .
    cp ./RPMS/* .
    rm -rf ./RPMS
    docker container rm ${imageID}
    docker image rm ${FROM_REGISTRY}/${arch}_anax_rpm:${FROM_TAG}

    if [[ ${arch} == 'amd64' ]]; then
        uploadArch='x86_64'
    elif [[ ${arch} == 'ppc64el' ]]; then
        uploadArch='ppc64le'
    fi 

    tar -czvf upload/horizon-agent-linux-rpm-${uploadArch}.tar.gz *.rpm
    rm -rf *.rpm
done

for arch in "${MACArchitectures[@]}"; do
    docker pull ${FROM_REGISTRY}/${arch}_anax_macpkg:${FROM_TAG}
    imageID=\$(docker create --name temp_image_grab ${FROM_REGISTRY}/${arch}_anax_macpkg:${FROM_TAG})
    docker cp ${imageID}:macs .
    cp ./macs/* .
    rm -rf ./macs
    docker container rm ${imageID}
    docker image rm ${FROM_REGISTRY}/${arch}_anax_macpkg:${FROM_TAG}

    if [[ ${arch} == 'amd64' ]]; then
        uploadArch='x86_64'
    fi

    tar -czvf upload/horizon-agent-macos-pkg-${uploadArch}.tar.gz horizon*
    rm -rf horizon*
done

mkdir cluster_files
cd cluster_files
cp ${GITHUB_WORKSPACE}/agent-install/agent-uninstall.sh .
cp ${GITHUB_WORKSPACE}/agent-install/k8s/* .
tar -czvf ../upload/horizon-agent-edge-cluster-files.tar.gz *.*
cd ..
