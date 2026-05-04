FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim@sha256:b28b90df3f3125630c263312a5f7e3d92f345c93039eae058cf144892dee1840

ARG project
ENV project=${project}
ADD script.sh /data/script.sh
ENTRYPOINT /data/script.sh ${project}
