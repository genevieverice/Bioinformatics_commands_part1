# Accessing and setting up to use the cluster on MobaXterm

# First you see:
"<P-number>"@hpcloginresearch02.prod1.umcinfra.nl's password: 
# login like normal

# Should see your account on the login node:
[<P-number>@hpcloginresearch02 ~]$

# See what worker nodes are available, with available CPUS A/I/O/T (allocated/idle/other/total) and memory
sinfo -N -o "%N %t %c %C %m %e" 

# For worker nodes 1-9 use:
srun -w <worker#> --ntasks=1 --cpus-per-task=1 --time=05:00:00 --pty bash -i

# For worker nodes 10-14
srun -w <worker#> -p artemis --ntasks=1 --cpus-per-task=2 --time=08:00:00 --pty bash -i
srun -w <worker#> -p artemis --ntasks=1 --cpus-per-task=4 --mem=12G --time=08:00:00 --pty bash -i

# Connect to L-drive
kinit <P-number>@AMSTERDAMUMC.UMCINFRA.NL

# Link a folder from L-drive to cluster home folder
ln -s /net/cifs/...<folder name> <folder name>

# Install conda
cd /appdata/users/<P-number>
	wget http://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	bash Miniconda3-latest-Linux-x86_64.sh
	yes 
  /appdata/users/<P-number> 
  no

# Activate conda
source /appdata/users/<P-number>/miniconda3/etc/profile.d/conda.sh |
conda create -n <environment name> |
conda activate <environment name>

