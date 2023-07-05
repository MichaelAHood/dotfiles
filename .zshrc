#---------------------------------------------------------------------------------------------------------------------------------------
#
#   Description: File used to hold Bash configuration, aliases, functions, completions, etc...
#   Sourced from: https://gist.github.com/kjbrum/77b7af04191267b053e9

#   Sections:
#   1.  ENVIRONMENT SETUP
#   2.  MAKE TERMINAL BETTER
#   3.  FOLDER MANAGEMENT
#   4.  MISC ALIAS'
#   5.  GIT SHORTCUTS
#   6.  OS X COMMANDS
#   7.  TAB COMPLETION
#
#---------------------------------------------------------------------------------------------------------------------------------------


#---------------------------------------------------------------------------------------------------------------------------------------
#   1.  ENVIRONMENT SETUP
#---------------------------------------------------------------------------------------------------------------------------------------


# Setup global variables
# Github
export GITHUB_TOKEN='xxx'


# Get Git branch of current directory
git_branch () {
    if git rev-parse --git-dir >/dev/null 2>&1
        # then echo -e "" git:\($(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')\)
        then echo -e "" \[$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')\]
    else
        echo ""
    fi
}

# Set a specific color for the status of the Git repo
git_color() {
    local STATUS=`git status 2>&1`
    if [[ "$STATUS" == *'Not a git repository'* ]]
        then echo "" # nothing
    else
        if [[ "$STATUS" != *'working tree clean'* ]]
            then echo -e '\033[0;31m' # red if need to commit
        else
            if [[ "$STATUS" == *'Your branch is ahead'* ]]
                then echo -e '\033[0;33m' # yellow if need to push
            else
                echo -e '\033[0;32m' # else green
            fi
        fi
    fi
}

# Add SSH keys to the ssh-agent
# https://developer.github.com/v3/guides/using-ssh-agent-forwarding/
# https://confluence.atlassian.com/bitbucket/configure-multiple-ssh-identities-for-gitbash-mac-osx-linux-271943168.html
if [ ! $(ssh-add -l | grep -o -e id_rsa) ]; then
    ssh-add "$HOME/.ssh/id_rsa" > /dev/null 2>&1
fi

# Modify the prompt >"
PROMPT="%{%F{green}%}%n%{%f%}@%{%F{blue}%}localbox %{%F{yellow}%}%~ %{>%f%}% "

# Set our Homebrew Cask application directory
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Setup our $PATH
# export PATH=$PATH:/usr/local/opt/php@7.1/bin
# export PATH=$PATH:/usr/local/opt/php@7.1/sbin
# export PATH=$PATH:/usr/local/bin
# export PATH=$PATH:/usr/local/sbin
# export PATH=$PATH:$HOME/bin
# export PATH=$PATH:$HOME/.composer/vendor/bin

# Add Github script projects
# for i in $(ls -d $HOME/scripts/*); do
#     PATH=$PATH:$i
# done

# Set default editor
export EDITOR=code

# Tell npm to compile and install all your native addons in parallel and not sequentially
export JOBS=max

# Bump the maximum number of file descriptors you can have open
ulimit -n 10240

# Stuff to make wp-install.sh work correctly
# http://stackoverflow.com/questions/19242275/re-error-illegal-byte-sequence-on-mac-os-x
# export LC_CTYPE=C
# # export LANG=C
# export LC_ALL="en_US.UTF-8"
# export LANG="en_US.UTF-8"

# Print the date
date '+%H:%M:%S %p / %A / %B %-d, %Y'


#---------------------------------------------------------------------------------------------------------------------------------------
#   2.  MAKE TERMINAL BETTER
#---------------------------------------------------------------------------------------------------------------------------------------

# Misc Commands
alias resource='source ~/.zshrc'                                         # Source bash_profile
alias ll='ls -alh'                                                              # List files
alias llr='ls -alhr'                                                            # List files (reverse)
alias lls='ls -alhS'                                                            # List files by size
alias llsr='ls -alhSr'                                                          # List files by size (reverse)
alias lld='ls -alht'                                                            # List files by date
alias lldr='ls -alhtr'                                                          # List files by date (reverse)
alias lldc='ls -alhtU'                                                          # List files by date created
alias lldcr='ls -alhtUr'                                                        # List files by date created (reverse)
h() { history | grep "$1"; }                                                    # Shorthand for `history` with added grepping
alias perm="stat -f '%Lp'"                                                      # View the permissions of a file/dir as a number
alias mkdir='mkdir -pv'                                                         # Make parent directories if needed
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"             # List the file structure of the current directory
alias getsshkey="pbcopy < ~/.ssh/id_rsa.pub"                                    # Copy SSH key to the keyboard
bash-as() { sudo -u $1 /bin/bash; }                                             # Run a bash shell as another user
disk-usage() { du -hs "$@" | sort -nr; }                                        # List disk usage of all the files in a directory (use -hr to sort on server)
dirdiff() { diff -u <( ls "$1" | sort)  <( ls "$2" | sort ); }                  # Compare the contents of 2 directories


# Editing common files
alias edithosts='code /etc/hosts'                                               # Edit hosts file
alias editbash='code ~/.bash_profile'
alias editzsh='code ~/.zshrc'                                       # Edit bash profile
alias editsshconf='code ~/.ssh/config'
alias editvsc='code ~/Library/Application\ Support/Code/User/settings.json'                                     # Edit ssh config file

# Navigation Shortcuts
alias ..='cl ..'
alias ...='cl ../../'
alias ....='cl ../../../'
alias .....='cl ../../../../'
alias ......='cl ../../../../'
alias .......='cl ../../../../../'
alias ........='cl ../../../../../../'
alias home='clear && cd ~ && ll'                                                # Home directory
alias downloads='clear && cd ~/Downloads && ll'                                 # Downloads directory
cs() { cd "$@" &&  ls; }                                                        # Enter directory and list contents with ls
cl() { cd "$@" && ll; }                                                         # Enter directory and list contents with ll
site() { clear && cl $HOME/sites/"$@"; }                                        # Access site folders easier
# wp-theme() { clear && cl $HOME/sites/"$@"/content/themes/"$@"; }                # Access a site theme folders easier
# project() { clear && cl $HOME/projects/"$@"; }                                  # Access project folders easier
# email() { clear && cl $HOME/projects/emails/"$@"; }                             # Access email folders easier


#---------------------------------------------------------------------------------------------------------------------------------------
#   3.  FOLDER MANAGEMENT
#---------------------------------------------------------------------------------------------------------------------------------------

# Clear a directory
cleardir() {
    while true; do
        read -ep 'Completely clear current directory? [y/N] ' response
        case $response in
            [Yy]* )
                bash -c 'rm -rfv ./*'
                bash -c 'rm -rfv ./.*'
                break;;
            * )
                echo 'Skipped clearing the directory...'
                break;;
        esac
    done
}

