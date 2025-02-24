#!/bin/bash

# Define the log directory
LOG_DIR="/var/log/system_stats"
mkdir -p $LOG_DIR

# Clean up logs older than 10 minutes
find $LOG_DIR -type f -mmin +10 -exec rm -f {} \;

# Define the timestamp format for the filename
DATE=$(date "+%Y-%m-%d_%H-%M-%S")

# Log file names
CPU_LOG="$LOG_DIR/cpu_usage_$DATE.log"
MEMORY_LOG="$LOG_DIR/memory_usage_$DATE.log"
PROCESS_LOG="$LOG_DIR/top_processes_$DATE.log"

# Capture CPU usage with sar every 30 seconds, 2 samples (run in the background)
sar -u 30 2 > $CPU_LOG &

# Capture memory usage with sar every 30 seconds, 2 samples (run in the background)
sar -r 30 2 > $MEMORY_LOG &

# Capture the top memory-consuming processes
ps -ewwo pid,ppid,cmd:80,%mem,%cpu --sort=-%mem | head > $PROCESS_LOG

# Wait for both sar commands to finish before completing the script
wait

# Optionally, you can combine all logs into a single file
cat $CPU_LOG $MEMORY_LOG $PROCESS_LOG > "$LOG_DIR/system_stats_$DATE.log"

