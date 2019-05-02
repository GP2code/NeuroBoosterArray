## First begin by parsing the data
###### On the NIH biowulf cluster in the directory ```/data/CARD/OTHER/1kgPhase3v5/``` after ```module load plink```

## Make plink binaries to speed things up per CHR
Simple loop on 120 GB machine ```sinteractive -g 120``` to set it off.  
Here we are filtering the data to PASS flagged variants that are also biallelic SNPs for all 2504 samples. 
```
for CHRNUM in {1..22}
do
  plink --vcf ALL.chr$CHRNUM.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz --biallelic-only strict --vcf-filter --double-id --make-bed --out ALL.chr$CHRNUM.phase3_v5a.biallelic_PASS
done
```

## Parse the info file into 6 superpopulations and extract from the binary files you just created.
```
grep -w -e 'MXL' -e 'CLM' -e 'PEL' -e 'PUR' 20130606_sample_info.tab | awk '{print $1"\t"$1"\t"}' > AMR.ids
grep -w -e 'JPT' -e 'CDX' -e 'CHB' -e 'CHS' -e 'KHV' -e 'CHD' 20130606_sample_info.tab | awk '{print $1"\t"$1"\t"}' > EAS.ids
grep -w -e 'TSI' -e 'IBS' -e 'GBR' -e 'CEU' 20130606_sample_info.tab | awk '{print $1"\t"$1"\t"}' > EUR.ids
grep -w -e 'PJL' -e 'ITU' -e 'STU' -e 'GIH' -e 'BEB' 20130606_sample_info.tab | awk '{print $1"\t"$1"\t"}' > SAS.ids
grep -w -e 'GWD' -e 'MSL' -e 'ESN' -e 'GWJ' -e 'YRI' -e 'LWK' -e 'GWF' -e 'GWW' 20130606_sample_info.tab | awk '{print $1"\t"$1"\t"}' > AFR.ids
grep -w -e 'ASW' -e 'ACB' 20130606_sample_info.tab | awk '{print $1"\t"$1"\t"}' > AAC.ids

cat *.ids | wc -l
```
Note, these numbers end up summing to 3395 samples out of the total of 3500 in the sample info file.  
This is due to removal of the FIN popualtion (N = 105) and the file containing sample snot sequenced in this release (mainly Gambia project related samples).

## Next we make the per CHR files for each superpopulation
We are also filtering each superpopulation at MAC > 3 at this phase.

```
for POP in AMR EAS EUR SAS AFR AAC
do
  for CHRNUM in {1..22}
  do
    echo "working on chromsome" $CHRNUM "for population" $POP
    plink --bfile ALL.chr$CHRNUM.phase3_v5a.biallelic_PASS --keep $POP.ids --mac 3 --make-bed --out $POP.chr$CHRNUM.phase3_v5a.biallelic_PASS_MAC3
  done
done
```

## Time to calculate per superpopulation r2s and allele freqs
Batch processing of these will be done using ```swarm``` on biowulf.  
See the swarm scripts in this repo ```calcR2.sh``` and ```calcFreqs.sh```.
These were launched using the commands below.
```
swarm -f calcR2.sh --module plink -g 120 -t 12 -b 6
swarm -f calcFreqs.sh --module plink -g 120 -t 12 - b 6
```
## For the sake of house keeping, we moved all the working data to /data/CARD/projects/globoNeuroBuild/
```
mv ./r2s/ /data/CARD/projects/globoNeuroBuild/
mv ./freqs/ /data/CARD/projects/globoNeuroBuild/
mv *.ids /data/CARD/projects/globoNeuroBuild/
mv *.biallelic_PASS_MAC3.log /data/CARD/projects/globoNeuroBuild/
mv *.biallelic_PASS_MAC3.bed /data/CARD/projects/globoNeuroBuild/
mv *.biallelic_PASS_MAC3.bim /data/CARD/projects/globoNeuroBuild/
mv *.biallelic_PASS_MAC3.fam /data/CARD/projects/globoNeuroBuild/
mv *.biallelic_PASS_MAC3.nosex /data/CARD/projects/globoNeuroBuild/

```

## Set up TagIt since not preinstalled on biowulf then run the example
Build it
```
sinteractive -g 120
module load R
module load plink
cd /data/CARD/projects/globoNeuroBuild/TagIt-master/src/
make all
# now get the help
./tagit --help
```
Note, momentary halt in work as TagIt crashes at install on biowulf, but Mike contacted HPC
```
g++ -std=c++11 -Wall -isystem/usr/include -g -c -o GzipReader.o GzipReader.cpp
In file included from include/Reader.h:4:0,
                 from include/GzipReader.h:4,
                 from GzipReader.cpp:1:
/usr/local/GCC/7.3.0/include/c++/7.3.0/cstdlib:75:15: fatal error: stdlib.h: No such file or directory
 #include_next <stdlib.h>
               ^~~~~~~~~~
compilation terminated.
make[1]: *** [GzipReader.o] Error 1
make[1]: Leaving directory `/gpfs/gsfs9/users/CARD/projects/globoNeuroBuild/TagIt-master/src/reader'
make: *** [applibs] Error 1

```

## Now format the freq and r2 putputs for running TagIt
