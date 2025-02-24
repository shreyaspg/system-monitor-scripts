# Prerequisites
* sysstat (apt install sysstat)

## Add cron entry

1. ```sudo crontab -e ```Use the root cron
2. Add the following to cron

   ```* * * * * /path/to/capture_system_stats.sh```
3. Runs every minute (min)


## Optional - Redirect cron logs

Add the following to `/etc/rsyslog/d/49-default.conf`, 
Chose anything below 50, e.g 49 < 50 (which is the default)
This will redirect cron logs to `/var/log/cron.log`

```
# Don't overflow logs, suppress cron logs for tasks running every minute
# (needs to append "#minutely" as a comment at the end of such commands)
if $programname == 'CRON' and $msg contains '#minutely' then stop

# Put info level cron logs in a separated file.
cron.=info      /var/log/cron.log  # redirect if level is exactly 'info'
cron.notice     -/var/log/syslog   # keep sending to syslog if level is 'notice' or higher
cron.*          stop               # drop messages here to avoid default redirections
```

## Optional - Rotate the cron logs

Add the following to `/etc/logrotate.d/rsyslog`, **if** redirecting cron logs

```
/var/log/cron.log
{
        daily
        rotate 7
        compress
        missingok
}
```

# Reading the logs
The logs will get stored in `/var/log/system_stats`, it keeps last 10 minutes of data

Use head command to capture data for time interval ("+%Y-%m-%d_%H-%M-%S")
example: `head *22-04*` inside the log folder

Sample view:
```
Linux 6.8.0-52-generic (hostname)    24/02/25        _x86_64_        (16 CPU)

10:04:01 PM IST     CPU     %user     %nice   %system   %iowait    %steal     %idle
10:04:31 PM IST     all      1.52      0.01      1.36      0.07      0.00     97.04
10:05:01 PM IST     all      2.42      0.01      1.35      0.08      0.00     96.15
Average:        all      1.97      0.01      1.35      0.07      0.00     96.60

==> memory_usage_2025-02-24_22-04-01.log <==
Linux 6.8.0-52-generic (hostname)    24/02/25        _x86_64_        (16 CPU)

10:04:01 PM IST kbmemfree   kbavail kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit  kbactive   kbinact   kbdirty
10:04:31 PM IST  17250708  23347312   7120224     21.89    307548   7253828  26662864     72.99   9471924   3791900       288
10:05:01 PM IST  17257980  23354840   7119136     21.89    307776   7247688  25358240     69.42   9449300   3792148        88
Average:     17254344  23351076   7119680     21.89    307662   7250758  26010552     71.21   9460612   3792024       188

==> system_stats_2025-02-24_22-04-01.log <==
Linux 6.8.0-52-generic (hostname)    24/02/25        _x86_64_        (16 CPU)

10:04:01 PM IST     CPU     %user     %nice   %system   %iowait    %steal     %idle
10:04:31 PM IST     all      1.52      0.01      1.36      0.07      0.00     97.04
10:05:01 PM IST     all      2.42      0.01      1.35      0.08      0.00     96.15
Average:        all      1.97      0.01      1.35      0.07      0.00     96.60
Linux 6.8.0-52-generic (hostname)    24/02/25        _x86_64_        (16 CPU)

10:04:01 PM IST kbmemfree   kbavail kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit  kbactive   kbinact   kbdirty
10:04:31 PM IST  17250708  23347312   7120224     21.89    307548   7253828  26662864     72.99   9471924   3791900       288

==> top_processes_2025-02-24_22-04-01.log <==
    PID    PPID CMD                                                                              %MEM %CPU
  14498   14306 /home/<username>/.local/share/nvim/mason/bin/rust-analyzer                           6.5  1.5
   7041    2534 /snap/firefox//usr/lib/firefox/firefox                                        1.6 22.4
   8692    7041 /snap/firefox//usr/lib/firefox/firefox -contentproc -isForBrowser -prefsHand  1.4  0.3
```