mktar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }    # Creates a *.tar.gz archive of a file or folder
mkzip() { zip -r "${1%%/}.zip" "$1" ; }               # Create a *.zip archive of a file or folder


#---------------------------------------------------------------------------------------------------------------------------------------
#   4.  MISC ALIAS'
#---------------------------------------------------------------------------------------------------------------------------------------

# Homebrew
alias brewup='brew update && brew upgrade && brew cleanup'
# alias brewup-cask='brew update && brew upgrade && brew cleanup && brew cask outdated | awk "{print $1}" | xargs brew cask reinstall && brew cask cleanup'

# Hyper
# alias update-hyper-plugins='cd ~/.hyper_plugins && rm -rf node_modules && rm package-lock.json && npm install && cd -'

# browser-sync
# alias bs='browser-sync'    # Browser Sync shorthand
# bsdev() { browser-sync start --server --files '**/*.css, **/*.js, **/*.php, **/*.html, **/*.mustache, **/*.twig' --tunnel 'kjbrum'; }    # Start local project server
# bsproxy() { browser-sync start --proxy "$1" --files '**/*.css, **/*.js, **/*.php, **/*.html, **/*.mustache, **/*.twig' --tunnel 'kjbrum'; }    # Proxy a local project

# Grunt
alias gw='grunt watch'    # Start the Grunt "watch" task
alias gbs='grunt bs'      # Start the Grunt "browser-sync" task

# Copy local files to a remote server
dir-to-remote() { rsync -avz . $1; }

# 1Password
# 1pass() { eval $(op signin "$1"); }

# Trash
alias t='trash'

# New WordPress site
# new-wp() {
#     cp -r ~/projects/sf-wp-deploy ~/sites/"$@"
#     cd ~/sites/"$@"
#     . config/prepare.sh
# }

