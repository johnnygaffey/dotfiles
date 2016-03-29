# vim: set filetype=sh :

function cd(){
    if [[ $# -eq 0 ]]; then
        builtin cd $(git rev-parse --show-toplevel 2> /dev/null)
    else
        builtin cd "$@"
    fi
}

function getyn() {
    while true; do
        read -p "$1" yn
        case $yn in
            [Yy]*) ret=0; break;;
            [Nn]*) ret=1; break;;
            *) echo 'Please answer yes or no.';;
        esac
    done
    return $ret
}


function nve() {
    verbose=0
    redirect=/dev/null
    name=${0##*/}
    opts=$(getopt -o vh --long verbose,help -n "$name" -- "$@")
    if [[ $? != 0 ]]; then echo "option error" >&2; return 1; fi
    eval set -- "$opts"
    while true; do
        case "$1" in
            -v|--verbose)
                verbose=1
                redirect=/dev/stdout
                shift;;
            -h|--help)
                _ve_help
                return 1;;
            --)
                shift; break;;
            *)
                echo "Internal Error!"; return 1;;
        esac
    done

    ve_root=$(git rev-parse --show-toplevel 2> /dev/null)
    if [[ -s $ve_root/package.json ]]; then
        npm update &> $redirect && npm prune &> $redirect
    fi
}

function _ve_help() {
    echo "usage: ve [options]

optional args:

    -v|--verbose print to std out.
    -n|--no-sync do not use pip-sync
    -h|--help    priint this help."
}

function ve() {
    verbose=0
    allow_sync=1
    redirect=/dev/null
    name=${0##*/}
    opts=$(getopt -o vnh --long verbose,no-sync,help -n "$name" -- "$@")
    if [[ $? != 0 ]]; then echo "option error" >&2; return 1; fi
    eval set -- "$opts"
    while true; do
        case "$1" in
            -n|--no-sync)
                allow_sync=0
                shift;;
            -v|--verbose)
                verbose=1
                redirect=/dev/stdout
                shift;;
            -h|--help)
                _ve_help
                return 1;;
            --)
                shift; break;;
            *)
                echo "Internal Error!"; return 1;;
        esac
    done
    # Set root point for virtualenv creation to git top level
    ve_root=$(git rev-parse --show-toplevel 2> /dev/null)

    # Fall back to PWD if not in a git repo
    [[ ! $ve_root ]] && ve_root="$PWD"

    # Dirname of ve_root for name of virtualenv
    venv_name=${ve_root##*/}

    if [[ $1 ]]; then
        venv_name="${venv_name}_${1}"
    fi
    echo "Using virtualenv $venv_name" > $redirect

    # If this virtualenv is not active
    if [[ "$VIRTUAL_ENV" != "$ve_root/.pyenv/$venv_name" ]]; then
        # Deactivate current virtualenv
        [[ $VIRTUAL_ENV ]] && deactivate
        # Create new virtualenv if needed
        [[ ! -f $ve_root/.pyenv/$venv_name/bin/activate ]] && rm -rf $ve_root/.pyenv/$venv_name && virtualenv $ve_root/.pyenv/$venv_name &> $redirect
        # Activate virtualenv
        source $ve_root/.pyenv/$venv_name/bin/activate

    fi

    # Ensure using correct pip
    pip_bin=$(which pip)

    if [[ $allow_sync -eq 1 ]] && [[ -f $ve_root/requirements.in ]]; then
        # Ensure pip-tools is installed
        $pip_bin install pip-tools &> $redirect

        # Get all requirements that should be synced or reinstalled after sync
        sync_reqs="$ve_root/requirements.txt "
        re_install=""
        if [[ -f $ve_root/dev_requirements.in ]]; then
            sync_reqs+="$ve_root/dev_requirements.txt "
        elif [[ -f $ve_root/dev_requirements.txt ]]; then
            re_install+="-r $ve_root/dev_requirements.txt "
        fi
        if [[ -f $ve_root/doc_requirements.in ]]; then
            sync_reqs+="$ve_root/doc_requirements.txt "
        elif [[ -f $ve_root/doc_requirements.txt ]]; then
            re_install+="-r $ve_root/doc_requirements.txt "
        fi

        pip-sync $sync_reqs &> $redirect

        # Reinstall reqs that may have been uninstalled by sync
        [[ -n $re_install ]] && $pip_bin install $re_install &> $redirect
    else
        # Install dev_requirements.txt if available
        [[ -f $ve_root/dev_requirements.txt ]] && $pip_bin install -r $ve_root/dev_requirements.txt &> $redirect

        # Install requirements.txt if available
        [[ -f $ve_root/requirements.txt ]] && $pip_bin install -r $ve_root/requirements.txt &> $redirect

        # Install doc_requirements.txt if available
        [[ -f $ve_root/doc_requirements.txt ]] && $pip_bin install -r $ve_root/doc_requirements.txt &> $redirect
    fi
}

