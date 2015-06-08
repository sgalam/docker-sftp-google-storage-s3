FROM debian:wheezy
MAINTAINER Matteo Sgalaberni <sgala@sgala.com>

#values to change
ENV SFTP_USER backup_user
ENV SFTP_PASSWORD yoursftpuserpasswwd
ENV YOUR_BUCKET_NAME yourbucketname
# /finish values to change

ENV YOUR_MOUNT_POINT /backup_user/s3_mount/
ENV YOUR_PASSWORD_FILE /s3_app/s3passwd

RUN apt-get update -qq
RUN apt-get install -y openssh-server

RUN mkdir /var/run/sshd

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support automake libtool wget tar

# download the 1.78 version of s3fs-fuse
RUN wget https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.78.tar.gz -O /usr/src/v1.78.tar.gz

# build it
RUN tar xvz -C /usr/src -f /usr/src/v1.78.tar.gz
RUN cd /usr/src/s3fs-fuse-1.78 && ./autogen.sh && ./configure --prefix=/usr && make && make install


# creating an chroot SFTP enviroment 
RUN mkdir /s3_app/
ADD /s3passwd /s3_app/s3passwd
RUN chmod 600 /s3_app/s3passwd

ENV YOUR_BUCKET_NAME testveloce
ENV YOUR_MOUNT_POINT /backup_user/s3_mount/
ENV YOUR_PASSWORD_FILE /s3_app/s3passwd

RUN mkdir /backup_user/

RUN /usr/sbin/adduser --disabled-password --gecos "" --shell /bin/false --home /backup_user/ $SFTP_USER

RUN echo "$SFTP_USER:SFTP_PASSWORD" | chpasswd $SFTP_USER

RUN mkdir $YOUR_MOUNT_POINT
RUN chown $SFTP_USER $YOUR_MOUNT_POINT

RUN echo "Match User $SFTP_USER\nChrootDirectory %h\nForceCommand internal-sftp">>/etc/ssh/sshd_config

ADD /container_run.sh /s3_app/container_run.sh
RUN chmod 700 /s3_app/container_run.sh

EXPOSE 22

CMD ["/s3_app/container_run.sh"]
