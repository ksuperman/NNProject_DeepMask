import numpy as np
import glob
import shutil

train_samples = 1000
test_samples = train_samples/16

data_dirs = [['../Results/neg-train','../Predictions/train',train_samples],['../Results/pos-train','../Predictions/train',train_samples],['../Results/neg-val','../Predictions/test',test_samples],['../Results/pos-val','../Predictions/test',test_samples]]

for data_dir in data_dirs:
    source_dir = data_dir[0]
    dest_dir = data_dir[1]
    num_samples = data_dir[2]

    print source_dir
    print dest_dir

    ex_paths = glob.glob('%s/*-im.png' % source_dir)
    np.random.shuffle(ex_paths)
    selected = ex_paths[0:num_samples]

    for sel in selected:
        shutil.copy(sel, dest_dir)
        shutil.copy(sel.replace('im', 'mask'), dest_dir)
