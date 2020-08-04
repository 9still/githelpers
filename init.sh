#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/colors
source $DIR/git-completion.bash

#source $DIR/git-prompt.sh
#source $DIR/git-helper.sh
#GIT_PS1_SHOWDIRTYSTATE=1

# gitprompt configuration

# Set config variables first
GIT_PROMPT_ONLY_IN_REPO=1

# GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

# GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
# GIT_PROMPT_END=...      # uncomment for custom prompt end sequence

# as last entry source the gitprompt script
#GIT_PROMPT_THEME=Custom # use custom .git-prompt-colors.sh
GIT_PROMPT_THEME=Single_line_Solarized_NoExitState # use theme optimized for solarized color scheme

# RUN this the first time
# git clone https://github.com/magicmonty/bash-git-prompt $DIR/bash-git-prompt
source $DIR/bash-git-prompt/gitprompt.sh

