#!/bin/ash
# Quilt Installation Script
#
# Server Files: /mnt/server

if [ -n "${DL_PATH}" ]; then
    echo -e "Using supplied download url: ${DL_PATH}"
    DOWNLOAD_URL=`eval echo $(echo ${DL_PATH} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
else
    VER_EXISTS=`curl -s https://meta.quiltmc.org/v3/versions/game | jq -r --arg VERSION ${MINECRAFT_VERSION} '[.[] | select(.stable == true)][] | .version | contains($VERSION)' | grep -m1 true`
    LATEST_VERSION=`curl -s https://meta.quiltmc.org/v3/versions/game | jq -r '[.[] | select(.stable == true)][0] | .version'`

    if [ "${VER_EXISTS}" == "true" ]; then
        echo -e "Version is valid. Using version ${MINECRAFT_VERSION}"
    else
        echo -e "Specified version not found, or specified version was 'latest'. Defaulting to the latest quilt version: ${LATEST_VERSION}"
        MINECRAFT_VERSION=${LATEST_VERSION}
    fi

    BUILD_EXISTS=`curl -s https://meta.quiltmc.org/v3/versions/installer | jq -r --arg VERSION ${BUILD_NUMBER} '.[] | .version | contains($VERSION)' | grep -m1 true`
    LATEST_BUILD=`curl -s https://meta.quiltmc.org/v3/versions/installer | jq -r '.[0] | .version '`

    if [ "${BUILD_EXISTS}" == "true" ] || [ "${BUILD_NUMBER}" == "latest" ]; then
        echo -e "Build is valid for version using build ${BUILD_NUMBER}"
    else
        echo -e "Using the latest build for Quilt"
        BUILD_NUMBER=${LATEST_BUILD}
    fi


    JAR_NAME=quilt-installer-${BUILD_NUMBER}.jar
    echo "Version being downloaded"
    echo -e "    Build: ${BUILD_NUMBER}"
    echo -e "    JAR Name of Build: ${JAR_NAME}"
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