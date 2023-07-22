##
# This module contains static functions for other docker modules
##

# Start the container
docker_start() {
    msg_debug "DOCKER: Executed bash shell"
    sudo docker exec --interactive --tty $1 bash
}

# developer user bash shell
docker_user_start() {
    msg_debug "DOCKER: Executed bash shell"
    sudo docker exec --interactive --tty $1 su developer -c bash
}

docker_start_container() {
    msg_debug "Starting container: $1"
    sudo docker start $1 &> /dev/null
}

docker_stop_container() {
    msg_debug "Stopping container: $1"
    sudo docker stop $1 &> /dev/null
}

docker_export() {
    docker_stop_container $DOCKER_BASE_CONTAINER_NAME

    mkdir -p $TOOL_TEMP/docker_container

    message "Exporting docker container $1 for $2"
    sudo rm -f "$TOOL_TEMP/docker_container/$2.tar"

    sleep 2

    sudo docker export "$1" > "$TOOL_TEMP/docker_container/$2.tar"
}

# Here we will take care of the docker retarted way to
# import file as image -> make container of image -> delete the image
# Like why... ( let me just import container file as container and not the image )
docker_import() {
    message "Importing container as image: $DOCKER_IMAGE_NAME_TEMP"
    cat "$TOOL_TEMP/docker_container/$1.tar" | sudo docker import - $DOCKER_IMAGE_NAME_TEMP

    message "Creating container from temporary image"
    sudo docker container create \
    --name $1 \
    --volume $P_ROOT:$DOCKER_USER_FOLDER/$TOOL_MAIN_NAME \
    --tty \
    $DOCKER_IMAGE_NAME_TEMP /bin/bash
    message "Build container created"

    message "Removing temporary image"
    docker_remove_image $DOCKER_IMAGE_NAME_TEMP
}

docker_remove_container() {
    docker_stop_container $1
    sudo docker container rm -f $1
}

docker_remove_image() {
    docker_stop_container $1
    sudo docker image rm -f $1
}

# ROOT run cmd
docker_run_cmd() {
    docker_start_container $1

    msg_debug "DOCKER: $2"
    sudo docker exec --interactive --tty $1 $2
}

# developer run cmd
docker_user_run_cmd() {
    docker_start_container $1

    msg_debug "DOCKER: $2"
    sudo docker exec --interactive --tty $1 su developer -c "$2"
}

docker_copy_pkgmanager_conf() {
    # Copy over local package manager.conf ( specific for arch)
    if [ "${ARCH}" = "x86_64"  ]; then
        # AMD64 config
        docker_run_cmd $1 "cp -f /home/developer/$TOOL_MAIN_NAME/build/docker/developing/${PACKAGE_MANAGER}/amd64_${PACKAGE_MANAGER}.conf /etc/${PACKAGE_MANAGER}.conf"
    elif [ "${ARCH}" = "aarch64"  ]; then
        # ARM64 config
        docker_run_cmd $1 "cp -f /home/developer/$TOOL_MAIN_NAME/build/docker/developing/${PACKAGE_MANAGER}/arm64_${PACKAGE_MANAGER}.conf /etc/${PACKAGE_MANAGER}.conf"
    fi
}
