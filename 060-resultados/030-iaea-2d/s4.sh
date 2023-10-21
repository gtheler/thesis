feenox iaea-3dpwr-s4.fee --eps_monitor
mpiexec -n 2 feenox iaea-3dpwr-s4.fee --eps_monitor
mpiexec -n 4 feenox iaea-3dpwr-s4.fee --eps_monitor
mpiexec -n 12 feenox iaea-3dpwr-s4.fee --eps_monitor --eps_converged_reason --eps_type=jd --st_type=precond  --st_ksp_type=gmres --st_pc_type=asm
