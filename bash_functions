# vim: set filetype=sh :

function ve() {
    # Use cwd for virtualenv name
    venv_name=${PWD##*/}

    # If this virtualenv is not active
    if [[ "$VIRTUAL_ENV" != "$PWD/.pyenv/$venv_name" ]]; then

        # Deactivate current virtualenv
        [[ $VIRTUAL_ENV ]] && deactivate

        # Create new virtualenv if needed
        [[ ! -f .pyenv/$venv_name/bin/activate ]] && rm -rf .pyenv && virtualenv .pyenv/$venv_name &> /dev/null

        # Activate virtualenv
        source .pyenv/$venv_name/bin/activate

    fi
    # Install requirements.txt if available
    [[ -f requirements.txt ]] && $(which pip) install -r requirements.txt &> /dev/null

    # Install dev_requirements.txt if available
    [[ -f dev_requirements.txt ]] && $(which pip) install -r dev_requirements.txt &> /dev/null

    if [[ -f monetization/requirements/apps.txt ]]; then
        $(which pip) install --upgrade setuptools
        $(which pip) install -r monetization/requirements/apps.txt 
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
