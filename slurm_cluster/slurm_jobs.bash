# Slurm: job options, batch scripts, and checking on jobs (bash)

## set the time limit of a job (works for srun and sbatch)
# -t HH:MM:SS    or    --time=HH:MM:SS

## write a batch job script (everything up to the closing EOF goes into the file)
cat > /appdata/users/<P-number>/ancestry/run_mpileup.sh << 'EOF'
#!/bin/bash
#SBATCH -c 8
#SBATCH --job-name=test
#SBATCH --time=01:00:00
#SBATCH --output=/appdata/users/<P-number>/ancestry/test_%j.log

<command>
EOF

## what the #SBATCH lines mean
# -c 8             number of CPU cores
# --job-name       name shown in the queue
# --time           time limit
# --output         log file; %j is replaced by the job number

## submit the script
sbatch /appdata/users/<P-number>/ancestry/run_mpileup.sh

## choose a worker node when launching R / jupyter
# in the "custom SLURM arguments" box:
# -w <worker#>

## list jobs in the queue
## columns: job number, partition, job name, user, state, time used, number of nodes, node names
squeue -o "%.18i %.10P %.20j %.12u %.2t %.10M %.6D %N"

## list worker nodes
## columns: node, state, CPUs, memory, free memory, CPUs allocated/idle/other/total
sinfo -N -o "%N %t %c %m %e %C"

## look up the email address of a user
nop <P-number>

## check if a job is still running
squeue -u <P-number>

## if it is still running, terminate it
scancel <job_id>
