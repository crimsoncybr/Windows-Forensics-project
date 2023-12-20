#!/bin/bash

	#Student name: Dean Cohen    

	#Check if the user is root
	if [ "$(whoami)" != "root" ]; then
		echo -e "\033[1;32m This script must be run as root.\e[0m"
	exit 

	else 
		echo -e "\033[1;32m You are running as root. Proceeding with the script.\e[0m"

	fi
	
	#updating 
	function UPDATE()
{
		apt-get -qqy update
}
		#UPDATE
		
	# Provide the path to the file you want to check if not exit
	function FILE()
{
		echo -e "\033[1;34m Enter HDD image file or a memory file.\e[0m"
		read FILE
		echo -e "\033[1;34m $FILE will be processed.\e[0m"
		

	if [ -e "$FILE" ]; then
		
		echo -e "\033[1;32m file $FILE  exists all the carved data will be saved in this folder  CARVED.\e[0m"
		mkdir CARVED
		mkdir CARVED/registry
	else
		echo -e "\033[1;31m file $FILE does not exist\e[0m"
		exit 
	fi
}


#a function to notify which type of file is provided to apply the supporting curving tools
function HM()
{
	
	echo -e  " \033[1;34m Select M for memory dump file or H for HDD image file:\e[0m "
	read CHOICE
	
case $CHOICE in
M)
echo -e "\033[1;32m  $FILE is a Memory dump file \e[0m"

echo -e "\033[1;32m Extracting data… \e[0m"

	BULK
	PAC
	STRINGS
	VOLEX
	VOLREG
	RABL
	FRMST
	INFO1
	ZIP

;; 

H)
echo -e "\033[1;32m $FILE is a HDD image file \e[0m"
echo -e "\033[1;32m Extracting data… \e[0m"

	BULK
	PAC
	STRINGS
	RABL
	FRMST
	INFO2
	ZIP
;; 

*)
echo -e  "\033[1;32m You entered wrong choice, start again and choose M or H \e[0m"
;; 
esac 


}


	# check if foremost is installed and installs it if not.
	if ! command -v foremost &>/dev/null; 
	then
		echo -e "\033[1;31m foremost is not installed, starting installation\033[0m"
		sudo apt-get -qqy install foremost
		echo -e "\033[1;32m formost has been installed.\e[0m"
	else
		echo -e "\033[1;32m foremost is installed\e[0m."
	fi
	
	
	
	
	# check if bulk_extractor is installed and installs it if not.
	if ! command -v bulk_extractor &>/dev/null; 
	then
		echo -e "\033[1;31m bulk_extractor is not installed, starting installation\033[0m"
		sudo apt-get -qqy install bulk_extractor
		echo -e "\033[1;32m bulk_extractor has been installed.\e[0m"
	else
		echo -e "\033[1;32m bulk_extractor is installed\e[0m."
	fi
	
	
	
	# check if strings is installed and installs it if not.
	if ! command -v strings &>/dev/null; 
	then
		echo -e "\033[1;31m strings is not installed, starting installation\033[0m"
		sudo apt-get -qqy install strings
		echo -e "\033[1;32m strings has been installed.\e[0m"
	else
		echo -e "\033[1;32m strings is installed\e[0m."
	fi



	# check if binwalk is installed and installs it if not.
	if ! command -v binwalk &>/dev/null; 
	then
		echo -e "\033[1;31m binwalk is not installed, starting installation\033[0m"
		sudo apt-get -qqy install binwalk
		echo -e "\033[1;32m binwalk has been installed.\e[0m"
	else
		echo -e "\033[1;32m binwalk is installed\e[0m."
	fi

	
	
	# Volatility is never preinstalled, to make it easy we will install it in this directory
	function VOL ()
	{
	

	if [ -d "volatility_2.6_lin64_standalone" ] &>/dev/null ;
	then
		echo -e "\033[1;32m Volatility is already installed.\e[0m"
	else
		# Download and unzip volatility in the directory we are in.
		wget http://downloads.volatilityfoundation.org/releases/2.6/volatility_2.6_lin64_standalone.zip
		unzip volatility_2.6_lin64_standalone.zip 
	
	fi
	}
	VOL
	
	
	# Optinal feature to delete volatility at the end of the script
	function DELVOL ()
	{
	rm -r volatility_2.6_lin64_standalone
	rm -r volatility_2.6_lin64_standalone.zip
	}








	

	#carving with strings
	function STRINGS() {
		echo -e "\033[1;35m carving with strings \e[0m"
    strings "$FILE" > CARVED/$FILE_strings.txt
}

	
	


	#carving with bulkextractor
	function BULK() {
		echo -e "\033[1;35m carving with bulk extracrot \e[0m"
    bulk_extractor -q "$FILE" -o CARVED/bulk_$FILE  > CARVED/bulk_extractorDATA.txt
}


	# cheacks if bulk extractor extracted network traffic
	function PAC ()
	{
	Packets="CARVED/bulk_$FILE/packets.pcap"

	if [ -e "$Packets" ]; then
		echo -e "\033[1;35m a network traffic file was carved the packets.pcap $(ls -lh CARVED/bulk_$FILE |grep "packets.pcap" | awk '{print $5}' ) file is at CARVED/bulk_$FILE/packets.pcap \e[0m"
	
	fi
	}