function ws () {
    if [[ $1 ]]; then
        cd ~/projects/$1
        [[ -f "$PWD/requirements.txt" ]] && ve -v
    fi
}

function vws () {
    if [[ $1 ]]; then
        cd ~/projects/$1
        if [[ -f "$PWD/vagrantfile" || -f "$PWD/Vagrantfile" ]]; then
            vagrant up && vagrant ssh -p
        fi
    fi
}

function rmpyc() {
    local path=$PWD
    if [[ $1 ]]; then
        path=$1
    fi
    find $path -not -path '*/\.*' -name "__pycache__" -exec rm -rf {} \; &> /dev/null
    find $path -not -path '*/\.*' -name "*.pyc" -exec rm -rf {} \;
}

function rmorig() {
    local path=$PWD
    if [[ $1 ]]; then
        path=$1
    fi
    find $path -not -path '*/\.*' -name "*.orig" -exec rm -rf {} \;
}

function djtest() {
    if [[ ! -x ./manage.py ]]; then
        echo "No executatble manage.py"
        return
    fi
    local input=$1; shift
    if [[ -f $input ]]; then
        test_files="$input"
    elif [[ -d $input ]]; then
        test_files=$(find $input -type f -name 'test*.py')
    fi
    for test_file in $test_files; do
        test_file_no_ext=${test_file%%.*}
        test_spec=${test_file_no_ext//\//.}
        echo $test_spec
        ./manage.py test $test_spec $@
        local ret=$?
        if [[ $ret -ne 0 ]]; then
            echo 'Test failed, skipping additional test files'
            return $ret
        fi
    done
}

function srt() {
    if [[ $# -eq 1 ]]; then
        STEAM_RUNTIME_TARGET_ARCH="$1"
    else
        STEAM_RUNTIME_TARGET_ARCH="amd64"
    fi
    if [[ "$(uname -m)" == "x86_64" ]]; then
        STEAM_RUNTIME_HOST_ARCH="amd64"
    else
        STEAM_RUNTIME_HOST_ARCH="i386"
    fi
    local runtime="$HOME/opt/steam-runtime-sdk_2013-09-05/runtime/"
    STEAM_RUNTIME_ROOT="$runtime/${STEAM_RUNTIME_TARGET_ARCH}"
    export STEAM_RUNTIME_HOST_ARCH STEAM_RUNTIME_TARGET_ARCH STEAM_RUNTIME_ROOT
    if [[ -z $NOSRT_PATH ]]; then
        export NOSRT_PATH="$PATH"
    fi
    PATH="$HOME/opt/steam-runtime-sdk_2013-09-05/bin:$PATH"
    if [[ -z $NOSRT_LD_LIBRARY_PATH ]]; then
        export NOSRT_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
    fi
    export LD_LIBRARY_PATH="$runtime/i386/lib/i386-linux-gnu:$runtime/i386/lib:$runtime/i386/usr/lib/i386-linux-gnu:$runtime/i386/usr/lib:$runtime/amd64/lib/x86_64-linux-gnu:$runtime/amd64/lib:$runtime/amd64/usr/lib/x86_64-linux-gnu:$runtime/amd64/usr/lib:$NOSRT_LD_LIBRARY_PATH"
    export SRT="enabled"
}

function usrt() {
    PATH="$NOSRT_PATH"
    LD_LIBRARY_PATH="$NOSRT_LD_LIBRARY_PATH"
    export PATH
    unset STEAM_RUNTIME_HOST_ARCH STEAM_RUNTIME_TARGET_ARCH STEAM_RUNTIME_ROOT NOSRT_PATH SRT NOSRT_LD_LIBRARY_PATH
}
