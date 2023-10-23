#!/usr/bin/python
from scipy.optimize import minimize 
import numpy as np
import subprocess

def keff(x):
  r = subprocess.run(["bash", "tres.sh", "(%s)" % str(x[0]), "(%s)" % str(x[1])], stdout=subprocess.PIPE)
  k = float(r.stdout.decode('utf-8'))
  print("%g\t%g\t%g" % (x[0], x[1], k))
  return k

x0 = [+25, -25]
result = minimize(keff, x0, method="nelder-mead", options = {"fatol": 1e-5, "xatol": 1})
print(result)
