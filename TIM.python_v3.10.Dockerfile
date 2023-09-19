FROM python:3.10-alpine
# python v3.10 is the highest version (as of 6/28/23) that can be used with node-gyp
# FROM python:3.9.12-alpine3.15 // no longer available 

WORKDIR /TIM

# COPY client-python /TIM/pycti
COPY $PYCTI /TIM/pycti
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
CMD [ "python", "--version"]
