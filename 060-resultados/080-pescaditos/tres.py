from scipy.optimize import minimize 
import numpy as np
 

def func(x):
    x = x[0]**2+x[1]**2
    return x

x0 = [-1,1]
result = minimize(func, x0, method="nelder-mead")
print(result)