# npm
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'

# Homebrew
alias bci='brew cask install'
alias bcun='brew cask uninstall'
alias bcup='brew cask reinstall'

# Docker
## IronBank login
ironbanklogin() {
    secret=$(op item get 'IronBank' --fields 'cli secret')
    echo $secret | docker login registry1.dso.mil -u mhoodspearai --password-stdin
}




# # Compass
# alias cw='compass watch'

# # # Create a new Foundation for Emails project
# # alias ffe='foundation new --framework emails'

# # Run last command with sudo
# alias fuck='sudo $(fc -ln -1)'

# # Switching shells
# alias shell-to-zsh='chsh -s $(which zsh)'
# alias shell-to-bash='chsh -s $(which bash)'

# # Bundle shortcuts
# alias bec='bundle exec cap'
# alias becs='bundle exec cap staging'
# alias becp='bundle exec cap production'

# cap-staging() {
#     while true; do
#         read -ep 'Pull or push STAGING site? [pull/push] ' response
#         case $response in
#             pull )
#                 while true; do
#                     read -ep 'Are you sure you want to PULL changes from STAGING? [y/N] ' yesno
#                     case $yesno in
#                         [Yy]* )
#                             bash -c 'bundle exec cap staging db:pull && bundle exec cap staging uploads:pull'
#                             break
#                             ;;
#                         * )
#                             break
#                             ;;
#                     esac
#                 done
#                 break
#                 ;;
#             push )
#                 while true; do
#                     read -ep 'Are you sure you want to PUSH changes to STAGING? [y/N] ' yesno
#                     case $yesno in
#                         [Yy]* )
#                             bash -c 'bundle exec cap staging deploy && bundle exec cap staging db:push && bundle exec cap staging uploads:push'
#                             break
#                             ;;
#                         * )
#                             break
#                             ;;
#                     esac
#                 done
#                 break
#                 ;;
#         esac
#     done
# }

# cap-production() {
#     while true; do
#         read -ep 'Pull or push PRODUCTION site? [pull/push] ' response
#         case $response in
#             pull )
#                 while true; do
#                     read -ep 'Are you sure you want to PULL changes from PRODUCTION? [y/N] ' yesno
#                     case $yesno in
#                         [Yy]* )
#                             bash -c 'bundle exec cap production db:pull && bundle exec cap production uploads:pull'
#                             break
#                             ;;
#                         * )
#                             break
#                             ;;
#                     esac
#                 done
#                 break
#                 ;;
#             push )
#                 while true; do
#                     read -ep 'Are you sure you want to PUSH changes to PRODUCTION? [y/N] ' yesno
#                     case $yesno in
#                         [Yy]* )
#                             bash -c 'bundle exec cap production deploy && bundle exec cap production db:push && bundle exec cap production uploads:push'
#                             break
#                             ;;
#                         * )
#                             break
#                             ;;
#                     esac
#                 done
#                 break
#                 ;;
#         esac
#     done
# }

# # Start a web server to share the files in the current directory
# startserver() {
#     # PHP
#     path="$1"
#     if [ -z "$path" ]; then
#         path="."
#     fi
#     open http://localhost:3000
#     php -t $path -S localhost:3000
# }

# Display the weather using wttr.in
weather() {
    location="$1"
    if [ -z "$location" ]; then
        location="wenatchee"
    fi

    curl https://wttr.in/$location
}

# # Shorten a Github URL with git.io (https://github.com/blog/985-git-io-github-url-shortener)
# gitio() {
#     # Check for a URL
#     if [ -z "$1" ]; then
#         echo "You need to supply a URL to shorten..."
#         return
#     fi

#     # Check for a code
#     if [ -z "$2" ]; then
#         echo "You need to supply a name for your shortened URL..."
#         return
#     fi

#     curl -i https://git.io -F "url=$1" -F "code=$2"
#     printf "\n"
# }

# # Download a website
# dl-website() {
#     polite=''

#     if [[ $* == *--polite* ]]; then
#         polite="--wait=2 --limit-rate=50K"
#     fi

#     wget --recursive --page-requisites --convert-links --user-agent="Mozilla" $polite "$1";
# }


#---------------------------------------------------------------------------------------------------------------------------------------
#   5.  GIT SHORTCUTS
#---------------------------------------------------------------------------------------------------------------------------------------

