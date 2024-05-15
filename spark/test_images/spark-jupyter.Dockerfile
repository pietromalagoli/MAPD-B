FROM base-image

# -- Layer: notebook
RUN pip install notebook matplotlib

# -- Layer runtime
EXPOSE 8888
WORKDIR ${SHARED_WORKSPACE}

RUN apt-get clean

CMD jupyter notebook \
    --ip=0.0.0.0 \
    --port=8888 \
    --no-browser \
    --allow-root \
    --NotebookApp.token= 
