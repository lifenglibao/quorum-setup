#Setup

#System Requirements

OS: Ubuntu 16.04.6 LTS
CPUs: 2
Memory: 8GB
Harddisk: 50GB

#Setup Quorum

Git clone https://github.com/jpmorganchase/quorum.git

Go to quorum to run "make all"

An easy way to supplement PATH is to add PATH=$PATH:/path/to/repository/build/bin to your ~/.bashrc or ~/.bash_aliases file.

e.g. export PATH=/home/ubuntu/quorum/build/bin:$PATH

#Setup Go (If already installed, pls ignore.)

Download go - wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz
	sudo tar -xvf go1.11.linux-amd64.tar.gz
	sudo mv go /usr/local
	sudo vim /etc/profile
	
	To make sure all setting in /etc/profile
	
	export GOPATH=/home/www/golang/gopath
	export GOROOT=/usr/local/go
	export GOARCH=amd64
	export GOOS=linux
	export GOTOOLS=$GOROOT/pkg/tool
	export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

    After this, use "go version" to check if is successful.

#Install JAVA 8

sudo apt install openjdk-8-jdk-headless
sudo apt-get install default-jdk
sudo apt install default-jre

install "jdk-8u181-linux-x64.tar.gz"

sudo mkdir /usr/lib/jvm
cd /usr/lib/jvm
sudo tar -xvzf /home/ubuntu/jdk-8u181-linux-x64.tar.gz
sudo update-alternatives --config java

sudo vim /etc/environment , add some configs into /etc/environment

	/usr/lib/jvm/jdk1.8.0_181/bin:/usr/lib/jvm/jdk1.8.0_181/db/bin:/usr/lib/jvm/jdk1.8.0_181/jre/bin

	J2SDKDIR="/usr/lib/jvm/jdk1.8.0_181"
	J2REDIR="/usr/lib/jvm/jdk1.8.0_181/jre"
	JAVA_HOME="/usr/lib/jvm/jdk1.8.0_181"
	DERBY_HOME="/usr/lib/jvm/jdk1.8.0_181/db"


sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_181/bin/java" 0
sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0_181/bin/javac" 0
sudo update-alternatives --set java /usr/lib/jvm/jdk1.8.0_181/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/jdk1.8.0_181/bin/javac

update-alternatives --list java
update-alternatives --list javac

java -version

echo $JAVA_HOME

#Install Tessera

https://github.com/jpmorganchase/tessera/releases to install "tessera-app-0.10.1-app.jar"

After tessera installed, Pls add the following lines into your ~/.bashrc or ~/.bash_aliases file

alias tessera="java -jar /path/to/tessera-app-${version}-app.jar"
export TESSERA_JAR=".path/to/tessera-app-${version}-app.jar"

e.g.
alias tessera="java -jar /home/ubuntu/tessera/tessera-app-0.10.1-app.jar"
export TESSERA_JAR="/home/ubuntu/tessera/tessera-app-0.10.1-app.jar"

#Preparing node environment configuration data

#Run init.sh

#Create ETH Account

geth --datadir data account new

Please write down the public address that just generated, e.g. <6e072e22d42164f4c647ac6898cfb4263a2bbae4>,

Please create a new txt file in root directory. named passwords.txt and put your address passphrase at the first line. If you do not have set any password, Make sure the first is empty.

#Generate nodekey

bootnode -genkey nodekey
mv nodekey data/geth/nodekey
bootnode -nodekey data/geth/nodekey -writeaddress

Please write down the output address, e.g. "f55b03d0966216f0b95b124d40589d5a9cba078b46991c62be3288580c5e3a48bb559be226cd8ee5f9d70124a5be549c870ad8c984220b4a6336261c9b74f845"

#Generate Tessera Key Pair
tessera -keygen -filename "tm"
mv tm.key data/tm.key
mv tm.pub data/tm.pub
cat data/tm.pub

Please write down your public key that just output. e.g. "7PSKhCIkLnqPzxuMp3MJ7xGmxC5/0VhmyWQx7BlUTy4="
If you put password when create tm key, pls write down you password.


#Get Started Instructions - Send configuration data below to iAPPS

1. ETH account public address
2. Node key public address
3. Tessera public key
4. Your server public ip address
5. Tm key password if have.
6. Server Ports
	(IN && OUT) Raft: 
	(IN && OUT) Quorum: 
	(IN) RPC: 
	(IN) WSS: 
	(IN & OUT) Tessera: 
	(IN & OUT) Tessera ThirdParty: 
	(IN & OUT) Tessera Enclave: 
	(IN & OUT) Tessera P2P : 
