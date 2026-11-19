# Work on a slurm cluster (bash)
# start tmux on the login node first, then request the interactive job inside it,
# so the session survives a dropped connection

## tmux: new session, list sessions, reattach (detach with Ctrl+b then d)
tmux new -s <session_name>
tmux ls
tmux attach -t <session_name>

## interactive job on a compute node
srun --partition=<partition> --cpus-per-task=<threads> --mem=<memory_gb>G --time=<hh:mm:ss> --pty bash

## renew the login ticket for a network share
kinit

## activate the environment holding a tool
conda activate <env_name>

## what is running
squeue -u $USER

## cancel a job
scancel <job_id>

## was the last command killed? 137 means yes, usually out of memory
echo $?

## peak memory of a command
/usr/bin/time -v <command> 2> <time.log>
grep "Maximum resident" <time.log>

## memory and time a finished job used
seff <job_id>
