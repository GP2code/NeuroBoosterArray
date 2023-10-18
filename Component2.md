## Component 2 content:
## Make plink binaries to speed things up per CHR
Simple loop on 120 GB machine ```sinteractive --mem=48g``` to set it off.  
Here we are filtering the data to PASS flagged variants that are also biallelic SNPs for all 2504 samples w/out duplicate variant IDs and the SNPs must have been seen at least 3 times. 
```
for CHRNUM in {1..22}
do
  plink --vcf /1kgPhase3v5/ALL.chr$CHRNUM.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz --biallelic-only strict --snps-only --vcf-filter --mac 3 --double-id --make-bed --out temp
  cut -f 2 temp.bim | sort | uniq -d > dupeIdsToDrop.txt
  plink --bfile temp --exclude dupeIdsToDrop.txt --make-bed --out ALL.chr$CHRNUM.phase3_v5a.biallelic_snpsOnly_PASS_MAC3
  rm temp.bed
  rm temp.bim
  rm temp.fam
  rm dupeIdsToDrop.txt
done
```

## Parse the info file into 6 super-populations and extract from the binary files you just created.
```
grep -w -e 'MXL' -e 'CLM' -e 'PEL' -e 'PUR' /1kgPhase3v5/20130606_sample_info.tab | awk '{print $1"\t"$1"\t"}' > AMR.ids
grep -w -e 'JPT' -e 'CDX' -e 'CHB' -e 'CHS' -e 'KHV' -e 'CHD' /1kgPhase3v5/20130606_sample_info.tab | awk '{print $1"\t"$1"\t"}' > EAS.ids
grep -w -e 'TSI' -e 'IBS' -e 'GBR' -e 'CEU' /1kgPhase3v5/20130606_sample_info.tab | awk '{print $1"\t"$1"\t"}' > EUR.ids
grep -w -e 'PJL' -e 'ITU' -e 'STU' -e 'GIH' -e 'BEB' /1kgPhase3v5/20130606_sample_info.tab | awk '{print $1"\t"$1"\t"}' > SAS.ids
grep -w -e 'GWD' -e 'MSL' -e 'ESN' -e 'GWJ' -e 'YRI' -e 'LWK' -e 'GWF' -e 'GWW' /1kgPhase3v5/20130606_sample_info.tab | awk '{print $1"\t"$1"\t"}' > AFR.ids
grep -w -e 'ASW' -e 'ACB' /1kgPhase3v5/20130606_sample_info.tab | awk '{print $1"\t"$1"\t"}' > AAC.ids

cat *.ids | wc -l
```
Note, these numbers end up summing to 3395 samples out of the total of 3500 in the sample info file.  
This is due to removal of the FIN popualtion (N = 105) and the file containing sample snot sequenced in this release (mainly Gambia project related samples).

## Next we make the per CHR files for each super-population
We are also filtering each superpopulation at MAC > 3 at this phase.

```
for POP in AMR EAS EUR SAS AFR AAC
do
  for CHRNUM in {1..22}
  do
    echo "working on chromsome" $CHRNUM "for population" $POP
    plink --bfile ALL.chr$CHRNUM.phase3_v5a.biallelic_snpsOnly_PASS_MAC3 --keep $POP.ids --mac 3 --make-bed --out $POP.chr$CHRNUM.phase3_v5a.biallelic_snpsOnly_PASS_MAC3
  done
done
```

## Calculating superpopulation r2s and allele freqs
See the swarm scripts in this repo ```calcR2.sh``` and ```calcFreqs.sh```. Modules on biowulf used were PLINK and VCFtools.

## Formatting the r2 outputs for running TagIt
This transforms everything from the standard plink outputs in a unique TagIt format. The script formatR2s.R is in this repository as well.
```
for POP in AMR EAS EUR SAS AFR AAC
do
  for CHRNUM in {1..22}
  do
    echo "working on chromsome" $CHRNUM "for population" $POP
    Rscript formatR2s.R $POP $CHRNUM
    gzip $POP.chr$CHRNUM.pairLD.txt
    mv $POP.chr$CHRNUM.pairLD.txt.gz ./r2s
  done
done
```

## Running TagIt in paralell on the cluster
See the script ```runTagIt.swarm``` in this repo.
Run it with the line below.
```
swarm -f runTagIt.swarm -g 120 -t 8 --module tagit --time 24:00:00
```

## Cleaning up the outputs
```
# Summary files from TagIt

echo -e "MARKER\tWEIGHT.ALL\tWEIGHT.UNIQUE\tAAC.WEIGHT\tAFR.WEIGHT\tAMR.WEIGHT\tEAS.WEIGHT\tEUR.WEIGHT\tSAS.WEIGHT" > allChromosomes.summaryTagit.txt && zcat chr*.summary.txt.gz  | grep ':' >> allChromosomes.summaryTagit.txt

# Tag files from TagIt

echo -e "MARKER\tWEIGHT.ALL\tWEIGHT.UNIQUE\tAAC.WEIGHT\tAFR.WEIGHT\tAMR.WEIGHT\tEAS.WEIGHT\tEUR.WEIGHT\tSAS.WEIGHT" > allChromosomes.tagsTagit.txt && zcat chr*.tags.txt.gz  | grep ':' >> allChromosomes.tagsTagit.txt

# Tagged files from TagIt

echo -e "MARKER\tAAC\tAFR\tAMR\tEAS\tEUR\tSAS" > allChromosomes.taggedTagit.txt && zcat chr*.tagged.txt.gz  | grep ':' >> allChromosomes.taggedTagit.txt

# Compress for download

gzip allChromosomes.taggedTagit.txt
gzip allChromosomes.summaryTagit.txt
gzip allChromosomes.tagsTagit.txt

```

###### Component 2 of the build is done now. The files above are in the google drive directory here [https://drive.google.com/drive/folders/16F6elvTueImY_BAr8Wgg2aegIgffJQS2?usp=sharing] and may be valuable for future array builds.
