#!/usr/bin/env bash

name=${0##*/}

function print_help() {
    echo "usage: $name [options]

optional args:

    -p|--pretend  print what install will do without doing it.
    -b|--bundle   run :BundleUpdate after install.
    -r|--rvm      install rvm as well.
    -h|--help     print this help."
}

pretend=0
bundleupdate=0
rvm=0
OPTS=$(getopt -o pbhr --long pretend,bundle,rvm,help -n "$name" -- "$@")

if [[ $? != 0 ]]; then echo "option error" >&2; exit 1; fi

eval set -- "$OPTS"

while true; do
    case "$1" in
        -p|--pretend)
            pretend=1
            shift;;
        -b|--bundle)
            bundleupdate=1
            shift;;
        -r|--rvm)
            rvm=1
            shift;;
        -h|--help)
            print_help
            exit 0
            ;;
        --)
            shift; break;;
        *)
            echo "Internal error!"; exit 1;;
    esac
done

pushd $(dirname $0) &> /dev/null

for dot in $(ls); do
    if [[ ! $dot == "README.rst" ]] && [[ ! $dot == "install.sh" ]] && [[ ! $dot == "terminfo" ]]; then
        target="$HOME/.$dot"

        if [[ $pretend -eq 1 ]]; then
            echo "Would set $dot"
        else
            # Make a .bak of a file or dir
            if [[ ! -h $target ]]; then
                if [[ -d $target ]] || [[ -f $target ]]; then
                    mv $target $target.bak
                fi
            fi

            echo "Setting $dot"
            ln -sf "$PWD/$dot" "$target"
        fi
    fi
done

# Terminfo if needed
if [[ -f /usr/share/terminfo/r/rxvt-unicode ]] && [[ -f /usr/share/terminfo/r/rxvt-unicode-256color ]]; then
    # No need for local terminfo, lets use the system one
    if [[ -d "$HOME/.terminfo" ]]; then
        if [[ $pretend -eq 1 ]]; then
            echo "Would remove $HOME/.terminfo"
        else
            echo "Remove $HOME/.terminfo"
            rm -rf "$HOME/.terminfo"
        fi
    fi
else
    dot="terminfo"
    target="$HOME/.$dot"
    if [[ $pretend -eq 1 ]]; then
        echo "Would set $dot"
    else
        # Make a .bak of a file or dir
        if [[ ! -h $target ]]; then
            if [[ -d $target ]] || [[ -f $target ]]; then
                mv $target $target.bak
            fi
        fi

        echo "Setting $dot"
        ln -sf "$PWD/$dot" "$target"
    fi
fi

# Cleanup
rm -rf "$HOME/.dzen/dzen"
rm -rf "$HOME/.terminfo/terminfo"

if [[ $pretend -eq 1 ]]; then
    echo "Would make dirs '$HOME/.vim/{bundle,swap,backup,undo}"
else
    mkdir -p "$HOME/.vim/"{bundle,swap,backup,undo}
fi

if [[ ! -d "$HOME/.bash-git-prompt" ]]; then
    git clone https://github.com/magicmonty/bash-git-prompt.git "$HOME/.bash-git-prompt"
fi

if [[ ! -d "$HOME/.vim/bundle/vundle" ]]; then
    if [[ $pretend -eq 1 ]]; then
        echo "Would install vundle"
    else
        echo "Installing vundle"
        git clone https://github.com/gmarik/vundle.git "$HOME/.vim/bundle/vundle" &> /dev/null
        if [[ $bundleupdate -eq 0 ]]; then
            echo "Now start vim and run:"
            echo ":BundleInstall"
        fi
    fi
else
    echo "Vundle already installed"
fi

if [[ $bundleupdate -eq 1 ]]; then
    if [[ $pretend -eq 1 ]]; then
        echo "Would run :BundleUpdate"
    else
        echo "Running bundle update"
        vim -c BundleUpdate -c qa &> /dev/null
    fi
fi

if [[ $rvm -eq 1 ]]; then
    if [[ $pretend -eq 1 ]]; then
        echo "Would install rvm"
    else
        echo "Installing rvm"
        curl -sSL https://get.rvm.io | bash -s -- stable --ruby --ignore-dotfiles
    fi
fi

popd &> /dev/null
