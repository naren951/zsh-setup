#!/bin/bash
ZSH_SRC_NAME=$HOME/packages/zsh.tar.xz
ZSH_PACK_DIR=$HOME/packages/zsh
ZSH_LINK="https://sourceforge.net/projects/zsh/files/latest/download"

# Installing ncurses
curl -Lo "ncurses-6.1.tar.gz" "ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz"
tar xvf "ncurses-6.1.tar.gz"
rm "ncurses-6.1.tar.gz"
cd "ncurses-6.1"
./configure --prefix=$HOME/local CXXFLAGS="-fPIC" CFLAGS="-fPIC"
make -j && make install
# Creates ZSH package directory
if [[ ! -d "$ZSH_PACK_DIR" ]]; then
    echo "Creating zsh directory under packages directory"
    mkdir -p "$ZSH_PACK_DIR"
fi
# Downloading ZSH Shell
if [[ ! -f $ZSH_SRC_NAME ]]; then
    curl -Lo "$ZSH_SRC_NAME" "$ZSH_LINK"
fi

# Extracting ZSH
tar xvf "$ZSH_SRC_NAME" "$ZSH_PACK_DIR"
cd "$ZSH_PACK_DIR"

# Configuring and Installing ZSH
./configure --prefix="$HOME/local" \
    CPPFLAGS="-I$HOME/local/include" \
    LDFLAGS="-L$HOME/local/lib"
make -j && make install

echo "export PATH=$HOME/local/bin:$PATH
export SHELL=`which zsh`
[ -f \"$SHELL\" ] && exec \"$SHELL\" -l" >> ~/.bash_profile

source ~/.bash_profile

echo "installing oh-my-zsh"
# Installing oh-my-zsh
curl -Lo https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh install-ohmyzsh.sh
sh -c install-ohmyzsh.sh
# rm install-ohmyzsh.sh

# Downloading ZSH Auto Suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# echo 'export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="powerlevel9k/powerlevel9k"
# plugins=( git zsh-autosuggestions zsh-syntax-highlighting)
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs)
# ' > ~/.zshrc
# source ~/.zshrc
# plugins=(git)