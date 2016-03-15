#!/bin/bash

export CRON_HOME=/usera/marshall/Test/cron

for i in PandoraSDK PandoraMonitoring LArContent LArReco
do
    cd $CRON_HOME/$i
    git pull origin master
    cd $CRON_HOME
done

