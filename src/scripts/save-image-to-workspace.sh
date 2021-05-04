#!/usr/bin/env bash

main() {
    for i in PARAM_IMAGE_FILE,image-file PARAM_IMAGE_NAME,image-name ; do 
        KEY=${i%,*};
        VAL=${i#*,};

        if [[ -z "${!KEY}" ]]; then
            echo "param ${VAL} is required!"
            exit 1
        fi
    done

    local image_dir="${IMAGE_DIR:-images}"
    echo "> Ensuring image dir '${image_dir}' exists..."
    mkdir -p "$image_dir"
    
    local full_image_path="${image_dir}/${PARAM_IMAGE_FILE}"
    echo "> Exporting image '${PARAM_IMAGE_NAME}' as '${full_image_path}'..."
    docker save -o "${full_image_path}" ${PARAM_IMAGE_NAME}
    echo "> Saved as '${full_image_path}'..."
}

if [[ -n $(echo "$0" | sed 's/.*_test$//;s/.*_test\.sh$//') ]]; then
    main "$@"
fi