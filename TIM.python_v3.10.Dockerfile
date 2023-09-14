FROM python:3.10-alpine
# python v3.10 is the highest version (as of 6/28/23) that can be used with node-gyp
# FROM python:3.9.12-alpine3.15 // no longer available 

# ARG vars are env vars that are set at build time & only available to
# the Dockerfile. They are not available to the container when it is started.
ARG PYCTI

WORKDIR /TIM
RUN printf "\nCopying from [${PYCTI}] to image.\n"
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
