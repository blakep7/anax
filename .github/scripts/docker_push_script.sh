# Names of the images created for each architecture
if [[ ${arch} == 'amd64' ]]; then
    images=('amd64_agbot' 'amd64_anax' 'amd64_anax_k8s' 'amd64_auto-upgrade-cronjob_k8s' 'amd64_cloud-sync-service' 'amd64_edge-sync-service')
elif [[ ${arch} == 'ppc64el' ]]; then
    images=('ppc64el_anax' 'ppc64el_anax_k8s' 'ppc64el_auto-upgrade-cronjob_k8s' 'ppc64el_edge-sync-service')
elif [[ ${arch} == 'arm64' ]]; then
    images=('arm64_anax' 'arm64_anax_k8s' 'arm64_auto-upgrade-cronjob_k8s' 'arm64_edge-sync-service')
fi

# Push those images
for image in "${images[@]}"; do

    if [[ ${image} == *"cloud-sync-service"* ]]; then
        VERSION=${CSS_IMAGE_VERSION}
    elif [[ ${image} == *"edge-sync-service"* ]]; then
        VERSION=${ESS_IMAGE_VERSION}
    else
        VERSION=${ANAX_IMAGE_VERSION}
    fi

    if [[ ${GITHUB_REF} == 'refs/heads/master' ]]; then
        docker push $${image}:testing
    fi

    docker tag ${image}:testing ${image}:${VERSION}
    docker push ${image}:${VERSION}

done