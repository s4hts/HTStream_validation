for i in `squeue -o "%.i" -u keithgmitchell`; do cat slurmout/*${i}.out; done
