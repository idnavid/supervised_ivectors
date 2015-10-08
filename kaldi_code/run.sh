
/export/tools/kaldi-trunk2/src/bin/copy-matrix ark:$PWD/../matlab_code/models/dev.ark ark,t:$PWD/models/dev.txt.ark.tmp

# copy-matrix outputs have a newline character right after "[". ivector-compute-plda doesn't know how to read these files. 
# That's why we need to read the output of copy-matrix into and tmp file and then convert all the "[\n" instances into "[".
cat $PWD/models/dev.txt.ark.tmp | perl -ne 'if(m/(.*)\[(.*)/) {print "$1 \[ ";}else{print $_}' > $PWD/models/dev.txt.ark
rm $PWD/models/dev.txt.ark.tmp

/export/tools/kaldi-trunk2/src/ivectorbin/ivector-compute-plda --verbose=2 ark,t:$PWD/lists/plda.lst ark,t:$PWD/models/dev.txt.ark $PWD/models/plda




## PLDA scoring
#ivector-plda-scoring <plda> <train-ivector-rspecifier> <test-ivector-rspecifier>  <trials-rxfilename> <scores-wxfilename>





# Create model scp file.
/export/tools/kaldi-trunk2/src/bin/copy-matrix ark:$PWD/../matlab_code/models/model.ark ark,t:- > $PWD/models/model.txt.ark.tmp
cat $PWD/models/model.txt.ark.tmp | perl -ne 'if(m/(.*)\[(.*)/) {print "$1 \[ ";}else{print $_}' > $PWD/models/model.txt.ark
rm $PWD/models/model.txt.ark.tmp


# For the test files:
/export/tools/kaldi-trunk2/src/bin/copy-matrix ark:$PWD/../matlab_code/models/test.ark ark,t:- > $PWD/models/test.txt.ark.tmp
cat $PWD/models/test.txt.ark.tmp | perl -ne 'if(m/(.*)\[(.*)/) {print "$1 \[ ";}else{print $_}' > $PWD/models/test.txt.ark
rm $PWD/models/test.txt.ark.tmp

# Score trials:
/export/tools/kaldi-trunk2/src/ivectorbin/ivector-plda-scoring $PWD/models/plda ark:$PWD/models/model.txt.ark ark:$PWD/models/test.txt.ark $PWD/lists/SRE10_trials scores.txt


cut -d ' ' scores.txt -f 3 > raw_scores.txt                      
paste -d ' ' $PWD/raw_scores.txt $PWD/lists/SRE10_keys > eer_input
/export/tools/kaldi-trunk2/src/ivectorbin/compute-eer $PWD/eer_input
