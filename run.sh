#!/bin/bash

export CRON_HOME=/usera/marshall/Test/cron
export OUTPUT=/r05/dune/marshall/cron/run
export FW_SEARCH_PATH=$CRON_HOME/LArReco/settings:/r05/dune/MachineLearningData:$FW_SEARCH_PATH

# Setup input files, etc.
export LARSOFT_VERSION=${1}
export DATE=`date +"%d-%m-%y"`
export FILE_PATH="${CRON_HOME}/run/Files_${LARSOFT_VERSION}"

if [ ${LARSOFT_VERSION} == "v05_04_00" ]
then
    export REGEX="reco1"
    export GEOMETRY_COMMAND="-g ${CRON_HOME}/LArReco/geometry/PandoraGeometry_MicroBooNE_MCC7Gaps.xml"
elif [ ${LARSOFT_VERSION} == "v05_08_00" ]
then
    export REGEX="reco1"
    export GEOMETRY_COMMAND="-g ${CRON_HOME}/LArReco/geometry/PandoraGeometry_MicroBooNE_MCC7Gaps.xml"
else
    export REGEX="Neutrino"
    export GEOMETRY_COMMAND="-g ${CRON_HOME}/run/PandoraGeometry_MicroBooNE_NoGaps.xml"
fi

export DIRECTORY=${OUTPUT}/${LARSOFT_VERSION}_${DATE}
if [ -d "$DIRECTORY" ]; then rm -r $DIRECTORY; fi
mkdir -p $DIRECTORY
cd $DIRECTORY

cp $CRON_HOME/LArReco/settings/PandoraSettings_Master_MicroBooNE.xml ./PandoraSettings_Template.xml
sed -i "s/<IsMonitoringEnabled>.*<\/IsMonitoringEnabled>/<IsMonitoringEnabled>true<\/IsMonitoringEnabled>/g" ./PandoraSettings_Template.xml
sed -i "s/<algorithm type = \"LArVisualMonitoring\">/<\!--algorithm type = \"LArVisualMonitoring\">/g" ./PandoraSettings_Template.xml
sed -i '/<ShowDetector>/{ N; s/<\/ShowDetector>\n    <\/algorithm>/<\/ShowDetector>\n    <\/algorithm-->/ }' ./PandoraSettings_Template.xml

sed -i "s/<WriteToTree>.*<\/WriteToTree>/<WriteToTree>true<\/WriteToTree>/g" ./PandoraSettings_Template.xml
sed -i "s/<OutputFile>.*<\/OutputFile>/<OutputFile>OUTPUT_FILE_NAME<\/OutputFile>/g" ./PandoraSettings_Template.xml

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
    sed -e s,OUTPUT_FILE_NAME,$outputFile, -e s,FILE_IDENTIFIER,$fileIdentifier, PandoraSettings_Template.xml > tmp.xml

    ${CRON_HOME}/LArReco/bin/PandoraInterface -r AllHitsNu -e ${i} -i tmp.xml ${GEOMETRY_COMMAND} > /dev/null
    rm tmp.xml
done

# Merge to single ROOT file
echo 'gROOT->LoadMacro("${CRON_HOME}/run/MergeTrees.C"); MergeTrees("Validation", "${DIRECTORY}/tmp_*.root", "${LARSOFT_VERSION}_${DATE}.root");' | root -b -l > /dev/null
rm ${DIRECTORY}/tmp*.root;

# Process
echo 'gROOT->LoadMacro("${CRON_HOME}/run/Process.C"); Process("${DIRECTORY}", "${LARSOFT_VERSION}_${DATE}.root");' | root -b -l

cd $CRON_HOME

