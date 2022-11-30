FROM --platform=linux/arm64 amd64/debian:buster

# Update and install software
RUN apt-get update -q \
	&& apt-get upgrade -qy \
	&& apt-get install -qy --no-install-recommends openjdk-11-jre -y \
	&& apt-get install -qy --no-install-recommends \
	bash \
	chromium \
	curl \
	expect \
	fluxbox \
	git \
	jq \
	net-tools \
	netcat \
	novnc \
	sudo \
	supervisor \
	x11vnc \
	xterm \
	xvfb

# Setup environment variables
ENV HOME=/home/burp \
	TZ=Europe/London \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
	DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
	RUN_SUPERVISORD=yes \
	RUN_NOVNC=no \
	ACTIVATE=no

# Setup timezone - this ensures we don't get asked to do this within the CLI during install
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add a burp user
RUN addgroup --system burp && \
  adduser --system --disabled-password --gecos '' --ingroup burp burp

# Remove password prompt for burp
RUN echo '%burp ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy files over to the container and add the BurpSuite Licence
RUN mkdir -p ${HOME}/.java/.userPrefs/burp
RUN mkdir -p ${HOME}/.BurpSuite
RUN mkdir -p ${HOME}/.cache
RUN mkdir -p ${HOME}/.config
COPY . ${HOME}/
RUN mv ${HOME}/prefs.xml ${HOME}/.java/.userPrefs/burp/prefs.xml

# Set home as the working directory
WORKDIR ${HOME}

# Download and install fresh copy of BurpSuite
RUN chmod +x ~/app/download.sh
RUN ~/app/download.sh

# Add permissions to execute scripts
RUN chmod +x ~/app/activate.sh
RUN chmod +x ~/app/entrypoint.sh

# Make the burp user the owner of the app files
RUN chown burp:burp ~/app -R
RUN chown burp:burp ~/.java -R
RUN chown burp:burp ~/.BurpSuite -R
RUN chown burp:burp ~/.cache -R
RUN chown burp:burp ~/.config -R

# change the burp password to 'burp'
RUN echo 'burp:burp' | chpasswd
# change the root password to 'root'
RUN echo 'root:root' | chpasswd

# set the user to burp
USER burp

ENTRYPOINT ["/home/burp/app/entrypoint.sh"]