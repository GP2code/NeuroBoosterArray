## Component 3 content:

### 1. GWAS hits selection

### 2. Calculate tag SNP distances across populations
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

### 3. Tag interval generation
Outputs from tagging were merged and most distant tag SNPs per GWAS hit were identified across the 6 popualtions.  
250kb on each side of most distal tags were added to create intervals.  

### 4. Make the interval table to prioritize GWAS loci
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
library("dplyr")
hits <- fread("GWAS_HITS.txt", header = T)
hits$V4 <- NULL
AAC <- fread("AAC.allchromosomes.tags.list", header = F)
AFR <- fread("AFR.allchromosomes.tags.list", header = F)
AMR <- fread("AMR.allchromosomes.tags.list", header = F)
EAS <- fread("EAS.allchromosomes.tags.list", header = F)
EUR <- fread("EUR.allchromosomes.tags.list", header = F)
SAS <- fread("SAS.allchromosomes.tags.list", header = F)
names(AAC) <- c("SNP","CHR_gr37.AAC","BP_gr37.AAC","NTAG.AAC","LEFT.AAC","RIGHT.AAC","KBSPAN.AAC","TAGS")
names(AFR) <- c("SNP","CHR_gr37.AFR","BP_gr37.AFR","NTAG.AFR","LEFT.AFR","RIGHT.AFR","KBSPAN.AFR","TAGS")
names(AMR) <- c("SNP","CHR_gr37.AMR","BP_gr37.AMR","NTAG.AMR","LEFT.AMR","RIGHT.AMR","KBSPAN.AMR","TAGS")
names(EAS) <- c("SNP","CHR_gr37.EAS","BP_gr37.EAS","NTAG.EAS","LEFT.EAS","RIGHT.EAS","KBSPAN.EAS","TAGS")
names(EUR) <- c("SNP","CHR_gr37.EUR","BP_gr37.EUR","NTAG.EUR","LEFT.EUR","RIGHT.EUR","KBSPAN.EUR","TAGS")
names(SAS) <- c("SNP","CHR_gr37.SAS","BP_gr37.SAS","NTAG.SAS","LEFT.SAS","RIGHT.SAS","KBSPAN.SAS","TAGS")
AAC$TAGS <- NULL
AFR$TAGS <- NULL
AMR$TAGS <- NULL
EAS$TAGS <- NULL
EUR$TAGS <- NULL
SAS$TAGS <- NULL
temp1 <- merge(hits, AAC, by = "SNP", all.x = T)
temp2 <- merge(temp1, AFR, all.x = T)
temp3 <- merge(temp2, AMR, all.x = T)
temp4 <- merge(temp3, EAS, all.x = T)
temp5 <- merge(temp4, EUR, all.x = T)
data <- merge(temp5, SAS, all.x = T)
data$CHR_region_gr37 <- rowMeans(select(data, starts_with("CHR_gr37")), na.rm = TRUE)
data$BP_midpoint_gr37 <- rowMeans(select(data, starts_with("BP_gr37")), na.rm = TRUE)
AAC$CHR_gr37.AAC <- NULL
AAC$BP_gr37.AAC <- NULL
AFR$CHR_gr37.AFR <- NULL
AFR$BP_gr37.AFR <- NULL
AMR$CHR_gr37.AMR <- NULL
AMR$BP_gr37.AMR <- NULL
EAS$CHR_gr37.EAS <- NULL
EAS$BP_gr37.EAS <- NULL
EUR$CHR_gr37.EUR <- NULL
EUR$BP_gr37.EUR <- NULL
SAS$CHR_gr37.SAS <- NULL
SAS$BP_gr37.SAS <- NULL
data$minLeft <- with(data, pmin(LEFT.AAC, LEFT.AMR, LEFT.AFR, LEFT.EAS, LEFT.EUR, LEFT.SAS, na.rm = T)) # picks the farthest left distance across populations per variant
data$maxRight <- with(data, pmax(RIGHT.AAC, RIGHT.AMR, RIGHT.AFR, RIGHT.EAS, RIGHT.EUR, RIGHT.SAS, na.rm = T)) # picks the farthest right distance across populations per variant
data$maxSpan <- data$maxRight - data$minLeft
write.table(data, "GWAS_TAGS.tab" , quote = F, sep = "\t", row.names = F)
q("no")
```
