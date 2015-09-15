#!/bin/bash

rm -f trial.left trial.right trial.key

for i in `awk '{print $1}' AIDformat_SRE10_Male_trainIndex_testIndex_keys_core_cond5.lst`
do
    grep -w $i AIDformat_SRE10_core_condAll_Male_trn.lst | awk '{print $1}' | xargs -I {} basename {} | awk -F'__' '{print $1}' | awk -F'_' '{print $1 ".sph" ":" $2}'|  xargs -I {} grep {} wav.scp.trn | awk '{print $1}' >> trial.left

done

for i in `awk '{print $2}' AIDformat_SRE10_Male_trainIndex_testIndex_keys_core_cond5.lst`
do
    grep -w $i AIDformat_SRE10_core_condAll_Male_tst.lst | awk '{print $1}' | xargs -I {} basename {} | awk -F'__' '{print $1}' | awk -F'_' '{print $1 ".sph" ":" $2}'|  xargs -I {} grep {} wav.scp.tst | awk '{print $1}' >> trial.right
    #grep -w $i AIDformat_SRE10_core_condAll_Male_tst.lst | awk '{print $1}' | xargs -I {} basename {} | awk -F'_' '{print $1}' | xargs -I {} grep {} wav.scp.tst | awk '{print $1}' >> trial.right

done

for i in `awk '{print $3}' AIDformat_SRE10_Male_trainIndex_testIndex_keys_core_cond5.lst`
do
    if [ $i == "1" ]; then
       echo "target" >> trial.key
    else
       echo "nontarget" >> trial.key
    fi
done 

paste trial.left trial.right trial.key > AIDformat_SRE10_Male_trainIndex_testIndex_keys_core_cond5.lst.kaldi
