#!/bin/bash

if [[ -z "$FROM_REGISTRY" ]]; then
    echo "::error::Script Variable FROM_REGISTRY was not set"
    exit 1
fi
if [[ -z "$TO_REGISTRY" ]]; then
    echo "::error::Script Variable TO_REGISTRY was not set"
    exit 1
fi
if [[ -z "$FROM_TAG" ]]; then
    echo "::error::Script Variable FROM_TAG was not set"
    exit 1
fi
if [[ -z "$TO_TAGS" ]]; then
    echo "::error::Script Variable TO_TAGS was not set"
    exit 1
fi

images=('amd64_agbot' 'amd64_anax' 'amd64_anax_k8s' 'amd64_auto-upgrade-cronjob_k8s' 'amd64_cloud-sync-service' 'amd64_edge-sync-service' 'ppc64el_anax' 'ppc64el_anax_k8s' 'ppc64el_auto-upgrade-cronjob_k8s' 'ppc64el_edge-sync-service' 'arm64_anax' 'arm64_anax_k8s' 'arm64_auto-upgrade-cronjob_k8s' 'arm64_edge-sync-service')

for image in "${images[@]}"; do
    # docker pull ${FROM_REGISTRY}/${image}:${FROM_TAG}
    echo ${image}
    for tag in ${TO_TAGS[@]}; do
        echo ${tag}
        # docker tag ${FROM_REGISTRY}/${image}:${FROM_TAG} ${TO_REGISTRY}/${image}:${tag}
        # docker push ${TO_REGISTRY}/${image}:${tag}
    done
done