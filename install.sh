#/usr/bin/env bash

FILE_LIST=(.bashrc_include .emacs .gitconfig .makepkg.conf .tmux.conf .vim .vimrc .Xresources bin/sbt bin/sbt-launch.jar bin/sbt-monitor bin/start-android-emulator.sh .config/fcitx/rime/default.custom.yaml .config/fcitx/rime/luna_pinyin.custom.yaml)

#FILE_LIST=(bin/sbt bin/sbt-launch.jar)

readonly BACKUP_DIR=$HOME/.taothomeconfig-backup
readonly REPO_DIR=$(dirname $(readlink -f $0))
cd $HOME

## function ##
create_link() {
    local NAME=$1

    if [ -h $NAME ]; then
        LINK=$(readlink $NAME)
        if [ $LINK = $REPO_DIR/$NAME ]; then
            echo "Already exists: $NAME -> $LINK"
        else
            echo "Symolic link change: $LINK -> $REPO_DIR/$NAME"
            rm $NAME
            ln -s $REPO_DIR/$NAME $NAME
        fi
    else
        if [ -e $NAME ]; then
            echo "Regular file or directory $NAME exists. Move to $BACKUP_DIR"
            mkdir -p $BACKUP_DIR
            mv $NAME $BACKUP_DIR
        fi
        if [ ! -e $REPO_DIR/$NAME ]; then
            echo "File not exist $REPO_DIR/$NAME"
        else
            echo "Create symbolic link $NAME -> $REPO_DIR/$NAME"
            ln -s $REPO_DIR/$NAME $NAME
        fi
    fi
}

## main ##
echo
echo "The script will create links (if they do not exist) to the following files in your home directory ($HOME):"
echo ${FILE_LIST[@]}
echo -n "Are you sure? [Y/n] "
read YES_NO

if [ $YES_NO = 'Y' ] || [ $YES_NO = 'y' ]; then
    for F in ${FILE_LIST[@]}; do
        create_link $F
    done
fi
