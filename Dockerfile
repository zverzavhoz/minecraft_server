FROM ubuntu:16.10
MAINTAINER Igor Naumov <naumoffigor@gmail.com>
ENV MINECRAFT_VERSION 1.7.10
ENV FORGE_VERSION 10.13.4.1614
ENV FORGE_JAR forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-${MINECRAFT_VERSION}-universal.jar
ENV FORGE_INST forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-${MINECRAFT_VERSION}-installer.jar
#http://files.minecraftforge.net/maven/net/minecraftforge/forge/1.7.10-10.13.4.1614-1.7.10/forge-1.7.10-10.13.4.1614-1.7.10-installer.jar

ENV MINECRAFT_URL https://s3.amazonaws.com/Minecraft.Download/versions/${MINECRAFT_VERSION}/minecraft_server.${MINECRAFT_VERSION}.jar
ENV MINECRAFT_JAR minecraft_server.${MINECRAFT_VERSION}.jar
ENV FORGE_URL http://files.minecraftforge.net/maven/net/minecraftforge/forge/${MINECRAFT_VERSION}-${FORGE_VERSION}-${MINECRAFT_VERSION}/${FORGE_INST}

WORKDIR mineserver/
RUN apt-get update && apt-get install -y software-properties-common wget \
&& echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu yakkety main" | tee -a /etc/apt/sources.list \
&& echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu yakkety main" | tee -a /etc/apt/sources.list \
&& echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
&& apt-get update && apt-get install -y oracle-java8-installer ca-certificates \
&& wget -q ${MINECRAFT_URL} && wget -q ${FORGE_URL} \
&& java -jar ${FORGE_INST} --installServer \
&& echo eula=true > eula.txt \
&& apt-get autoremove -y && apt-get clean

COPY data /mineserver

EXPOSE 25565 25575

CMD java -jar ${FORGE_JAR}

