##
#   Load modules
##

# Export all variables so bash wont freak out of undefined variables
source $P_ROOT/build/toolset/shell/modules/variables.sh

# Load up msg types
source $P_ROOT/build/toolset/shell/modules/msg_types.sh
loaded "Message types"

# Check for root user before making tmp dir's
if [[ $EUID -ne 0 ]]; then
        msg_debug "User isn't root, thats good"
    else
        msg_error "User is root and this isn't allowed"
fi

# Load tmp handler and start it
# If we add clean tmp too then docker env wont have args that were passed here before
# So only clean if error is catched by error-handler
source $P_ROOT/build/toolset/shell/modules/tmp_main.sh
create_tmp
loaded "Temp manager"

# We need build lock function so dev/user cant compile 2 diff pkg's at the same time
# Would be ok in non-docker env but issue handler may kill lock file if error happens ( so lets run it here )
source $P_ROOT/build/toolset/shell/modules/lockup.sh
check_and_setup_lock
loaded "Lockup functions"

# Load issue handler and start it straight away
source $P_ROOT/build/toolset/shell/modules/issue_handler.sh
#start_logging # TODO: Dont cancel out error messages in user/dev cli -->
# ( causes invisible sudo prompt and etc that can cause more issues for docker )
trap interrupt_handle SIGINT INT
trap tmp_err_handle ERR
#trap err_handle HUP TERM QUIT ERR # TODO: Uncomment if start_logging is fixed
loaded "Issue handler"

# Load up core functions
source $P_ROOT/build/toolset/shell/modules/main_func.sh
loaded "Main functions"

# Feed arch manager for different arch based builds ( WIP )
source $P_ROOT/build/toolset/shell/modules/arch_manager.sh
if [ -f $TOOL_TEMP/is_arch ]; then
    export P_ARCH=$(get_target_arch) # As we may be runned inside container by -d flag
else # Otherwise set up arch flags
    set_arch
    export P_ARCH=$(get_target_arch)
fi
loaded "Arch manager"

# Load up package src location finder
source $P_ROOT/build/toolset/shell/modules/pkg_location.sh
loaded "Pkg location"

# Load up dependency resolver
source $P_ROOT/build/toolset/shell/modules/dep_resolver.sh
loaded "Pkg resolver"

# Feed our script how to build pkg's
source $P_ROOT/build/toolset/shell/modules/pkg_build.sh
loaded "Pkg builder"

# Feed it again to clean leftovers on pkg's
source $P_ROOT/build/toolset/shell/modules/pkg_clean.sh
loaded "Pkg cleaner"

# Feed docker instructions for setup
loading "Docker functions..."
source $P_ROOT/build/toolset/shell/modules/docker_modules.sh
loaded "Docker functions"

loading "Repo update system functions"
source $P_ROOT/build/toolset/shell/modules/repo_modules.sh
loaded "Repo update system functions"

# Feed the scriptlet main arch
export ARCH=$(cat $TOOL_TEMP/is_arch)

# Feed mkiso creator module
source $P_ROOT/build/toolset/shell/modules/mk_iso.sh
loaded "ISO modules"

# Feed mkiso creator module
source $P_ROOT/build/toolset/dialog/dialog_manager.sh
loaded "Dialog manager"

msg_spacer
