#!/bin/sh

HELIUM_WALLET="https://github.com/helium/helium-wallet-rs"
HELIUM_REPO="helium-wallet-rs"
HELIUM_DEP="cargo build-essential pkg-config git"

get_helium_wallet() {
	[ -z ~/$HELIUM_REPO ] && echo "Helium walllet repo installed!" || sudo apt update && sudo apt upgrade && git clone $HELIUM_WALLET;
}

install_dep() {
	sudo apt install -y $HELIUM_DEP
}

compile_wallet() { 
	cd ~/$HELIUM_REPO && cargo build --release & echo "done!";
}

add_path() {
	sudo mv ~/$HELUIM_REP/target/release/helium-wallet /usr/bin/ && sudo rm -rf ~/$HELIUM_REP/ || echo "Error has occured";
}

install_dep && get_helium_wallet && compile_wallet && add_path
