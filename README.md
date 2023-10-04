# GloboNeuroArray  
Now renamed the "NeuroBoosterArray" although it kinda sounds like a vitamin.

# Annotated content [linked here](https://drive.google.com/drive/folders/1K8f-yn_VuwhL-Ff863EzCi61MHbGmgvu?usp=share_link) from VEP as of Dec '22.  

Repo to track build of the "GloboNeuro" array, silly codename and all.

# November revision note!!!
Design wil be prioritize the new GDA array.  
We have added SNVs fromthe systematic reivew with DM? designations as well as additional KoL variants and DIIs from the systematic reivew (acknowledging that many will fail scoring).  
Once the scoring is done we will fill out the rest of the ~100K bead types with tag SNPs.
See zip file dataed November 19th for content.

## Overall concept

The overall concept is to make a content pack that will support the analysis of neurodegenerative disease (NDD) genetics. 
###### This will be in concert with Illumina ClinVar and PGX content packs regarding SNP selection. And a choice of either GSA or MEG back bones for primary content.

Our NDDs of interest include:  
Parkinson's disease (PD)  
Alzheimer's disease / general dementia (AD)  
Dementia with Lewy bodies (DLB)  
Amyotrophic Lateral Sclerosis (ALS)  
Parasupranuclear palsy (PSP)  
Frontotemporal Dementia (FTD)  

We are aiming to:  
1. Identify coding and rare familial variants of interest to researchers on the NDD field.  
2. Improve imputation of known GWAS loci for NDDs across populations of diverse continental ancestries to facilitate trans-ethnic studies.  
3. Generally improve imputation quality across populations of diverse continental ancestries to facilitate risk locus discovery.  

This is an extension of existing array designs in collaboration with Illumina.  We will focus on modular content for two "backbone" arrays, the Infinium Global Screening Array-24 v2.0  (GSA) and Infinium Multi-Ethnic Global-8 Kit (MEG), both including the pharmacogenetics content options, targeted at ~$50USD and ~$100USD per sample.

Content for aims 2 and 3 will be triaged based on available array real-estate. We forecast ~85K SNPs for from aims 2 and 3 for the GSA derived array and ~300K for the MEG derived array.

###### Targeting design list prototype submitted by mid-May 2019.

## General design

### 4 design components

#### Component 1: HGMD systematic review, GenomicsEngland query, plus KoL submitted variants.

First step in this phase is to query the Human Genome Mutation Database (HGMD, https://www.qiagenbioinformatics.com/products/human-gene-mutation-database/) and extract all coding changes tagged with neurodegenerative disease outcomes.
###### This is in progress and will likely be delivered the week of April 29th. We forecast ~11K variants in this subset of data.

The second step is querying Genomics England disease-specific expert panels in concert with gnomad variant extraction.

The third step is contact with KoLs. We will share the HGMD derived list with these individuals. We will allow them to add content to the list based on sequencing in familial samples, with preference to coding changes relating to risk for our diseases of interest.

These KoLs include:  
International Parkinson's Disease Genomics Consortium principal investigators.  
Henry Houlden, Kin Mok and Mie Rizig at University College London.  
Bryan Traynor and Sonja Scholz at the US National Institutes of Health.
###### We will allow 2 weeks for variant nomination by KoLs after delivery of the HGMD derived variant list. We forecast a maximum of ~15K total variants including the ~11K HGMD nominated variants.

#### Component 2: Identifying multi-population tag SNPs.

Running TagIt (https://github.com/statgen/TagIt) across 6 super-populations (from http://www.internationalgenome.org/data-portal/sample, accessed April 30th 2019) including:  
AMR <-- MXL, CLM, PEL, PUR (Latino ancestry populations)  
EAS <-- JPT, CDX, CHB, CHS, KHV, CHD (East Asian populations)  
EUR <-- TSI, IBS, GBR, CEU (European populations, note the FIN are excluded as outliers in PCA)  
SAS <-- PJL, ITU, STU, GIH, BEB (South Asian populations)  
AFR <-- GWD, MSL, ESN, GWJ, YRI, LWK, GWF, GWW (African populations)  
AAC <-- ASW, ACB (African American and Caribbean populations)  

We are focusing only on tags at a minor allele frequency (MAF) > 1% and an r2 > 0.5 as per the TagIt publication recommendations (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6169386/). Additionally, a tag must be in at least 3 populations. Moreover, outside of specific SNPs relating to Component 1 above, we will also only analyze dbSNPs with rsIDs.

Code for this and implementing the analysis on the NIH Biowulf Cluster (https://hpc.nih.gov) can be found in this repository.

As a quick note, PLINKv1.9 (https://www.cog-genomics.org/plink2) was used for all LD comparisons w/in superpopulations (r2 > 0.2 w/in 1MB windows), it was also used for allele frequency calcs.

Summary statistics from this analysis are downloadable from the following link here.

#### Component 3: Dense Tagging of GWAS regions.

Using PLINKv1.9, we identified tag SNPS per GWAS hit of interest for each disease of interest included in the following publications:  
Jansen et al, 2019 https://www.nature.com/articles/s41588-018-0311-9  
Kunkle et al, 2019 https://www.nature.com/articles/s41588-019-0358-2  
Nalls et al, 2019 https://www.biorxiv.org/content/10.1101/388165v3.article-info  
Iwaki et al, 2019 https://www.biorxiv.org/content/10.1101/585836v2  
Nicolas et al, 2019 https://www.cell.com/neuron/abstract/S0896-6273(18)30148-X  
Guerriero et al, 2018 http://www.thelancet.com/retrieve/pii/S1474442217304003  
Hoglinger et al, 2011 https://www.ncbi.nlm.nih.gov/pubmed/21685912  
Ferrari et al, 2014 http://www.thelancet.com/retrieve/pii/S1474442214700651  

These GWAS hits are summarized in the table GWAShits.tab included in this repository.

We identified most distal tag SNPs for each hit across all 6 super-populations.

These regions identified here are considered our priority regions.

Additionally the 1809 SNPs from the extended polygenic risk score (PRS) in Nalls et al, 2019 will be included.  

Code for this analysis can be found in this repository.

#### Component 4: Imputation boosters for diverse populations.

We have decided on 2 sets of tag SNPs for each chip based on available custom content per base array.

Filtering for GSA based arrays:  
GWAS region tagging filters for inclusion are as follows <--   
General imputation booster filters for inclusion are as follows <--   
###### This includes XX,XXX GWAS region tagging SNPs and XX,XXX general imputation boosting SNPs.  

Filtering for MEG based arrays:  
GWAS region tagging filters for inclusion are as follows <--   
General imputation booster filters for inclusion are as follows <--   
###### This includes XX,XXX GWAS region tagging SNPs and XX,XXX general imputation boosting SNPs.  

Code for this analysis can be found in this repository.
