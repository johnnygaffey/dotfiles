# vim: set filetype=sh :

function ve() {
    # Use cwd for virtualenv name
    git_top_level=$(git rev-parse --show-toplevel 2> /dev/null)
    [[ ! $git_top_level ]] && git_top_level=$PWD

    venv_name=${git_top_level##*/}
    # If this virtualenv is not active
    if [[ "$VIRTUAL_ENV" != "$git_top_level/.pyenv/$venv_name" ]]; then

        # Deactivate current virtualenv
        [[ $VIRTUAL_ENV ]] && deactivate

        # Create new virtualenv if needed
        [[ ! -f $git_top_level/.pyenv/$venv_name/bin/activate ]] && rm -rf $git_top_level/.pyenv && virtualenv $git_top_level/.pyenv/$venv_name &> /dev/null

        # Activate virtualenv
        source $git_top_level/.pyenv/$venv_name/bin/activate

    fi
    # Install requirements.txt if available
    [[ -f $git_top_level/requirements.txt ]] && $(which pip) install -r $git_top_level/requirements.txt

    # Install dev_requirements.txt if available
    [[ -f $git_top_level/dev_requirements.txt ]] && $(which pip) install -r $git_top_level/dev_requirements.txt

    if [[ -f $git_top_level/monetization/requirements/apps.txt ]]; then
        $(which pip) install --upgrade setuptools
        $(which pip) install -r $git_top_level/monetization/requirements/apps.txt 
    fi
}

function rmpyc() {
    find . -name "*.pyc" -exec rm -rf {} \;
}

function cd(){
    if [[ $# -eq 0 ]]; then
        builtin cd $(git rev-parse --show-toplevel 2> /dev/null)
    else
        builtin cd "$@"
    fi
}
