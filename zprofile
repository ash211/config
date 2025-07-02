# Added by Toolbox App
export PATH="$PATH:/Users/aash/Library/Application Support/JetBrains/Toolbox/scripts"

# For homebrew grep, to be able to use gnu grep without the ggrep 'g' prefix
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"

# To use TechOps version of gpg, since homebrew's fails sometimes
# https://palantir.slack.com/archives/CM8HNNZLG/p1696542629150079
export PATH="/usr/local/MacGPG2/bin:${PATH}"
# to restart, run:
# gpgconf --kill all
# ps ax | grep pgp  #and kill anything still running
# /usr/local/MacGPG2/bin/gpgconf --launch gpg-agent
