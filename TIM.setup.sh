#!/bin/bash

# ***
# Uncomment needed connectors in the yaml file ...
# ***

# **
# default values
# **
DOCKER_CLEAN=false
RUN_DOCKER=false
UPDATE_BRANCH=false
export TIM_ENV_FILE=TIM.env
export DOCKER_DIR="$(dirname $(realpath "$0"))"
export VISIBILITY=PRIVATE

# **
# consume .env file variables and make values available to script
# **
if [ -f $TIM_ENV_FILE ]
then
  export $(cat $TIM_ENV_FILE | xargs)
fi

usage_msg="
usage: $0 [-dghrUv] [-b (branch)] [-D (directory)]\n
  Setup and run OpenCTI with TIM in a Docker environment.
    -v [visibility] PRIVATE (default) or PUBLIC.  Determines BRANCH, GIT_URL and BASE_DIR.
    -b [branch] branch to clone from (defaults are PRIVATE: master-TIM; PUBLIC: master)
    -D [directory] (defaults are PRIVATE: ~/projects/threat_intel; PUBLIC: ~/projects/threat_intel_public)
    -d [destroy] remove all containers built by the tim project
    -g overwrite existing environment and configutation files with base config
    -r [run] docker creation
    -U [update] branch by executing a git pull, if previously cloned
    -h this help message\n
"

while getopts "hdgrUb:D:v:" option ; do
    case "$option" in
        h ) 
            printf "$usage_msg";
            exit 0
            ;;
        d ) 
            printf "Cleaning up the docker environment.\n"
            DOCKER_CLEAN=true
            ;;
        D )
            OPT_BASE_DIR=$OPTARG
            printf "Base directory option is [$OPT_BASE_DIR]\n"
            ;;
        b )
            OPT_BRANCH=$OPTARG
            printf "Branch option is [$OPT_BRANCH]\n"
            ;;
        g )
            GEN_CONFIG_FILES=true
            ;;
        r ) 
            printf "Executing docker creation.\n"
            RUN_DOCKER=true
            ;;
        U )
            UPDATE_BRANCH=true
            ;;
        v )
            VISIBILITY=$OPTARG
            printf "Visibility is [$VISIBILITY]\n"
            ;;
        * )
            echo "error: option -$OPTARG is not implemented\n"; 
            exit 1
            ;;
    esac
done
if [ $OPTIND -eq 1 ]; then printf "$usage_msg"; exit 1; fi
shift $(( OPTIND - 1 ))

export VISIBILITY
printf "\n==> VISIBILITY is [$VISIBILITY]\n"

# **
printf "\n==> identify base directory\n"
# **
if [ -n "${OPT_BASE_DIR+x}" ]; then
    printf "Base directory [$OPT_BASE_DIR] supplied.\n"
    BASE_DIR=$OPT_BASE_DIR
else
    # printf "Base directory NOT supplied.\n"
    BASE_DIR=${VISIBILITY}'_TIM'
    BASE_DIR=${!BASE_DIR}
fi
export BASE_DIR="$(eval echo $BASE_DIR)"
printf "Base directory is set to [${BASE_DIR}]\n"

# **
printf "\n==> create base directory [$BASE_DIR], as needed\n"
# **
if [ ! -d $BASE_DIR ]; then
    printf "creating base_dir [$BASE_DIR]\n"
    mkdir $BASE_DIR
fi

# **
printf "\n==> establish git url\n"
# **
GIT_URL=${VISIBILITY}'_GIT_URL'
GIT_URL=${!GIT_URL}
GIT_URL="$(eval echo $GIT_URL)"
printf "Git URL is set to [${GIT_URL}]\n"

# **
printf "\n==> establish branch\n"
# **
if [ -n "${OPT_BRANCH+x}" ]; then
    # printf "Branch supplied.\n"
    BRANCH=$OPT_BRANCH
else
    # printf "Branch NOT supplied.\n"
    if [ $VISIBILITY = "PUBLIC" ]; then
        BRANCH="master"
    else
        BRANCH="master-TIM"
    fi
fi
printf "BRANCH is set to [${BRANCH}]\n"

