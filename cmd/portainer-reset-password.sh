# Description: Resets Portainer password, new password will be shown in output
docker stop portainer && docker run --rm -v portainer_data:/data portainer/helper-reset-password && docker start portainer
