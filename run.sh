#!/bin/bash

export CRON_HOME=/usera/marshall/Test/cron
export OUTPUT=/r05/dune/marshall/cron/run

# Setup input files, etc.
export LARSOFT_VERSION='v04_16_00'
export DATE=`date +"%d-%m-%y"`

export DIRECTORY=${OUTPUT}/${LARSOFT_VERSION}_${DATE}
if [ -d "$DIRECTORY" ]; then rm -r $DIRECTORY; fi
mkdir -p $DIRECTORY
cd $DIRECTORY

cp $CRON_HOME/LArReco/scripts/uboone/PandoraSettings_MicroBooNE_Validation.xml ./PandoraSettings_Template.xml

# Run Pandora
counter=0; max=1000;
for i in `ls /r05/lbne/mcproduction_${LARSOFT_VERSION}/prodgenie_bnb_nu_uboone/uBooNE_Events_100_*Neutrino.pndr | sort -V`
do
    counter=$[$counter+1]
    if [ $counter -gt $max ]; then break; fi

    echo $i
    fileIdentifier=$[`echo $i | grep -oP '(?<=_)\d+(?=_Neutrino\.)'`]
    outputFile=tmp_$fileIdentifier.root;
    sed -e s,INPUT_FILE_NAME,$i, -e s,OUTPUT_FILE_NAME,$outputFile, -e s,FILE_IDENTIFIER,$fileIdentifier, PandoraSettings_Template.xml > tmp.xml

    ${CRON_HOME}/LArReco/bin/PandoraInterface -i tmp.xml -N -d uboone -n 100 > /dev/null
    rm tmp.xml
done

# Merge to single ROOT file
echo 'gROOT->LoadMacro("${CRON_HOME}/run/MergeTrees.C"); MergeTrees("Validation", "${DIRECTORY}/tmp_*.root", "${LARSOFT_VERSION}_${DATE}.root");' | root -b -l > /dev/null
rm ${DIRECTORY}/tmp*.root;

# Process
echo 'gROOT->LoadMacro("${CRON_HOME}/run/Process.C"); Process("${DIRECTORY}", "${LARSOFT_VERSION}_${DATE}.root");' | root -b -l

cd $CRON_HOME

