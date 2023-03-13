#!/bin/ash
# Quilt Installation Script
#
# Server Files: /mnt/server
PROJECT=paper

if [ -n "${DL_PATH}" ]; then
    echo -e "Using supplied download url: ${DL_PATH}"
    DOWNLOAD_URL=`eval echo $(echo ${DL_PATH} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
else
    #I am leaving this the same as I will assume that Quilt uses the same minecraft versions as PaperMC
    VER_EXISTS=`curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r --arg VERSION $MINECRAFT_VERSION '.versions[] | contains($VERSION)' | grep -m1 true`
    LATEST_VERSION=`curl -s https://api.papermc.io/v2/projects/${PROJECT} | jq -r '.versions' | jq -r '.[-1]'`

    if [ "${VER_EXISTS}" == "true" ]; then
        echo -e "Version is valid. Using version ${MINECRAFT_VERSION}"
    else
        echo -e "Specified version not found. Defaulting to the latest ${PROJECT} version"
        MINECRAFT_VERSION=${LATEST_VERSION}
    fi

    BUILD_EXISTS=`curl -o /dev/null --silent -Iw '%{http_code}' https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/${BUILD_NUMBER}/quilt-installer-${BUILD_NUMBER}.jar`

    if [ "${BUILD_EXISTS}" == "200" ]; then
        echo -e "Build is valid for version using build ${BUILD_NUMBER}"
    else
        echo -e "Using the latest build for Quilt"
        BUILD_NUMBER="latest"
    fi


    JAR_NAME=quilt-installer-${BUILD_NUMBER}.jar
    echo "Version being downloaded"
    echo -e "Build: ${BUILD_NUMBER}"
    echo -e "JAR Name of Build: ${JAR_NAME}"
    DOWNLOAD_URL=https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/${BUILD_NUMBER}/${JAR_NAME}
fi

cd /mnt/server

echo -e "Running curl -L -o quilt-installer-${BUILD_NUMBER}.jar ${DOWNLOAD_URL}"

if [ -f quilt-installer-${BUILD_NUMBER}.jar ]; then
    mv quilt-installer-${BUILD_NUMBER}.jar quilt-installer-${BUILD_NUMBER}.jar.old
fi

curl -L -o quilt-installer-${BUILD_NUMBER}.jar ${DOWNLOAD_URL}

if [ ! -f server.properties ]; then
    echo -e "Downloading MC server.properties"
    curl -o server.properties https://raw.githubusercontent.com/parkervcp/eggs/master/minecraft/java/server.properties
fi

if [ ! -f start.sh ]; then
    echo -e "Downloading custom start.sh for quilt"
    curl -o start.sh https://raw.githubusercontent.com/Plasmaman916/eggs/master/game_eggs/minecraft/java/quilt/start.sh
fi