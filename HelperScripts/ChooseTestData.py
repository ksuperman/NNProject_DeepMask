import numpy as np
import glob
import shutil

dirs = [['../Results/neg-train','../Predictions/train'],['../Results/pos-train','../Predictions/train'],['../Results/neg-val','../Predictions/test'],['../Results/pos-val','../Predictions/test']]

for pair in dirs:
    source_dir = pair[0]
    dest_dir = pair[1]
    print source_dir
    print dest_dir

    ex_paths = glob.glob('%s/*-im.png' % source_dir)
    np.random.shuffle(ex_paths)
    selected = ex_paths[0:8000]

    for sel in selected:
        shutil.copy(sel, dest_dir)
        shutil.copy(sel.replace('im', 'mask'), dest_dir)
