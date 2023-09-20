FROM python:3.10-alpine
# python v3.10 is the highest version (as of 6/28/23) that can be used with node-gyp
# FROM python:3.9.12-alpine3.15 // no longer available 

# ARG vars are env vars that are set at build time & only available to
# the Dockerfile. They are not available to the container when it is started.
ARG ARG_PYCTI_ENV
ARG ARG_PYCTI_TXT
ARG ENV_PUBLIC_TIM
ARG PYCTI_ARG=$PYCTI
ARG PYCTI ${PYCTI:-default}
RUN printf "~~~~~~~~~~~~~~~~>>>>>>>> \n \
        ARG_PYCTI_ENV: $ARG_PYCTI_ENV ${ARG_PYCTI_ENV} \n \
        ARG_PYCTI_TXT: $ARG_PYCTI_TXT ${ARG_PYCTI_TXT} \n \
        ENV_PUBLIC_TIM: $ENV_PUBLIC_TIM ${ENV_PUBLIC_TIM} \n \
        PRIVATE_TIM: $PRIVATE_TIM ${PRIVATE_TIM} \n \
        PYCTI_ARG: $PYCTI_ARG ${PYCTI_ARG} \n \
        PYCTI: $PYCTI ${PYCTI} \n \
    " $PRIVATE_TIM $ENV_PUBLIC_TIM $ARG_PYCTI_ENV $ARG_PYCTI_TXT $PYCTI_ARG $PYCTI

WORKDIR /TIM
RUN printf "\nCopying from [${PYCTI}] to image.\n"
# COPY client-python /TIM/pycti
COPY ${PYCTI} /TIM/pycti
##############################################################################################
# Upgrade PIP and wheel
##############################################################################################
RUN pip3 install --upgrade pip wheel

##############################################################################################
# Fixes the AttributeError: cython_sources error on build
##############################################################################################
RUN pip3 install "Cython>=3.0" "pyyaml>=6" --no-build-isolation

##############################################################################################
RUN pip3 install /TIM/pycti
# allows debugging a running container
RUN pip3 install debugpy 
RUN alias python3=python \
    && echo "*** COMMON SETTINGS Done ***"

# CMD executes when running container
CMD [ "python", "--version"]
