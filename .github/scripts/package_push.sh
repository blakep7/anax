#!/bin/bash

# Make temp Dockerfiles
touch Dockerfile.debs.tarball
echo "FROM scratch" >> Dockerfile.debs.tarball
echo "ADD ./debs.tar.gz" >> Dockerfile.debs.tarball

touch Dockerfile.rpm.tarball
echo "FROM scratch" >> Dockerfile.rpm.tarball
echo "ADD ./rpm.tar.gz" >> Dockerfile.rpm.tarball

# Make tarballs
echo | pwd
tar -czvf debs.tar.gz ./pkg/deb/debs/*.deb
tar -czvf rpm.tar.gz ../rpmbuild/RPMS/x86_64/*.rpm ..rpmbuild/RPMS/ppc64le/*.rpm

ls -la

# Build and push images
docker build \
    --no-cache \
    -t $IMAGE_REPO/anax_debian:$ANAX_IMAGE_VERSION \
    -f Dockerfile.debs.tarball \
    .
    
docker build \
    --no-cache \
    -t $IMAGE_REPO/anax_rpm:$ANAX_IMAGE_VERSION \
    -f Dockerfile.rpm.tarball \
    .

docker push anax_debian:$ANAX_IMAGE_VERSION
docker push anax_rpm:$ANAX_IMAGE_VERSION