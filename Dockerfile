FROM kaixhin/theano

RUN apt-get install -y libyaml-dev liblapack-dev libopenblas-dev libopencv-dev python-opencv libhdf5-dev gfortran

RUN pip install cython
RUN pip install h5py
RUN pip install -U six

# Install keras < 1.0 to prevent error:
# 'Graph' object has no attribute 'layers'
RUN pip install -I keras==0.3.3

RUN git clone https://github.com/pdollar/coco.git && cd coco/PythonAPI && make install

COPY . /deepmask

WORKDIR /deepmask/

RUN mkdir Resources
# COPY ./vgg16_weights.h5 Resources/vgg16_weights.h5
RUN wget 'https://raw.githubusercontent.com/Nanolx/patchimage/master/tools/gdown.pl' && \
  chmod +x gdown.pl && \
  ./gdown.pl 'https://docs.google.com/uc?id=0Bz7KyqmuGsilT0J5dmRCM0ROVHc&export=download' Resources/vgg16_weights.h5

# `ln` needed to fix: libdc1394 error: Failed to initialize libdc1394
RUN ln /dev/null /dev/raw1394 && cd HelperScripts && python CreateVggGraphWeights.py
