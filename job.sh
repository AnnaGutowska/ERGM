#!/bin/bash

#SBATCH --partition=main           # Partition (job queue)

#SBATCH --requeue                 # Return job to the queue if preempted

#SBATCH --job-name=zipx001a	  # Assign a short name to your job

#SBATCH --nodes=1                # Number of nodes you require

#SBATCH --ntasks=1          # Total # of tasks across all nodes

#SBATCH --cpus-per-task=1         # Cores per task (>1 if multithread tasks)

#SBATCH --mem=128000                # Real memory (RAM) required (MB)

#SBATCH --time=72:00:00           # Total run time limit (HH:MM:SS)

#SBATCH --output=slurm.%N.%j.out  # STDOUT output file

#SBATCH --error=slurm.%N.%j.err   # STDERR output file (optional)

module purge 

module use /projects/community/modulefiles/

module load R/4.1.0-gc563 

srun Rscript ergm.R
