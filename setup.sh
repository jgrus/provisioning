#!/bin/bash -e


#############################################################################################################
#DEFINING FUNCTIONS
#############################################################################################################
install_nebula_arm() {

echo Downloading and setting up temporary access via Nebula 
mkdir -p /opt/nebula
wget --directory-prefix=/opt/nebula/ https://github.com/slackhq/nebula/releases/download/v1.4.0/nebula-linux-arm64.tar.gz
tar -xzf /opt/nebulanebula-linux-arm64.tar.gz -C /opt/nebula/
chmod +x nebula

}

install_nebula_amd64() {

echo Downloading and setting up temporary access via Nebula 
mkdir -p /opt/nebula
wget --directory-prefix=/opt/nebula/ https://github.com/slackhq/nebula/releases/download/v1.4.0/nebula-linux-amd64.tar.gz
tar -xzf /opt/nebula/nebula-linux-amd64.tar.gz -C /opt/nebula
chmod +x nebula

}

setup_temporary_access() {
cp temp_access.crt /opt/nebula/ 
cp temp_access.key /opt/nebula/ 
cp config.yml /opt/nebula/ 
cp ca.crt /opt/nebula/ 
}

start_nebula() {
echo Starting nebula server to enable remote access
/opt/nebula/nebula -config /opt/nebula/config.yml
}


###################################################################################################################
#>RUNNING SCRIPT
###################################################################################################################
echo Installing ssh server
apt install openssh-server
echo Importing SSH keys from github profile
ssh-import-id gh:jgrus


echo Checking platform architecture
arch=$(arch)
case "$arch" in
	'aarch64'|'amd64' ) install_nebula_arm ;;
	'x86_64' ) install_nebula_amd64 ;;
	* ) echo Unkown architecture $arch. Manual configuration is required, exiting setup script. && exit 1 ;;
esac

user=$(whoami)
echo Setting up remote administration on $user@10.11.11.11
setup_temporary_access
start_nebula
exit 0


