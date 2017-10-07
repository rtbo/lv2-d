#! /bin/sh

LV2_DIR=$HOME/.lv2

function install_plugin {
    rm -vrf $LV2_DIR/$1.lv2
    dub build lv2:$1 && \
        mkdir -vp $LV2_DIR/$1.lv2 && \
        cp -v plugins/$1/*.ttl $LV2_DIR/$1.lv2 && \
        cp -v plugins/$1/lib$1.so $LV2_DIR/$1.lv2/$1.so
}

install_plugin amp
# install_plugin sine_synth
