# Makes and pushes arch_cloud-sync-service and arch_edge-sync-service images
if [[ ${arch} == 'amd64' || ${arch} == 'ppc64el' || ${arch} == 'arm64' ]]; then
    make fss-package
fi

# Makes and pushes ?
if [[ ${arch} == 'amd64' ]]; then
    make agbot-package
fi

# What does this do?
if [[ ${arch} == 'arm64' ]]; then
    export USE_DOCKER_BUILDX=true
    # setup the QEMU simulator. You can then run `docker buildx ls` to see which platforms are available.
    docker run --rm --privileged $IMAGE_REPO/multiarch/qemu-user-static:latest --reset -p yes
fi


make anax-package                       # Makes and pushes arch_anax
make anax-k8s-package                   # Makes and pushes arch_anax_k8s
make auto-upgrade-cronjob-k8s-package   # Makes and pushes arch_auto-upgrade-cronjob-k8s

echo "**************"
docker images
echo "**************" 