FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim@sha256:42d0af3434d40a895da768a87001b87938c3ff2a0f16c81a00e78b857b75b611

# create a non-root user and group
RUN groupadd -r app && useradd -r -g app app

# add script, ensure executable and set ownership
COPY script.sh /data/script.sh
RUN mkdir -p /data && chown -R app:app /data && chmod +x /data/script.sh

USER app

# Exec form performs no variable expansion, so the script reads the project
# from the "project" environment variable the module sets on the job.
ENTRYPOINT ["/data/script.sh"]
