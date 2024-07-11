#!/bash

# test if user have sudo permission
if sudo -v >/dev/null 2>&1; then
    echo "Install homebrew globally"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Install homebrew locally"
    homebrew_prefix="$HOME"/.homebrew
    mkdir "$homebrew_prefix" && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components 1 -C "$homebrew_prefix"
    eval "$("$homebrew_prefix"/bin/brew shellenv)"
fi