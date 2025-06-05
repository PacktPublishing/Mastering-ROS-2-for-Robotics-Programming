#!/bin/bash -eu

# The BSD License
# Copyright (c) 2024 RUNTIME Robotics
# Copyright (c) 2014 OROCA and ROS Korea Users Group

#set -x

name_ros_distro=jazzy 
user_name=$(whoami)
echo "#######################################################################################################################"
echo ""
echo ">>> {Starting ROS 2 Jazzy Installation}"
echo ""
echo ">>> {Checking your Ubuntu version} "
echo ""
#Getting version and release number of Ubuntu
version=`lsb_release -sc`
relesenum=`grep DISTRIB_DESCRIPTION /etc/*-release | awk -F 'Ubuntu ' '{print $2}' | awk -F ' LTS' '{print $1}'`
echo ">>> {Your Ubuntu version is: [Ubuntu $version $relesenum]}"
#Checking version is focal, if yes proceed othervice quit
case $version in
  "noble" )
  ;;
  *)
    echo ">>> {ERROR: This script will only work on Ubuntu Noble (24.04).}"
    exit 0
esac

echo ""
echo ">>> {ROS 2 Jazzy is fully compatible with Ubuntu Noble 24.04}"
echo ""
echo "#######################################################################################################################"
echo ">>> {Step 1: Configure your Ubuntu repositories}"
echo ""
#Configure your Ubuntu repositories to allow "restricted," "universe," and "multiverse." You can follow the Ubuntu guide for instructions on doing this. 
#https://help.ubuntu.com/community/Repositories/Ubuntu


locale  # check for UTF-8

sudo apt update 
sudo apt install -y locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

locale  # verify settings


##############################################################


sudo apt install -y software-properties-common
sudo add-apt-repository universe

echo ""
echo ">>> {Done: Added Ubuntu repositories}"
echo ""
echo "#######################################################################################################################"
echo ">>> {Step 2: Set up your keys}"
echo ""
echo ">>> {Installing curl for adding keys}"
#Installing curl: Curl instead of the apt-key command, which can be helpful if you are behind a proxy server: 
#TODO:Checking package is not working sometimes, so disabling it
#Checking curl is installed or not
#name=curl
#which $name > /dev/null 2>&1

#if [ $? == 0 ]; then
#    echo "Curl is already installed!"
#else
#    echo "Curl is not installed,Installing Curl"

echo ">>> {Checking and removing existing keys if present}"

if [ -f "/etc/apt/sources.list.d/ros2.list" ]; then
    sudo rm /etc/apt/sources.list.d/ros2.list
fi

if [ -f "/usr/share/keyrings/ros-archive-keyring.gpg" ]; then
    sudo rm /usr/share/keyrings/ros-archive-keyring.gpg
fi

echo ">>> {Installing ROS 2 APT Source package}"


sudo apt update 
sudo apt install -y curl openssl 


export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb" # If using Ubuntu derivates use $UBUNTU_CODENAME
sudo apt install /tmp/ros2-apt-source.deb


echo ">>> {Done: Added Keys}"
echo ""
echo "#######################################################################################################################"
echo ">>> {Step 4: Updating Ubuntu package index, this will take few minutes depend on your network connection}"
echo ""
sudo apt update
sudo apt -y upgrade 

echo ""
echo "#######################################################################################################################"
echo ">>> {Step 5: Install ROS, you pick how much of ROS you would like to install.}"
echo "     [1. Desktop Install: (Recommended) : Everything in Desktop plus 2D/3D simulators and 2D/3D perception packages ]"
echo ""
echo "     [2. ROS-Base: (Bare Bones) ROS packaging, build, and communication libraries. No GUI tools.]"
echo ""
#Assigning default value as 1: Desktop full install
read -p "Enter your install (Default is 1):" answer 

case "$answer" in
  1)
    package_type="desktop-full"
    ;;
  2)
    package_type="ros-base"
    ;;    
  * )
    package_type="desktop-full"
    ;;
esac
echo "#######################################################################################################################"
echo ""
echo ">>>  {Starting ROS installation, this will take about 20 min. It will depends on your internet  connection}"
echo ""
sudo apt install -y ros-${name_ros_distro}-${package_type} 
sudo apt install -y ros-dev-tools
echo ""
echo ""
echo "#######################################################################################################################"
echo ">>> {Step 6: Setting ROS Environment, This will add ROS environment to .bashrc.}" 
echo ">>> { After adding this, you can able to access ROS commands in terminal}"
echo ""
echo "source /opt/ros/${name_ros_distro}/setup.bash" >> /home/$user_name/.bashrc
source /home/$user_name/.bashrc
echo ""
echo "#######################################################################################################################"
echo ">>> {Step 7: Testing ROS installation, checking ROS version.}"
echo ""
echo ">>> {Type [printenv ROS_DISTRO] to get the current ROS installed version}"
echo ""
printenv ROS_DISTRO
echo "#######################################################################################################################"