alias gitstats='git-stats'
alias gits='git status -s'
alias gita='git add -A && git status -s'
alias gitcom='git commit -am'
alias gitacom='git add -A && git commit -am'
alias gitc='git checkout'
# alias gitcm='git checkout master'
# alias gitcd='git checkout development'
# alias gitcgh='git checkout gh-pages'
alias gitb='git branch'
alias gitcb='git checkout -b'
alias gitdb='git branch -d'
alias gitDb='git branch -D'
# alias gitdr='git push origin --delete'
alias gitf='git fetch'
alias gitr='git rebase'
alias gitp='git push -u'
alias gitpl='git pull'
# alias gitfr='git fetch && git rebase'
# alias gitfrp='git fetch && git rebase && git push -u'
# alias gitpo='git push -u origin'
# alias gitpom='git push -u origin master'
# alias gitphm='git push heroku master'
alias gitm='git merge'
alias gitmd='git merge development'
alias gitmm='git merge master'
alias gitcl='git clone'
# alias gitclr='git clone --recursive'
# alias gitamend='git commit --amend'
# alias gitundo='git reset --soft HEAD~1'
# alias gitm2gh='git checkout gh-pages && git merge master && git push -u && git checkout master'
# alias gitrao='git remote add origin'
# alias gitrso='git remote set-url origin'
# alias gittrack='git update-index --no-assume-unchanged'
# alias gituntrack='git update-index --assume-unchanged'
# alias gitpls='git submodule foreach git pull origin master'
# alias gitremoveremote='git rm -r --cached'
# alias gitcount="git shortlog -sne"
alias gitlog="git log --oneline"
alias gitlog-full="git log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)'"
alias gitlog-changes="git log --oneline --decorate --stat --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)'"
# gitdbr() { git branch -d "$@" && git push origin --delete "$@"; }
# gitupstream() { git branch --set-upstream-to="$@"; }
gitreset() {
    if [ -z "$1" ]; then
        while true; do
            read -ep 'Reset to HEAD? [y/N] ' response
            case $response in
                [Yy]* )
                    bash -c 'git reset --hard HEAD'
                    break;;
                * )
                    echo 'Skipped resetting to HEAD...'
                    break;;
            esac
        done
    else
        while true; do
            read -ep "Reset to $1? [y/N] " response
            case $response in
                [Yy]* )
                    bash -c "git reset --hard $1"
                    break;;
                * )
                    echo "Skipped resetting to $1..."
                    break;;
            esac
        done
    fi
}

# gitrinse() {
#     if [[ "$1" == "all" ]]; then
#         while true; do
#             read -ep "Are you sure you want to gitrinse this repo and it's submodules? [y/N] " response
#             case $response in
#                 [Yy]* )
#                     git clean -xfd;
#                     git submodule foreach --recursive git clean -xfd;
#                     git reset --hard;
#                     git submodule foreach --recursive git reset --hard;
#                     git submodule update --init --recursive;
#                     break;;
#                 * )
#                     echo "Skipped gitrinse..."
#                     break;;
#             esac
#         done
#     else
#         while true; do
#             read -ep "Are you sure you want to gitrinse this repo's submodules? [y/N] " response
#             case $response in
#                 [Yy]* )
#                     git submodule foreach --recursive git clean -xfd;
#                     git submodule foreach --recursive git reset --hard;
#                     git submodule update --init --recursive;
#                     break;;
#                 * )
#                     echo "Skipped gitrinse..."
#                     break;;
#             esac
#         done
#     fi

# }


#---------------------------------------------------------------------------------------------------------------------------------------
#   6.  OS X COMMANDS
#---------------------------------------------------------------------------------------------------------------------------------------

