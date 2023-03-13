SERVER_JARFILE=$1
MINECRAFT_VERSION=$2
BUILD_NUMBER=$3
echo "Checking if ${SERVER_JARFILE} exists"
if ! [ -f ${SERVER_JARFILE} ]; then
	echo "${SERVER_JARFILE} does not exist, attempting to install"
	if ! [ -f quilt-installer-${BUILD_NUMBER}.jar ]; then
    	echo "$quilt-installer-${BUILD_NUMBER}.jar does not exist"
        BUILD_NUMBER=latest
        echo "attempting lastest (quilt-installer-${BUILD_NUMBER}.jar)"
		if ! [ -f quilt-installer-${BUILD_NUMBER}.jar ]; then
            echo "Invalid install! Please reinstall your server!"
            exit 1
		fi
	fi
	echo -e "Running java -jar quilt-installer-${BUILD_NUMBER}.jar install server ${MINECRAFT_VERSION} --download-server"
	java -jar quilt-installer-${BUILD_NUMBER}.jar install server ${MINECRAFT_VERSION} --download-server
	mv ./server/* ./

	echo "Installtion succeeded, attempting to start the server!"
fi
echo "Server jar exists, starting server!"
java -Xms128M -XX:MaxRAMPercentage=95.0 -Dterminal.jline=false -Dterminal.ansi=true -jar ${SERVER_JARFILE}