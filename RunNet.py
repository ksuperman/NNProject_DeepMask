import sys
import datetime
import glob
import os
from Constants import mask_threshold
from FullNetGenerator import *
from ImageUtils import *
from keras.optimizers import SGD
from Losses import *
import math

sgd_lr = 0.001
sgd_decay = 0.00005
sgd_momentum = 0.9

# paths:
graph_arch_path = 'Resources/graph_architecture_with_transfer.json'

def load_saved_net(graph_weights_path):
  print('loading net...')
  net = model_from_json(open(graph_arch_path).read())
  net.load_weights(graph_weights_path)
  return net

def run_net_predictions(net, images, predictions_path):
  predictions = net.predict({'input': images})
  for i in range(len(predictions['seg_output'])):
    mask = predictions['seg_output'][i]
    prediction_path = '%s/pic%d.png' % (predictions_path, i)
    binarize_and_save_mask(mask, mask_threshold, prediction_path)

def compile_net(net):
  print('compiling net...')
  sgd = SGD(lr=sgd_lr, decay=sgd_decay, momentum=sgd_momentum, nesterov=True)
  net.compile(optimizer=sgd, loss={'score_output': binary_regression_error,
                                   'seg_output': mask_binary_regression_error})
  return net

def main():
  print(sys.argv)
  graph = load_saved_net(sys.argv[1])
  compile_net(graph)

  print('loading images...')
  ex_paths = glob.glob('%s/*-im.png' % sys.argv[2])
  images = prepare_local_images(ex_paths)

  print('running predictions...')
  run_net_predictions(graph, images, sys.argv[3])

if __name__ == "__main__":
    main()
