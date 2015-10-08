
/export/tools/kaldi-trunk2/src/bin/copy-matrix ark:$PWD/../matlab_code/models/dev.ark ark,t:$PWD/models/dev.txt.ark.tmp

# copy-matrix outputs have a newline character right after "[". ivector-compute-plda doesn't know how to read these files. 
# That's why we need to read the output of copy-matrix into and tmp file and then convert all the "[\n" instances into "[".
cat $PWD/models/dev.txt.ark.tmp | perl -ne 'if(m/(.*)\[(.*)/) {print "$1 \[ ";}else{print $_}' > $PWD/models/dev.txt.ark
rm $PWD/models/dev.txt.ark.tmp

/export/tools/kaldi-trunk2/src/ivectorbin/ivector-compute-plda --verbose=2 ark,t:$PWD/lists/plda.lst ark,t:$PWD/models/dev.txt.ark $PWD/models/plda
