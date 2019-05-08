## GWAS hits for the array
See the table in this repo ```GWAS_HITS.txt```

## This table was used to calculate tag SNP distances across populations in plink
Then we ran the standard PLINK tagging routine within each tag set per population per CHR. Run on biowulf witha ```sinteractive --mem=24g``` node. Also cut out SNPs with duplicate rsIDs in the loop.

```
cut -f 1 GWAS_HITS.txt | sort | uniq > tagsToPull.txt
for POP in AMR EAS EUR SAS AFR AAC
do
  for CHRNUM in {1..22}
  do
    echo "working on chromsome" $CHRNUM "for population" $POP
    cut -f 2 $POP.chr$CHRNUM.phase3_v5a.biallelic_PASS_MAC3.bim | sort | uniq -d > ./tags/$POP.chr$CHRNUM.dupeIdsToDrop.txt
    plink --bfile $POP.chr$CHRNUM.phase3_v5a.biallelic_PASS_MAC3 --exclude ./tags/$POP.chr$CHRNUM.dupeIdsToDrop.txt --make-bed --out ./tags/temp 
    plink --bfile ./tags/temp --snps-only --show-tags tagsToPull.txt --list-all --tag-r2 0.5 --tag-kb 1000 --out ./tags/$POP.chr$CHRNUM.tagging
  done
done
```

## Tag interval generation
Outputs from tagging were merged and most distant tag SNPs per GWAS hit were identified across the 6 popualtions.  
250kb on each side of most distal tags were added to create intervals.  
Intervals can be found in the repo as part of ```GWAS_TAGS.txt```.  
