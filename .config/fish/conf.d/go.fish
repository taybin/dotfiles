# set the workspace path
set -x GOPATH $HOME/go

# add the go bin path to be able to execute our programs
fish_add_path $GOPATH/bin
