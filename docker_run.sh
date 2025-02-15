##########################################################
# Define user configuration variables
USER="macd"               # Username for the container
PASSWD=0221                  # Password (0 is likely a placeholder, update as needed)
docker_images_name="as2600_bmc:latest"  # Name and tag for the Docker image (lowercase only)
docker_container_name="as2600_qemu"    # Name for the Docker container (lowercase only)
docker_workspace_path="/home/$USER/asbmc_v9.5"  # Workspace path inside the container
##########################################################
# Run the Docker container
# Map the current directory to the workspace path inside the container
# Set the working directory and run the container as the specified user
# Assign the container the specified name

docker run -id -v `pwd`:$docker_workspace_path \
-w $docker_workspace_path --user $USER \
--net=host \
--name $docker_container_name $docker_images_name
