## Run with ... 
## Rscript formatR2s.R $POP $CHRNUM

library("data.table")

args <- commandArgs()
print(args)
thisPop <- as.character(args[6])
thisChr <- as.character(args[7])

## For testing
# thisPop <- "AFR"
# thisChr <- "11"

prefix <- paste(thisPop, ".chr", thisChr, sep = "")

mapIn <- paste(prefix, ".phase3_v5a.biallelic_PASS_MAC3.bim", sep = "")
mapRaw <- fread(file = mapIn, header = F)
names(mapRaw) <- c("CHR","SNP","CM","BP","MINOR","MAJOR")
mapRaw$Name <- paste(mapRaw$CHR,":", mapRaw$BP, "_", mapRaw$MINOR, "/", mapRaw$MAJOR, "_", mapRaw$SNP, sep = "")
mapReduced <- mapRaw[,c("SNP","Name")]

ldIn <- paste("./r2s/", prefix, ".ld.gz", sep = "")
LD <- fread(file = ldIn, header = T)
dataTemp <- merge(LD, mapReduced, by.x = "SNP_A", by.y = "SNP")
data <- merge(dataTemp, mapReduced, by.x = "SNP_B", by.y = "SNP")
data$MARKER1 <- data$Name.x
data$MARKER2 <- data$Name.y
data$AF1 <- data$MAF_A
data$AF2 <- data$MAF_B
data$R <- sqrt(data$R2)
dat <- data[,c("MARKER1","MARKER2","AF1","AF2","R2","R")]
names(dat)[1] <- "#MARKER1"

outFile <- paste( prefix, ".pairLD.txt", sep = "")

fwrite(dat, file = outFile, quote = F, sep = "\t", row.names = F, na = NA)

q("no")

## Don't forget to gzip after this