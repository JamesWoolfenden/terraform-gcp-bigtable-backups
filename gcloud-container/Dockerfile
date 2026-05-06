FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim@sha256:42d0af3434d40a895da768a87001b87938c3ff2a0f16c81a00e78b857b75b611

ARG project
ENV project=${project}
ADD script.sh /data/script.sh
ENTRYPOINT /data/script.sh ${project}
