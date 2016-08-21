#!/bin/bash
set -e

echo "Changing to dsvm/tools folder ..."
cd /dsvm/tools/
wait 

# Adjust based on the build of H2O you want to download.
h2oBranch=rel-turing

echo "Fetching latest build number for branch ${h2oBranch}..."
curl --silent -o latest https://h2o-release.s3.amazonaws.com/h2o/${h2oBranch}/latest
h2oBuild=`cat latest`
wait

echo "Fetching full version number for build ${h2oBuild}..."
curl --silent -o project_version https://h2o-release.s3.amazonaws.com/h2o/${h2oBranch}/${h2oBuild}/project_version
h2oVersion=`cat project_version`
wait

echo "Downloading H2O version ${h2oVersion} ..."
curl --silent -o h2o-${h2oVersion}.zip https://s3.amazonaws.com/h2o-release/h2o/${h2oBranch}/${h2oBuild}/h2o-${h2oVersion}.zip &
wait

echo "Unzipping h2o.jar ..."
unzip -o h2o-${h2oVersion}.zip 1> /dev/null &
wait

echo "Copying h2o.jar within node ..."
cp -f h2o-${h2oVersion}/h2o.jar . &
wait

echo "Creating Flatfile with info of all Vms in cluster .."
flatfileName=flatfile.txt
rm -f ${flatfileName}
i=0
for i in $(seq 4 $((4+$1-1)))
do
    privateIp="10.0.0.$i"
    echo "${privateIp}:54321" >> ${flatfileName}
done

echo "Installing H2O for R"
R --slave -e 'install.packages("statmod")'
wait
R --slave -e 'install.packages("h2o", type="source", repos=(c("https://s3.amazonaws.com/h2o-release/h2o/'${h2oBranch}'/'${h2oBuild}'/R")))'


echo "Installing H2O for Python"
ln -s /anaconda/bin/pip /usr/bin/pip
pip install https://s3.amazonaws.com/h2o-release/h2o/${h2oBranch}/${h2oBuild}/Python/h2o-${h2oVersion}-py2.py3-none-any.whl


echo "Running h2o.jar"
# Use 90% of RAM for H2O.
memTotalKb=`cat /proc/meminfo | grep MemTotal | sed 's/MemTotal:[ \t]*//' | sed 's/ kB//'`
memTotalMb=$[ $memTotalKb / 1024 ]
tmp=$[ $memTotalMb * 90 ]
xmxMb=$[ $tmp / 100 ]

nohup java -Xmx${xmxMb}m -jar h2o.jar -flatfile flatfile.txt 1> /dev/null 2> h2o.err &

echo Success.

