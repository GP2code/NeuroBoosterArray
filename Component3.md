## GWAS hits for the array
See the table in this repo ```GWAS_HITS.txt```

## This table was used to calculate tag SNP distances across populations in plink
Then we ran the standard PLINK tagging routine within each tag set per population per CHR. Run on biowulf witha ```sinteractive --mem=24g``` node. Also cut out SNPs with duplicate rsIDs in the loop.

```
for POP in AMR EAS EUR SAS AFR AAC
do
  for CHRNUM in {1..22}
  do
    echo "working on chromsome" $CHRNUM "for population" $POP
    plink --bfile $POP.chr$CHRNUM.phase3_v5a.biallelic_snpsOnly_PASS_MAC3 --snps-only --show-tags tagsToPull.txt --list-all --tag-r2 0.5 --tag-kb 1000 --out ./tags/$POP.chr$CHRNUM.tagging
  done
done
```

## Tag interval generation
Outputs from tagging were merged and most distant tag SNPs per GWAS hit were identified across the 6 popualtions.  
250kb on each side of most distal tags were added to create intervals.  
Intervals can be found in the repo as part of ```GWAS_TAGS.txt```.  

## Now time to make the interval table to prioritize GWAS loci
First make a base file for each super-population in shell
```
for POP in AMR EAS EUR SAS AFR AAC
do
  cat ./tags/$POP.chr*.tagging.tags.list | grep 'rs' > $POP.allchromosomes.tags.list
done
```

Now in R, make an organized table across all NDDs
```
library("data.table")
hits <- fread("GWAS_HITS.txt", header = T)
hits$V4 <- NULL
AAC <- fread("AAC.allchromosomes.tags.list", header = F)
AFR <- fread("AFR.allchromosomes.tags.list", header = F)
AMR <- fread("AMR.allchromosomes.tags.list", header = F)
EAS <- fread("EAS.allchromosomes.tags.list", header = F)
EUR <- fread("EUR.allchromosomes.tags.list", header = F)
SAS <- fread("SAS.allchromosomes.tags.list", header = F)
names(AAC) <- c("SNP","CHR_gr37","BP_gr37","NTAG.AAC","LEFT.AAC","RIGHT.AAC","KBSPAN.AAC","TAGS")
names(AFR) <- c("SNP","CHR_gr37","BP_gr37","NTAG.AFR","LEFT.AFR","RIGHT.AFR","KBSPAN.AFR","TAGS")
names(AMR) <- c("SNP","CHR_gr37","BP_gr37","NTAG.AMR","LEFT.AMR","RIGHT.AMR","KBSPAN.AMR","TAGS")
names(EAS) <- c("SNP","CHR_gr37","BP_gr37","NTAG.EAS","LEFT.EAS","RIGHT.EAS","KBSPAN.EAS","TAGS")
names(EUR) <- c("SNP","CHR_gr37","BP_gr37","NTAG.EUR","LEFT.EUR","RIGHT.EUR","KBSPAN.EUR","TAGS")
names(SAS) <- c("SNP","CHR_gr37","BP_gr37","NTAG.SAS","LEFT.SAS","RIGHT.SAS","KBSPAN.SAS","TAGS")
AAC$TAGS <- NULL
AFR$CHR_gr37 <- NULL
AFR$BP_gr37 <- NULL
AFR$TAGS <- NULL
AMR$CHR_gr37 <- NULL
AMR$BP_gr37 <- NULL
AMR$TAGS <- NULL
EAS$CHR_gr37 <- NULL
EAS$BP_gr37 <- NULL
EAS$TAGS <- NULL
EUR$CHR_gr37 <- NULL
EUR$BP_gr37 <- NULL
EUR$TAGS <- NULL
SAS$CHR_gr37 <- NULL
SAS$BP_gr37 <- NULL
SAS$TAGS <- NULL
temp1 <- merge(hits, AAC, by = "SNP", all.x = T)
temp2 <- merge(temp1, AFR, all.x = T)
temp3 <- merge(temp2, AMR, all.x = T)
temp4 <- merge(temp3, EAS, all.x = T)
temp5 <- merge(temp4, EUR, all.x = T)
data <- merge(temp5, SAS, all.x = T)
data$minLeft <- with(data, pmin(LEFT.AAC, LEFT.AMR, LEFT.AFR, LEFT.EAS, LEFT.EUR, LEFT.SAS, na.rm = T)) # picks the farthest left distance across populations per variant
data$maxRight <- with(data, pmax(RIGHT.AAC, RIGHT.AMR, RIGHT.AFR, RIGHT.EAS, RIGHT.EUR, RIGHT.SAS, na.rm = T)) # picks the farthest right distance across populations per variant
data$maxSpan <- data$maxRight - data$minLeft
write.table(data, "GWAS_TAGS.tab" , quote = F, sep = "\t", row.names = F)
q("no")
```
###### ```GWAS_TAGS.txt``` can be found in this repo.

## A note on the file ```GWAS_TAGS.txt``` has a 20 dupelicate SNPs. Also, 4 SNPs were not well tagged due to low freq or not passing QC in 1K Genomes (GWAS comes from HRC). In total, priority regions are 49.2 MB.

