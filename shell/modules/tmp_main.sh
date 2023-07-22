create_tmp() {
    # Create tmp folder
    mkdir -p $TOOL_TEMP
}

clean_tmp() {
    # Clean tmp
    if [ -f $TOOL_TEMP/.keep_tmp ]; then
        msg_debug "Skipping tmp cleaning"
    else
        sudo rm -rf $TOOL_TEMP
    fi
}

force_clean_tmp() {
    sudo rm -rf $TOOL_TEMP
}
