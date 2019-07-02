## 2 content packs (different but compatible levels of filtering) tuned for 2 different array backbones (GSA and MEG).

1. NeuroGlobo_Basic - tuned for GSA - 50-80K SNPs in total (currently ~24K total variants in ```basic_content```)  
-NDD GWAS hits (~200 variants) - NDD_GWAS_hits.txt   
-HGMD variants (~20K variants filtered for rsID, DM and not an indel, taken from Genomics England panel genes, KOL nominated genes and disease keywords) - NDD_HGMD_reduced.csv  
-PD polygenic risk scoring variants (~2K variants) - NallsEtAl2019.PRS_gr37_PD.txt  
-Houlden lab diverse population NDD variants, priority variants only (~200 variants) - Houlden.Diverse_NDD_priority.txt   
-Asian PD variants from the Hardy / Mok lab (~200 variants) - Mok.Asian_PD.txt   
-Asian AD variants from the Hardy / Mok lab (~600 variants) - Mok.Asian_PD.txt  
-Corvol lab additional pharmaco genomics variants (~100 variants) - Corvol.Additional_pharmaco_variants.txt  
-Morris lab additional candidate variants (~60 variants) - Morris.Additional_UCL_variants.txt  
-Hjelm lab mitochondrial variants (~60 variants) - Hjelm.Mito_variants.txt  
-Zimprich familial variants (~40 variants) - Zimprich.Familial_variants.txt
-Billingsley transposons (~1K variants) - Billingsley.transposon_tagging_variants.txt
-NDD locus tagging variants (Sample across regions to fill out remaining beadpool, pending)  

2. NeuroGlobo_XL - tuned for MEG - NeuroGlobo_Basic + additional 50K  (currently ~53K variants in ```xl_content```)  
-Remainder of DM / non indel variants from HGMD variants (~40K in total) - NDD_HGMD.csv  
-Additonal candidate variants from the Houlden lab (~9K in total) - Houlden.Diverse_NDD.tab  
-Additional NDD locus tagging variants for locus saturation  

## Note: Illumina is handling making the general impute booster for GSA. An impute booster is not needed for MEG. NDD locus tagging variants will be added prior to array build and are a random sampling of multi-ancestry tag SNPs across NDD GWAS loci.

## To do (Mike):
Add Craig and Narendra variants ~1.5K to each content pack 
Drop Wolff-Parkinson-white syndrome variants from HGMD pulls
