###################################################
# This file is loaded by the following files:     #
# 1. ~/.bashrc_includ.sh                          #
# 2. ~/.config/plasma-workspace/env/env.sh        #
################################################# #

# Fcitx (https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma)
export XMODIFIERS=@im=fcitx

# Data download locations
export ML_DATA_AUTO_DOWNLOAD_HOME=~/data/ml_data/auto_download

export GENSIM_DATA_DIR=${ML_DATA_AUTO_DOWNLOAD_HOME}/gensim
export HF_HOME=${ML_DATA_AUTO_DOWNLOAD_HOME}/huggingface
export NLTK_DATA=${ML_DATA_AUTO_DOWNLOAD_HOME}/nltk
export OLLAMA_MODELS=${ML_DATA_AUTO_DOWNLOAD_HOME}/ollama
