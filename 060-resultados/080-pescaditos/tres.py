#!/usr/bin/python
from scipy.optimize import minimize 
import numpy as np
import subprocess

def keff(x3):
  r = subprocess.run(["bash", "tres.sh", "(%s)" % str(x3[0]), "(%s)" % str(x3[1])], stdout=subprocess.PIPE)
  k = float(r.stdout.decode('utf-8'))
  return k

x3_0 = [+25, -25]
result = minimize(keff, x3_0, method="nelder-mead")
print(result)
