LOCAL_DIR=~/local
LOCAL_BIN="$LOCAL_DIR/bin"

# Section to install robbyrussell/oh-my-zsh
OH_MY_ZSH_DIR=~/.oh-my-zsh
DOT_ZSHRC=~/.zshrc
OH_MY_ZSH_REMOTE="https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh"
SHELL=`which zsh`
if [ ! -d "$OH_MY_ZSH_DIR" ]
then

  curl -L $OH_MY_ZSH_REMOTE | sh

  plugin_output="$(sed -n '/^plugin/p' $DOT_ZSHRC)"
  if [ ! -z $plugin_output ]
  then
    echo "plugins=(git rails3 textmate ruby bundler lol github gem ssh-agent cap osx mysql-macports macports)" >> $DOT_ZSHRC
  fi

  editor_output="$(sed -n '/^EDITOR/p' $DOT_ZSHRC)"
  if [ ! -z $editor_output ]
  then
    echo "EDITOR=vim" >> $DOT_ZSHRC
  fi

  if [ -z "$(chsh -s $SHELL)" ]
  then
    echo "SHELL has been changed to $SHELL"
  fi

else
  echo "$OH_MY_ZSH_DIR exists!, I can not overwrite this automatically."
fi


# Section to set tmux configuration files
TMUX_DIR=~/.tmux
TMUX_ORIG_CONF="$TMUX_DIR/tmux.conf"
TMUX_DST_CONF=~/.tmux.conf
TMUX_ORIG_SCRIPT="$TMUX_DIR/tmx"
TMUX_DST_SCRIPT="$LOCAL_BIN/tmx"
TMUX_REMOTE="http://github.com/juarlex/tmux-conf" 

if [ ! -d "$TMUX_DIR" ]
then

  echo "Clonning tmux configuration files"
  git clone $TMUX_REMOTE $TMUX_DIR

  echo "Setting tmux files"

  echo "Linking $TMUX_DST_CONF -> $TMUX_ORIG_CONF"
  ln -sf $TMUX_ORIG_CONF $TMUX_DST_CONF

  mkdir -p "$LOCAL_BIN"

  echo "Linking $TMUX_DST_SCRIPT -> $TMUX_ORIG_SCRIPT"
  ln -sf $TMUX_ORIG_SCRIPT $TMUX_DST_SCRIPT

else
  echo "$TMUX_DIR exists!, I can not overwrite this automatically."
fi

# Section to install rvm
RVM_DIR=~/.rvm
RVM_REMOTE="get.rvm.io"
RUBY_VERSION="1.9.3-p194"

if [ ! -d "$RVM_DIR" ]
then
  curl -L $RVM_REMOTE | bash -s stable

  rvm_output="$(sed -n '/rvm\/scripts\/rvm/p' $DOT_ZSHRC)"
  if [ ! -z $rvm_output ]
  then
    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"' >> $DOT_ZSHRC
  fi

  source "$HOME/.rvm/scripts/rvm"

  rvm --skip-autoreconf pkg install readline
  rvm --skip-autoreconf pkg install iconv
  rvm pkg install zlib
  rvm pkg install openssl
  rvm pkg install autoconf 
  rvm install $RUBY_VERSION 
  rvm use $RUBY_VERSION --default
  gem install bundler
  gem install rake
  gem install certified
  gem install tmuxinator

  tmuxinator_output="$(sed -n '/\.tmuxinator\/scripts\/tmuxinator/p' $DOT_ZSHRC)"
  if [ ! -z $tmuxinator_output ]
  then
    echo '[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator' >> $DOT_ZSHRC
  fi

else
  echo "$RVM_DIR exists!, I can not overwrite this automatically."
fi

# Vim settings
VIM_DIR=~/.vim
VIM_REMOTE="http://bit.ly/janus-bootstrap"
if [ ! -d "$VIM_DIR" ]
then
   curl -Lo- $VIM_REMOTE | bash
else 
  echo "$VIM_DIR exists!, I can not overwrite this automatically."
fi

VUNDLE_DIR=~/.vim/bundle/vundle
VUNDLE_REMOTE="https://github.com/gmarik/vundle.git"
if [ ! -d "$VUNDLE_DIR" ]
then
   git clone $VUNDLE_REMOTE $VUNDLE_DIR
else
  echo "$VUNDLE_DIR exists!, I can not overwrite this automatically."
fi

VIMRC_AFTER_DST=~/.vimrc.after
VIMRC_AFTER_REMOTE="https://raw.github.com/juarlex/quick-dotfiles/master/dotvimrc.after"
if [ ! -f "$VIMRC_AFTER_DST" ]
then
  curl -L $VIMRC_AFTER_REMOTE -o $VIMRC_AFTER_DST
else
  echo "$VIMRC_AFTER_DST exists!, I can not overwrite this automatically."
fi

GITCONFIG_DST=~/.gitconfig
GITCOFIG_REMOTE="https://raw.github.com/juarlex/quick-dotfiles/master/dotgitconfig"
if [ ! -f "$GITCONFIG_DST" ]
then
  curl -L $GITCONFIG_REMOTE -o $GITCONFIG_DST
else
  echo "$GITCONFIG_DST exists!, I can not overwrite this automatically."
fi

# HUB Settings
HUB_CMD=~/local/bin/hub
HUB_REMOTE="http://defunkt.io/hub/standalone"
curl $HUB_REMOTE -sLo $HUB_CMD
chmod +x $HUB_CMD
