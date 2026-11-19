# Keep work running on the cluster with tmux (bash)
# lines starting with "# Ctrl" are key presses, not commands:
# press Ctrl+b, release, then press the next key
# the job runs until it finishes or reaches the cluster's time limit

## start a tmux session (on the login node)
tmux new -s <session_name>

## log in to a worker node
srun -w <worker_node> -p <partition> --ntasks=1 --cpus-per-task=<threads> --mem=<memory_gb>G --time=<hh:mm:ss> --pty bash -i

## connect to the network drive
kinit <user>@<realm>

## detach from the session (everything keeps running)
# Ctrl+b, d

## log out of the worker node (ends the job)
exit

## list tmux sessions (from the login node)
tmux ls

## re-enter a session
tmux attach -t <session_name>

## scroll through output (q to exit)
# Ctrl+b, [    then arrow keys or PageUp / PageDown

## open a new window in the same session (starts on the login node, not the worker node)
# Ctrl+b, c

## in the new window, work on the same compute job
squeue --me
srun --jobid=<job_id> --overlap --pty bash -i

## switch between windows (next / previous)
# Ctrl+b, n
# Ctrl+b, p

## list windows in the session
# Ctrl+b, w

## split the window into two panes
# Ctrl+b, %

## move between panes
# Ctrl+b, arrow key

## close the current pane, but not the whole window
exit
# or: Ctrl+b, x    then y

## kill a pane from outside tmux
tmux list-panes -t <session_name>:<window>
tmux kill-pane -t <session_name>:<window>.<pane>

## kill one window
tmux kill-window -t <session_name>:<window>

## detach, then start a second session
# Ctrl+b, d
tmux new -s <other_session_name>

## kill a session completely
tmux kill-session -t <session_name>
