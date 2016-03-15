#!/bin/bash

export CRON_HOME=/usera/marshall/Test/cron

source /cvmfs/uboone.opensciencegrid.org/products/setup_uboone.sh
setup gcc v4_9_3 -f Linux64bit+2.6-2.12
setup git v2_4_6 -f Linux64bit+2.6-2.12
setup root v5_34_32 -f Linux64bit+2.6-2.12 -q e9:nu:prof
export LD_LIBRARY_PATH=${CRON_HOME}/lib/:$LD_LIBRARY_PATH