#carving with volatility
	function VOLEX() {
		
		echo -e "\033[1;35m carving with volayility \e[0m"
    volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone -f memdump.mem imageinfo > CARVED/volimigeinfo.txt
	MEMPROF=$(cat CARVED/volimigeinfo.txt |grep -i suggested | awk '{print $4}' | sed 's/,//g' )
    echo -e "\033[1;35m carving registry files with volayility and will be saved in 'CARVED' filder\e[0m"	
   
    for i in pslist  pstree  userassist  sockets hivelist connscan
	do
		echo -e "\033[1;34m Exctracting $i data \e[0m"
			echo -e "\033[1;35m carving registry files with volayility and will be saved in 'CARVED/vol-$i.txt' \e[0m"	
		volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone -f $FILE --profile=$MEMPROF $i > CARVED/vol-$i.txt
		

	done
}


#carving with volatility
	function VOLREG() 
	{S
	MEMPROF=$(cat CARVED/volimigeinfo.txt |grep -i suggested | awk '{print $4}' | sed 's/,//g' )
    echo -e "\033[1;34m Exctracting dumpregistry data \e[0m"
    echo -e "\033[1;35m carving registry files with volayility and will be saved in 'CARVED/registry' folder \e[0m"	
	volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone -f $FILE --profile=$MEMPROF dumpregistry -D CARVED/registry > CARVED/dumpregistry_info.txt


}

	#A function to find readables and saves them to a file
	function RABL ()
	{
		mkdir CARVED/readable
		date >  CARVED/readable/user.txt
		cat CARVED/$FILE_strings.txt| grep -C 3 "user"  >> CARVED/readable/user.txt
		
		date > CARVED/readable/EXE.txt
		cat CARVED/$FILE_strings.txt| grep "*.exe"   >> CARVED/readable/EXE.txt
		
		date > CARVED/readable/bank.txt
		cat CARVED/$FILE_strings.txt| grep -i  "bank"  >> CARVED/readable/bank.txt
		
		date > CARVED/readable/password.txt
		cat CARVED/$FILE_strings.txt| grep -iC 3  "password"  >> CARVED/readable/password.txt

	}


	#carving with foremost
	function FRMST ()
	{
		echo -e "\033[1;35m carving with foremost files will be saved in 'CARVED/foremost_output' filder\e[0m"
		mkdir CARVED/foremost_output
        foremost -i $FILE -o CARVED/foremost_output/
        
	}
	
	
	#information gathering function
		function INFO1 ()
	{
	echo -e "\033[1;33m  $(date) \e[0m"
	
	echo -e "\033[1;33m  total number of files extracted [$(find CARVED -type f -name "*" |wc -l)] \e[0m"
	
	echo -e "\033[1;33m  total number of TXT files extracted [$(find CARVED -type f -name "*.txt" |wc -l)] \e[0m"
	
	echo -e "\033[1;33m  total number of EXE files extracted [$(find CARVED -type f -name "*.exe" |wc -l)] \e[0m"	
	
	ls -fl CARVED | awk '{print$9 }' > extracted_files.txt
	ls -fl CARVED | awk '{print$9 }' >> extracted_files.txt
	ls -fl CARVED/bulk_$FILE | awk '{print$9 }'  >> extracted_files.txt
	ls -lh CARVED/readable | awk '{print$9 }'  >> extracted_files.txt     
	ls -lh CARVED/registry | awk '{print$9 }' >> extracted_files.txt
	cat  CARVED/foremost_output/audit.txt  >> extracted_files.txt
	echo -e "\033[1;33m  a list of all extracted files was created 'extracted_files.txt' \e[0m"

	PAC

	}
	
	
	#information gathering function
		function INFO2 ()
	{
	echo -e "\033[1;33m  $(date) \e[0m"
	
	echo -e "\033[1;33m  total number of files extracted [$(find CARVED -type f -name "*" |wc -l)] \e[0m"
	
	echo -e "\033[1;33m  total number of TXT files extracted [$(find CARVED -type f -name "*.txt" |wc -l)] \e[0m"
	
	echo -e "\033[1;33m  total number of EXE files extracted [$(find CARVED -type f -name "*.exe" |wc -l)] \e[0m"	
	
	ls -fl CARVED | awk '{print$9 }' > extracted_files.txt
	ls -fl CARVED | awk '{print$9 }' >> extracted_files.txt
	ls -fl CARVED/bulk_$FILE | awk '{print$9 }'  >> extracted_files.txt
	ls -lh CARVED/readable | awk '{print$9 }'  >> extracted_files.txt    
	cat  CARVED/foremost_output/audit.txt  >> extracted_files.txt
	echo -e "\033[1;33m  a list of all extracted files was created 'extracted_files.txt' \e[0m"
	}
	
	#Zipping files functions
	function ZIP ()
	{
		zip -rq CARVED.zip extracted_files.txt CARVED
		echo -e "\033[1;35m all findings and a list of the files zipped in'CARVED.zip' \e[0m"
		echo -e "\033[1;35m $(date +'%Y-%m-%d %H:%M:%S') \e[0m"
		
		#use DELVOL to delete volatility at the end of each run 
		#DELVOL
        
	}
        
	FILE
	HM
	
	
	
	
