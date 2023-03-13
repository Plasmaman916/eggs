echo "Checking if {{SERVER_JARFILE}} exists"
if [ ! -f {{SERVER_JARFILE}} ]; then
	echo "{{SERVER_JARFILE}} does not exist, attempting to install"
fi


echo "Checking if {{SERVER_JARFILE}} exists"
if [ ! -f {{SERVER_JARFILE}} ]; then
	echo "{{SERVER_JARFILE}} does not exist, attempting to install"
	if [!( -f quilt-installer.jar )]; then
		echo "Invalid install! Please reinstall your server!"
		exit 1
	fi
	echo -e "Running java -jar quilt-installer-{{BUILD_NUMBER}}.jar install server {{MINECRAFT_VERSION}} --download-server"
	java -jar quilt-installer.jar install server {{MINECRAFT_VERSION}} --download-server

	echo -e "Running mv quilt-installer-{{BUILD_NUMBER}}.jar {{SERVER_JARFILE}}"
	mv quilt-installer-{{BUILD_NUMBER}}.jar {{SERVER_JARFILE}}

	echo "Installtion succeeded, attempting to start the server!"
fi

java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true -jar {{SERVER_JARFILE}}