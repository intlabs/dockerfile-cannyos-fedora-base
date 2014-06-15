#
# CannyOS fedora base container
#
# https://github.com/intlabs/dockerfile-cannyos-fedora-base
#
# Copyright 2014 Pete Birley
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Pull base image.
FROM fedora:rawhide

MAINTAINER "Pete Birley (petebirley@gmail.com)"

# Set environment variables.
ENV HOME /root
ENV DISTRO fedora

# Install base utilities.
RUN yum update -y && yum install -y curl
RUN curl -s https://raw.githubusercontent.com/intlabs/cannyos-utils/master/base-containers/packages/packages-10.sh | bash

#Add files for root user.
ADD root /root
RUN chmod -R +x /root/scripts/*

#Create normal user
RUN curl -s https://raw.githubusercontent.com/intlabs/cannyos-utils/master/base-containers/add-user/adduser.sh | bash

# Set the working directory
WORKDIR /

#Add startup & post-install script
ADD CannyOS /CannyOS
WORKDIR /CannyOS
RUN chmod +x *.sh

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
ENTRYPOINT ["/CannyOS/startup.sh"]