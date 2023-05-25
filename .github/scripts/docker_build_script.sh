export arch=${ARCHITECTURE}
export IMAGE_REPO=$IMAGE_REPO
export ANAX_IMAGE_VERSION=$ANAX_IMAGE_VERSION
export CSS_IMAGE_VERSION=$CSS_IMAGE_VERSION
export ESS_IMAGE_VERSION=$ESS_IMAGE_VERSION

# IMAGE_OVERRIDE tells Anax Makefile not to push images, we'll handle it here
export IMAGE_OVERRIDE="true"
if ${ARCHITECTURE == 'amd64'} || ${ARCHITECTURE == 'ppc64el'} || ${ARCHITECTURE == 'arm64'}; then
    make fss-package
fi
if ${ARCHITECTURE == 'amd64'}; then
    make agbot-package
fi
if ${ARCHITECTURE == 'arm64'}; then
    export USE_DOCKER_BUILDX=true
    # setup the QEMU simulator. You can then run `docker buildx ls` to see which platforms are available.
    docker run --rm --privileged $IMAGE_REPO/multiarch/qemu-user-static:latest --reset -p yes
fi

make anax-package 
make anax-k8s-package
make auto-upgrade-cronjob-k8s-package
echo "**************"
docker images
echo "**************"
                            