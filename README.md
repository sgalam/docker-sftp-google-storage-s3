# docker-sftp-google-storage-s3
this docker container mount your GoogleStorage/S3 bucket into a folder exposed via SFTP. Afterthat you can SFTP directly your bucker!

# to build the image
```
git clone https://github.com/sgalam/docker-sftp-google-storage-s3.git
cd /docker-sftp-google-storage-s3
docker build -t s3fs-debian-docker .
```

# to run the container
```
docker run -d -p 11022:22 --cap-add mknod --cap-add sys_admin --device=/dev/fuse  -t s3fs-debian-docker
```
# configuration 
- into s3passwd (to store your bucketname and acess keys) 
- in the ENV values of Dockerfile

# debug
to attach the started container and debug what is happening:
"405ceed6568b88027cd33bcc6e75c4a5366ade5085a478f132419f226fd160c4" is taken from docket ps
```
docker exec -i 405ceed6568b88027cd33bcc6e75c4a5366ade5085a478f132419f226fd160c4 bash
```
