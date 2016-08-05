FROM kaixhin/theano

RUN apt-get install -y libyaml-dev liblapack-dev libopenblas-dev libopencv-dev python-opencv libhdf5-dev gfortran unzip

RUN pip install cython
RUN pip install h5py
RUN pip install -U six

# Install keras == 0.3.1 to prevent errors:
# 'Graph' object has no attribute 'layers'
# 'Graph' object has no attribute 'params'
RUN pip install -I keras==0.3.1

RUN git clone https://github.com/pdollar/coco.git && cd coco/PythonAPI && make install

COPY . /deepmask

WORKDIR /deepmask/

RUN mkdir Resources Predictions Results \
  Predictions/nets Predictions/test Predictions/train \
  Predictions/test_predictions Predictions/train_predictions

# MSCOCO
RUN wget 'http://msvocds.blob.core.windows.net/annotations-1-0-3/instances_train-val2014.zip' && \
  unzip instances_train-val2014.zip && \
  rm instances_train-val2014.zip

# VGG-D
RUN wget 'https://raw.githubusercontent.com/Nanolx/patchimage/master/tools/gdown.pl' && \
  chmod +x gdown.pl && \
  ./gdown.pl 'https://docs.google.com/uc?id=0Bz7KyqmuGsilT0J5dmRCM0ROVHc&export=download' Resources/vgg16_weights.h5

# `ln` needed to fix: libdc1394 error: Failed to initialize libdc1394
RUN ln /dev/null /dev/raw1394 && cd HelperScripts && python CreateVggGraphWeights.py
RUN ln /dev/null /dev/raw1394 && python EndToEnd.py
