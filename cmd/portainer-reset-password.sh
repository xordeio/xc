# Description: Updates portainer to latest version.
docker stop portainer && docker run --rm -v portainer_data:/data portainer/helper-reset-password && docker start portainer
