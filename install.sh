# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Install utils
brew install curl
brew install coreutils
brew install binutils
brew install diffutils
brew install jq
brew install ed --with-default-names
brew install findutils --with-default-names
brew install gawk
brew install gnu-indent --with-default-names
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-which --with-default-names
brew install gnutls
brew install grep --with-default-names
brew install gzip
brew install screen
brew install watch
brew install wdiff --with-gettext
brew install wget
brew install ag

## Install Python stuff
brew install poetry
brew install pyenv

## Java/Typescript
curl -fsSL https://fnm.vercel.app/install | bash
