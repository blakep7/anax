#!/bin/bash

# Deal with Debian Package First
# Make the Dockerfile for the debs only tarball image
touch Dockerfile.debs.tarball
echo "FROM scratch" >> Dockerfile.debs.tarball
echo "ADD ./debs.tar.gz ." >> Dockerfile.debs.tarball

# Make debs tarball
tar -czvf debs.tar.gz ./pkg/deb/debs/*.deb

# Build docker image with only debs tarball
docker build --no-cache -t ${IMAGE_REPO}/${arch}_anax_debian:testing -f Dockerfile.debs.tarball .
docker images

# Push docker image
docker tag ${IMAGE_REPO}/${arch}_anax_debian:testing ${IMAGE_REPO}/${arch}_anax_debian:${ANAX_IMAGE_VERSION}

docker push ${IMAGE_REPO}/${arch}_anax_debian:testing
docker push ${IMAGE_REPO}/${arch}_anax_debian:${ANAX_IMAGE_VERSION}

# # Deal with RPM Package
# if [[ ${arch} == 'amd64' || ${arch} == 'ppc64el' ]]; then

# touch Dockerfile.rpm.tarball

# echo "FROM scratch" >> Dockerfile.rpm.tarball
# echo "ADD ./rpm.tar.gz ." >> Dockerfile.rpm.tarball

# tar -czvf rpm.tar.gz ../rpmbuild/RPMS/x86_64/*.rpm ..rpmbuild/RPMS/ppc64le/*.rpm

# docker build \
#     --no-cache \
#     -t $IMAGE_REPO/${arch}_anax_rpm:$ANAX_IMAGE_VERSION \
#     -f Dockerfile.rpm.tarball \
#     .

# docker push ${arch}_anax_rpm:$ANAX_IMAGE_VERSION

# fi