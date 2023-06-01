#!/bin/bash

# Deal with Debian Package First
# Make the Dockerfile for the debs only tarball image
touch Dockerfile.debs.tarball
echo "FROM scratch" >> Dockerfile.debs.tarball
echo "ADD ./debs.tar.gz ." >> Dockerfile.debs.tarball

# Make debs tarball
tar -czvf debs.tar.gz ./pkg/deb/debs/*.deb

# Build docker image with only debs tarball
docker build \
    --no-cache \
    -t ${IMAGE_REPO}/${arch}_anax_debian:testing \
    -f Dockerfile.debs.tarball \
    .

# Push docker image
docker tag ${IMAGE_REPO}/${arch}_anax_debian:testing ${IMAGE_REPO}/${arch}_anax_debian:${ANAX_IMAGE_VERSION}

docker push ${IMAGE_REPO}/${arch}_anax_debian:testing
docker push ${IMAGE_REPO}/${arch}_anax_debian:${ANAX_IMAGE_VERSION}

# Deal with RPM Package
if [[ ${arch} == 'amd64' || ${arch} == 'ppc64el' ]]; then

touch Dockerfile.rpm.tarball

echo "FROM scratch" >> Dockerfile.rpm.tarball
echo "ADD ./rpm.tar.gz ." >> Dockerfile.rpm.tarball

if [[ ${arch} == 'amd64' ]]; then
rpm_build_folder="x86_64"
fi
if [[ ${arch} == 'ppc64el' ]]; then
rpm_build_folder="ppc64le"
fi


tar -czvf rpm.tar.gz /home/runner/rpmbuild/RPMS/${rpm_build_folder}/*.rpm

docker build \
    --no-cache \
    -t $IMAGE_REPO/${arch}_anax_rpm:testing \
    -f Dockerfile.rpm.tarball \
    .

docker tag ${IMAGE_REPO}/${arch}_anax_rpm:testing ${IMAGE_REPO}/${arch}_anax_rpm:${ANAX_IMAGE_VERSION}

docker push ${IMAGE_REPO}/${arch}_anax_rpm:testing
docker push ${IMAGE_REPO}/${arch}_anax_rpm:${ANAX_IMAGE_VERSION}

fi