FROM ubuntu:16.10
ENV MINECRAFT_VERSION 1.7.10
ENV FORGE_VERSION 10.13.4.1614
ENV FORGE_JAR forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-${MINECRAFT_VERSION}-universal.jar
ENV FORGE_INST forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-${MINECRAFT_VERSION}-installer.jar
#http://files.minecraftforge.net/maven/net/minecraftforge/forge/1.7.10-10.13.4.1614-1.7.10/forge-1.7.10-10.13.4.1614-1.7.10-installer.jar

ENV MINECRAFT_URL https://s3.amazonaws.com/Minecraft.Download/versions/${MINECRAFT_VERSION}/minecraft_server.${MINECRAFT_VERSION}.jar
ENV MINECRAFT_JAR minecraft_server.${MINECRAFT_VERSION}.jar
ENV FORGE_URL http://files.minecraftforge.net/maven/net/minecraftforge/forge/${MINECRAFT_VERSION}-${FORGE_VERSION}-${MINECRAFT_VERSION}/${FORGE_INST}

RUN apt-get update && apt-get install -y software-properties-common wget
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu yakkety main" | tee -a /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu yakkety main" | tee -a /etc/apt/sources.list
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && apt-get update && apt-get install -y curl dnsutils oracle-java8-installer ca-certificates

RUN mkdir mineserver
WORKDIR /mineserver
#RUN wget -q https://s3.amazonaws.com/Minecraft.Download/versions/1.7.10/minecraft_server.1.7.10.jar
#RUN wget -q http://files.minecraftforge.net/maven/net/minecraftforge/forge/1.7.10-10.13.4.1614-1.7.10/forge-1.7.10-10.13.4.1614-1.7.10-installer.jar
RUN wget -q ${MINECRAFT_URL}
RUN wget -q ${FORGE_URL}

RUN java -jar ${FORGE_INST} --installServer

#RUN mkdir /world \
#  && mkdir /config \
#  && mkdir /mods \

COPY mods ./ \
	config ./ \
	world ./

EXPOSE 25565 25575
RUN echo eula=true > eula.txt
CMD java -jar ${FORGE_JAR}
#RUN  java -jar forge-1.7.10-10.13.4.1614-1.7.10-installer.jar --installServer

