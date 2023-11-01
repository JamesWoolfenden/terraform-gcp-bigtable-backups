FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim

ARG project
ENV project=${project}
ADD script.sh /data/script.sh
ENTRYPOINT /data/script.sh ${project}
