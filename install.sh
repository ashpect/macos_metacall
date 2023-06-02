!/bin/bash

prepare_install () {
    #Install Homebrew if not already installed
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    #Update brew
    brew update

    #Download and install Xcode command line tools if not already installed
    if test ! $(xcode-select -p); then
        echo "Installing Xcode command line tools..."
        sudo xcode-select --install
	    sudo xcode-select --switch /Library/Developer/CommandLineTools
    fi
    echo "Installed Xcode CLI Tools"
}

install_metacall_brew() {

    # Clone Metacall Homebrew Repository
	echo "Cloning Homebrew Formula for MetaCall"
	git clone https://github.com/metacall/homebrew.git
	cd homebrew
	echo "Cloned formula!"

}

build_formula() {
    brew install ./metacall.rb --build-from-source -v || brew link --overwrite metacall
}

install_brewpkg(){

    brew tap timsutton/formulae
    brew install brew-pkg

}

create_pkg() {

    brew pkg metacall
    if [ -e "metacall-0.5.27.pkg" ]; then
        echo "Package created successfully!"
    else
        echo "Package creation failed!"
    fi

}

main() {
    prepare_install
    install_metacall_brew
    build_formula
    install_brewpkg
    create_pkg
}

main
