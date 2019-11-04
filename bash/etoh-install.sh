#!/bin/bash
# install system dependencies
clear

if [ $# = 0 ]; then
    B="master"
else
    B=$1
fi
echo "github branch to use : $B"

echo
echo installing system dependencies
echo ==============================
sudo apt-get -qq install git
sudo apt-get -qq install curl
sudo apt-get -qq install python python-dev
sudo apt-get -qq install python-setuptools
sudo apt-get -qq install python-pip
sudo apt-get -qq install virtualenv
sudo apt-get -qq install nginx
sudo apt-get -qq install libudev-dev libusb-1.0.0-dev
echo "done"

echo
echo installing nodejd
echo =================
cd /tmp
wget http://nodejs.org/dist/v0.10.32/node-v0.10.32-linux-x64.tar.gz
tar xvf node-v0.10.32-linux-x64.tar.gz
cd node-v0.10.32-linux-x64/
cp * /usr/local/ -r
echo "done"

# download etoh package
echo
echo downloading etoh package
echo ========================
cd ~
if (git clone -q --branch $B https://github.com/Moustikitos/etoh.git) then
    echo "cloning etoh..."
else
    echo "etoh already cloned !"
fi
cd ~/etoh
git reset --hard
git fetch --all
if [ "$B" == "master" ]; then
    git checkout $B -fq
else
    git checkout tags/$B -fq
fi
git pull -q
echo "done"

echo
echo creating virtual environement
echo =============================
if [ ! -d "$HOME/.local/share/etoh/venv" ]; then
    mkdir ~/.local/share/etoh/venv -p
    virtualenv ~/.local/share/etoh/venv -q
    echo "done"
else
    echo "virtual environement already there !"
fi
. ~/.local/share/etoh/venv/bin/activate
export PYTHONPATH=${PYTHONPATH}:${HOME}/etoh
cd ~/etoh
echo "done"

# install python dependencies
echo
echo installing python dependencies
echo ==============================
pip install -r requirements.txt -q
echo "done"

# installing zen command
echo
echo installing zen command
echo ======================
sudo rm /etc/nginx/sites-enabled/*
sudo cp nginx-etoh /etc/nginx/sites-available
sudo ln -sf /etc/nginx/sites-available/nginx-etoh /etc/nginx/sites-enabled
sudo service nginx restart

chmod +x bash/srv.sh
cp bash/srv.sh ~

echo "done"
