#!/usr/bin/env bash

testParamImageFileRequired() {
    local results="$(PARAM_IMAGE_NAME='name' main)" code="$?"
    assertEquals 1 $code
    
    echo -e "RESULTS:\n${results}"
    assertContains "$results" "param image-file is required!"
}

testParamImageNameRequired() {
    local results="$(PARAM_IMAGE_FILE='file' main)" code="$?"
    assertEquals 1 $code
    
    echo -e "RESULTS:\n${results}"
    assertContains "$results" "param image-name is required!"
}

testImageFileIsCreated() {
    cat << EOF > ${SHUNIT_TMPDIR}/Dockerfile
FROM busybox AS build-env
RUN touch /empty

FROM scratch
COPY --from=build-env /empty /.emptyfile
EOF

    local image_name="test$RANDOM"
    echo "> Creating docker image..."
    docker build -t ${image_name} ${SHUNIT_TMPDIR}

    local image_dir="${SHUNIT_TMPDIR}/images"
    local results="$(IMAGE_DIR=$image_dir PARAM_IMAGE_NAME=$image_name PARAM_IMAGE_FILE='image.img' main)" code="$?"
    assertEquals 0 $code
    echo -e "RESULTS:\n${results}"

    ls -al $image_dir/image.img

    assertContains "$results" "$image_dir"
    assertContains "$results" "$image_name"
}

oneTimeSetUp() {
    echo "> Loading script under test..."
    source './../scripts/save-image-to-workspace.sh'
}

# Load shUnit2
. ./shunit2