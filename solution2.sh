#!/bin/bash

# Trap SIGUSR1 signal
trap 'echo "Received SIGUSR1"; exit' SIGUSR1

# Child process function
child_process() {
    echo "Child process started"
    sleep 5
    echo "Child process finished"
}

# Main script
echo "Parent process started"

# Start the child process in the background
child_process &

# Store the PID of the child process
child_pid=$!

echo "Parent process waiting for 2 seconds..."
sleep 2

echo "Sending SIGUSR1 signal to child process"
kill -SIGUSR1 $child_pid

echo "Parent process waiting for child process to finish..."
wait $child_pid

echo "Parent process finished"
