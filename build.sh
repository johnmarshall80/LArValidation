#!/bin/bash

export CRON_HOME=/usera/marshall/Test/cron

cd $CRON_HOME/PandoraSDK
mkdir -p lib
make -j4 PROJECT_DIR=$CRON_HOME/PandoraSDK; make install PROJECT_DIR=$CRON_HOME/PandoraSDK LIB_TARGET=$CRON_HOME/lib/

cd $CRON_HOME/PandoraMonitoring
mkdir -p lib
make -j4 PROJECT_DIR=$CRON_HOME/PandoraMonitoring PANDORA_DIR=$CRON_HOME; make install PROJECT_DIR=$CRON_HOME/PandoraMonitoring PANDORA_DIR=$CRON_HOME LIB_TARGET=$CRON_HOME/lib/

cd $CRON_HOME/LArContent
mkdir -p lib
make -j4 MONITORING=1 PROJECT_DIR=$CRON_HOME/LArContent PANDORA_DIR=$CRON_HOME; make install PROJECT_DIR=$CRON_HOME/LArContent PANDORA_DIR=$CRON_HOME LIB_TARGET=$CRON_HOME/lib/

cd $CRON_HOME/LArReco
mkdir -p bin
make -j4 MONITORING=1 PROJECT_DIR=$CRON_HOME/LArReco PANDORA_DIR=$CRON_HOME

cd $CRON_HOME
