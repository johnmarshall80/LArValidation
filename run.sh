#!/bin/bash

export CRON_HOME=/usera/marshall/Test/cron
export OUTPUT=/r05/dune/marshall/cron/run

# Setup input files, etc.
export LARSOFT_VERSION=${1}
export DATE=`date +"%d-%m-%y"`

if [ ${LARSOFT_VERSION} == "v05_04_00" ]
then
    export REGEX="reco1"
    export FILE_PATH="/r05/dune/mcproduction_${LARSOFT_VERSION}/prodgenie_bnb_nu_uboone_100k"
    export GEOMETRY_FILE_NAME="/r05/dune/mcproduction_v05_04_00/geometry_uboone/Geometry_MicroBooNE.pndr"
    export READ_GEOMETRY="true"
else
    export REGEX="Neutrino"
    export FILE_PATH="/r05/lbne/mcproduction_${LARSOFT_VERSION}/prodgenie_bnb_nu_uboone"
    export GEOMETRY_FILE_NAME="NO_GEOMETRY"
    export READ_GEOMETRY="false"
fi

export DIRECTORY=${OUTPUT}/${LARSOFT_VERSION}_${DATE}
if [ -d "$DIRECTORY" ]; then rm -r $DIRECTORY; fi
mkdir -p $DIRECTORY
cd $DIRECTORY

cp $CRON_HOME/LArReco/scripts/uboone/PandoraSettings_MicroBooNE_Validation.xml ./PandoraSettings_Template.xml

# Run Pandora
counter=0; max=1000;
for i in `ls ${FILE_PATH}/*${REGEX}.pndr | sort -V`
do
    counter=$[$counter+1]
    if [ $counter -gt $max ]; then break; fi

    echo $i
    expression="(?<=_)\d+(?=_${REGEX}\.)"
    fileIdentifier=$[`echo $i | grep -oP ${expression}`]

    outputFile=tmp_$fileIdentifier.root;
    sed -e s,INPUT_FILE_NAME,$i, -e s,OUTPUT_FILE_NAME,$outputFile, -e s,FILE_IDENTIFIER,$fileIdentifier, -e s,GEOMETRY_FILE_NAME,$GEOMETRY_FILE_NAME, -e s,READ_GEOMETRY,$READ_GEOMETRY, PandoraSettings_Template.xml > tmp.xml

    ${CRON_HOME}/LArReco/bin/PandoraInterface -r AllHitsNu -i tmp.xml -v /usera/marshall/Test/cron/LArReco/detectors/uboone.xml > /dev/null
    rm tmp.xml
done

# Merge to single ROOT file
echo 'gROOT->LoadMacro("${CRON_HOME}/run/MergeTrees.C"); MergeTrees("Validation", "${DIRECTORY}/tmp_*.root", "${LARSOFT_VERSION}_${DATE}.root");' | root -b -l > /dev/null
rm ${DIRECTORY}/tmp*.root;

# Process
echo 'gROOT->LoadMacro("${CRON_HOME}/run/Process.C"); Process("${DIRECTORY}", "${LARSOFT_VERSION}_${DATE}.root");' | root -b -l

cd $CRON_HOME

