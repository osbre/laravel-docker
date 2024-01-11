#!/usr/bin/env bash

set -e


SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

phpVersions=(
    8.3
)

for phpVersion in ${phpVersions[@]}; do
    # Build Nginx + PHP-FPM flavors
    docker buildx build --platform=linux/arm64  \
      --build-arg PHP_VERSION="${phpVersion}" \
      -t "osbre/laravel:${phpVersion}" \
      -f "${SCRIPT_DIR}/src/Dockerfile" \
      "${SCRIPT_DIR}/src"

    # # Build Nginx Unit flavors
    # docker build \
    #   --build-arg PHP_VERSION="${phpVersion}" \
    #   -t "osbre/laravel:unit-${phpVersion}" \
    #   -f "${SCRIPT_DIR}/src/Dockerfile-unit" \
    #   "${SCRIPT_DIR}/src"
done

if [[ $# -gt 0 ]] && [[ $1 == "push" ]]; then
    for phpVersion in ${phpVersions[@]}; do
        docker push "osbre/laravel:${phpVersion}"
        # docker push "osbre/laravel:unit-${phpVersion}"
    done
fi
