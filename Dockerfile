FROM kaixhin/theano

RUN apt-get install -y libyaml-dev liblapack-dev libopenblas-dev libopencv-dev python-opencv libhdf5-dev gfortran unzip

RUN pip install cython
RUN pip install h5py
RUN pip install -U six
RUN pip install matplotlib
RUN pip install scikit-image

# Install keras == 0.3.1 to prevent errors:
# 'Graph' object has no attribute 'layers'
# 'Graph' object has no attribute 'params'
RUN pip install -I keras==0.3.1

RUN git clone https://github.com/pdollar/coco.git && cd coco/PythonAPI && make install

# MSCOCO
RUN cd / && wget 'http://msvocds.blob.core.windows.net/annotations-1-0-3/instances_train-val2014.zip' && \
  unzip instances_train-val2014.zip && \
  rm instances_train-val2014.zip
RUN cd /annotations && wget 'http://msvocds.blob.core.windows.net/coco2014/train2014.zip' && \
  unzip train2014.zip && \
  rm train2014.zip
RUN cd /annotations && wget 'http://msvocds.blob.core.windows.net/coco2014/val2014.zip' && \
  unzip val2014.zip && \
  rm val2014.zip
RUN cd /annotations && ln -s train2014 images_train
RUN cd /annotations && ln -s val2014 images_val

COPY . /deepmask

WORKDIR /deepmask/

RUN mkdir Resources Predictions Results annotations \
  Predictions/nets Predictions/test Predictions/train \
  Predictions/test_predictions Predictions/train_predictions \
  Results/pos-train Results/neg-train Results/pos-val Results/neg-val

RUN cp -v /annotations/*.json annotations/

# VGG-D
RUN wget 'https://raw.githubusercontent.com/Nanolx/patchimage/master/tools/gdown.pl' && \
  chmod +x gdown.pl && \
  ./gdown.pl 'https://docs.google.com/uc?id=0Bz7KyqmuGsilT0J5dmRCM0ROVHc&export=download' Resources/vgg16_weights.h5

# `ln` needed to fix: libdc1394 error: Failed to initialize libdc1394
RUN ln /dev/null /dev/raw1394 && cd HelperScripts && python -u CreateVggGraphWeights.py
RUN ln /dev/null /dev/raw1394 && python -u ExamplesGenerator.py

RUN cd HelperScripts && python -u ChooseTestData.py
RUN find Predictions/train -type f | wc -l
RUN find Predictions/test -type f | wc -l
# RUN find Results/pos-train/ Results/neg-train/ -type f -exec mv -t Predictions/train/ {} +
# RUN find Results/pos-val/ Results/neg-val/ -type f -exec mv -t Predictions/test/ {} +
RUN cat ~/.keras/keras.json
RUN echo "[global]\nopenmp=True" > /root/.theanorc
RUN ln /dev/null /dev/raw1394 && python -u EndToEnd.py
