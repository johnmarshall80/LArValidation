#!/bin/bash

export CRON_HOME=/usera/marshall/Test/cron

source /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh
setup gcc v4_9_3
setup git v2_4_6
#setup python v2_7_13d
setup eigen v3_3_3
setup root v6_06_08 -q e10:nu:prof

export LD_LIBRARY_PATH=${CRON_HOME}/lib/:$LD_LIBRARY_PATH