# **
printf "\n==> setup project names based on visibility of [$VISIBILITY]\n"
# **
PREFIX=""
if [ $VISIBILITY = "PUBLIC" ]; then
    PREFIX="opencti__"
fi
export CONNECTORS=$PREFIX'connectors'
export OPENCTI=$PREFIX'opencti'
export PYCTI=$PREFIX'client-python'
PROJECTS="$CONNECTORS $OPENCTI $PYCTI"
for project in $PROJECTS; do
    printf "$project\n"
done

# **
printf "\n==> clone and/or update projects\n"
# **
for project in ${PROJECTS}; do
    printf "\nchecking project [$project] to clone or update\n"
    PROJECT_DIR=$BASE_DIR/$project

    if [ ! -d $PROJECT_DIR ] ; then
        printf "Project directory [$PROJECT_DIR] does not exist, cloning [$GIT_URL/$project] on branch [$BRANCH]\n"
        git clone --branch $BRANCH $GIT_URL/$project $BASE_DIR/$project
    fi
    
    if [ -d $PROJECT_DIR ] && [ "$UPDATE_BRANCH" = true ]; then
        printf "[$project] repository exists. Updating local repository\n"
        git -C $PROJECT_DIR checkout $BRANCH
        git -C $PROJECT_DIR pull
    fi
done

if [ $VISIBILITY = "PRIVATE" ]; then
    EXTRACTOR_BRANCH=master
    EXTRACTOR_DIR=$BASE_DIR/cygnus/extractor
    EXTRACTOR_GIT=$GIT_URL/cygnus/enrichment-services/extractor
    if [ ! -d "$EXTRACTOR_DIR" ]; then
        git clone --branch $EXTRACTOR_BRANCH $EXTRACTOR_GIT $EXTRACTOR_DIR
    fi
fi

CONFIG_CONNECTOR() {
    CONN_CONFIG=$1
    printf "Configuring connector with [$CONN_CONFIG] file.\n"
    case "$CONN_CONFIG" in
        # case stmt does not use regex, but shell pattern matching only
        *import-actor* )
            printf "\nWriting import actor configuration.\n"
            ./TIM.config.import.actor.sh $CONN_CONFIG
            ;;        
        *import-extraction* )
            printf "\nWriting import extraction configuration.\n"
            ./TIM.config.import.extract.sh $CONN_CONFIG
            ;;        
        *import-file-stix* ) 
            printf "\nWriting import file stix configuration.\n"
            ./TIM.config.import.stix.sh $CONN_CONFIG
            ;;        
        * )
            echo "error: option -$OPTARG is not implemented\n"; 
            exit 1
            ;;
    esac
}

# **
printf "\n==> setup connector config.yml file locations\n"
# **
CONN_PATH=$BASE_DIR/$CONNECTORS/internal-import-file
export IMPORT_ACTOR=$CONN_PATH/import-actor/src/config
export IMPORT_EXTRACT=$CONN_PATH/import-extraction/src
export IMPORT_STIX=$CONN_PATH/import-file-stix/src
CONNECTOR_PATHS="$IMPORT_ACTOR $IMPORT_EXTRACT $IMPORT_STIX"
for C_PATH in $CONNECTOR_PATHS; do
    if [ -d $C_PATH ]; then
        CONN_CONFIG=$C_PATH/config.yml
        printf "Configuring [$CONN_CONFIG]\n"
        if [ "$GEN_CONFIG_FILES" = true ]; then
            # force write new config files
            CONFIG_CONNECTOR $CONN_CONFIG
        else
            # only write new config files if they do not exist
            if [ -f $C_PATH/config.yml ]; then
                CONFIG_CONNECTOR $CONN_CONFIG
            fi
        fi
    else
        printf "[$C_PATH] path does not exist.\n"
    fi
done

RUN_DOCKER() {
    docker-compose --project-name tim --env-file $TIM_ENV_FILE -f ./TIM.docker-compose.yml up --force-recreate --build -d
} 

if [[ $DOCKER_CLEAN == true ]]
then
    ./TIM.docker_cleanup.sh
fi

if [[ $RUN_DOCKER == true ]]
then
    RUN_DOCKER
fi