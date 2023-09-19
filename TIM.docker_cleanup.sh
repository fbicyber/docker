#!/bin/bash

printf "\nExecuting Docker cleanup.\n"
# Stop all containers at once
docker-compose --project-name tim -f TIM.docker-compose.yml --env-file $TIM_ENV_FILE down

if [ $VISIBILITY = "PRIVATE" ]; then
    docker-compose --project-name tim -f TIM.extractor.docker-compose.yml --env-file $TIM_ENV_FILE down
fi

# remove TIM locally built images
if [ ! "$(docker ps -a | grep tim)" ] ; then
    printf "Running docker rmi\n"
    docker rmi $(docker images | grep tim | awk '{print $3}')
fi

docker system prune

printf "\nDocker cleanup complete.\n"