#!/bin/bash

export CRON_HOME=/usera/marshall/Test/cron

source $CRON_HOME/run/setup.sh
source $CRON_HOME/run/update.sh
source $CRON_HOME/run/build.sh
source $CRON_HOME/run/run.sh v05_08_00
#source $CRON_HOME/run/run.sh v05_04_00
source $CRON_HOME/run/run.sh v04_16_00
