# Installation

## From Release

```
wget https://github.com/yourname/bash-it-dpkg/releases/latest/download/bash-it-dpkg_1.0.0-1_all.deb
sudo dpkg -i bash-it-dpkg_1.0.0-1_all.deb

```

## Build from Source

```

git clone https://github.com/yourname/bash-it-dpkg
cd bash-it-dpkg

sudo apt install build-essential devscripts
debuild -us -uc

sudo dpkg -i ../bash-it-dpkg_*.deb

```
