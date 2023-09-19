#!/bin/bash

printf "\nExecuting Docker cleanup.\n"
# Stop all containers at once
docker-compose --project-name tim -f TIM.docker-compose.yml --env-file $TIM_ENV_FILE down

# remove TIM locally built images
docker rmi $(docker images | grep tim | awk '{print $3}') 

docker system prune

printf "\nDocker cleanup complete.\n"