alias add-dock-spacer='defaults write com.apple.dock persistent-apps -array-add "{'tile-type'='spacer-tile';}" && killall Dock'   # Add a spacer to the dock
alias show-hidden-files='defaults write com.apple.finder AppleShowAllFiles 1 && killall Finder'                                   # Show hidden files in Finder
alias hide-hidden-files='defaults write com.apple.finder AppleShowAllFiles 0 && killall Finder'                                   # Hide hidden files in Finder
alias show-dashboard='defaults write com.apple.dashboard mcx-disabled -boolean NO && killall Dock'                                # Show the Dashboard
alias hide-dashboard='defaults write com.apple.dashboard mcx-disabled -boolean YES && killall Dock'                               # Hide the Dashboard
alias show-spotlight='sudo mdutil -a -i on'                                                                                       # Enable Spotlight
alias hide-spotlight='sudo mdutil -a -i off'                                                                                      # Disable Spotlight
alias today='grep -h -d skip `date +%m/%d` /usr/share/calendar/*'                                                                 # Get history facts about the day
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'                                  # Merge PDF files - Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias task-complete='say -v "Zarvox" "Task complete"'

# Fix audio control issues
alias fix-audio='sudo launchctl unload /System/Library/LaunchDaemons/com.apple.audio.coreaudiod.plist && sudo launchctl load /System/Library/LaunchDaemons/com.apple.audio.coreaudiod.plist'

# Fix webcam issues
alias fix-webcam='sudo killall AppleCameraAssistant && sudo killall VDCAssistant'


#---------------------------------------------------------------------------------------------------------------------------------------
#   7.  TAB COMPLETION
#---------------------------------------------------------------------------------------------------------------------------------------

# # Add tab completion for many Bash commands
# if which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
#     source "$(brew --prefix)/share/bash-completion/bash_completion";
# elif [ -f /etc/bash_completion ]; then
#     source /etc/bash_completion;
# fi;

# # Add tab completion for vagrant commands
# if [ -f `brew --prefix`/etc/bash_completion.d/vagrant ]; then
#     source `brew --prefix`/etc/bash_completion.d/vagrant
# fi

# # Add `killall` tab completion for common apps
# complete -o "nospace" -W "Calendar Contacts ControlStrip Dock Finder iTunes Mail Safari SystemUIServer Terminal" killall;

# # Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
# [ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;


# # Bash completion for checking out Git branches
# # _git_checkout_branch_complete() {
# #     local cur prev opts
# #     COMPREPLY=()
# #     cur=${COMP_WORDS[COMP_CWORD]}
# #     prev=${COMP_WORDS[COMP_CWORD-1]}
# #     opts=$(git branch | cut -c 3-)
# #     COMPREPLY=( $(compgen -W "$opts" -- $cur) )
# # }
# # complete -o nospace -F _git_checkout_branch_complete gitc
# # complete -o nospace -F _git_checkout_branch_complete gitm
# # complete -o nospace -F _git_checkout_branch_complete gitdb
# # complete -o nospace -F _git_checkout_branch_complete gitDb
# # complete -o nospace -F _git_checkout_branch_complete gitdbr


# # Bash completion for Homebrew cask uninstall
# _brew_cask_uninstall_complete() {
#     local cur prev opts
#     COMPREPLY=()
#     cur=${COMP_WORDS[COMP_CWORD]}
#     prev=${COMP_WORDS[COMP_CWORD-1]}
#     opts=$(brew cask list)
#     COMPREPLY=( $(compgen -W "$opts" -- $cur) )
# }
# complete -o nospace -F _brew_cask_uninstall_complete bcun

# # Bash completion for Homebrew cask uninstall
# _brew_cask_update_complete() {
#     local cur prev opts
#     COMPREPLY=()
#     cur=${COMP_WORDS[COMP_CWORD]}
#     prev=${COMP_WORDS[COMP_CWORD-1]}
#     opts=$(brew cask outdated | cut -c 1-)
#     COMPREPLY=( $(compgen -W "$opts" -- $cur) )
# }
# complete -o nospace -F _brew_cask_update_complete bcup

# # Bash completion for the `getsshkey` alias
# # _getsshekey_complete() {
# #     local cur prev opts
# #     COMPREPLY=()
# #     cur=${COMP_WORDS[COMP_CWORD]}
# #     prev=${COMP_WORDS[COMP_CWORD-1]}
# #     opts=$(ls $HOME/.ssh/)
# #     COMPREPLY=( $(compgen -W "$opts" -- $cur) )
# # }
# # complete -o nospace -F _getsshekey_complete getsshkey

# Hook for direnv
eval "$(direnv hook zsh)"
# fnm
export PATH="/Users/mhood/Library/Application Support/fnm:$PATH"
eval "`fnm env --use-on-cd`"

# Put libpq in path so we can run psql client
export PATH="/usr/local/opt/libpq/bin:$PATH"
