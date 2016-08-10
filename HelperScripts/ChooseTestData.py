import numpy as np
import glob
import shutil

data_dirs = [['../Results/neg-train','../Predictions/train',8000],['../Results/pos-train','../Predictions/train',8000],['../Results/neg-val','../Predictions/test',500],['../Results/pos-val','../Predictions/test',500]]

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
