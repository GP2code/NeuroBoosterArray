# Neuro Booster Array
Repository for the Neuro Booster Array developed in part by Data Tecnica International, NIA, NINDS, GP2 and Illumina. We lovingly refer to it as the "NBA"!

`GP2 ❤️ Open Science 😍`

**Last Updated:** October 2023

## Summary
This is the online repository for the for the manuscript titled ***"NeuroBooster Array: A Genome-Wide Genotyping Platform to Study Neurological Disorders Across Diverse Populations"***. 

## Design Statement
Please see the content linked here for the [variants on the GDA array (the backbone of Neuro booster)](https://drive.google.com/file/d/19RKjwB-HI8Cf9n3sP_gYpkg-_lusOcgK/view?usp=sharing) plus [custom content related to Neurodegenerative conditions](https://drive.google.com/file/d/1li50Oin0ctVQTFN5O9ctIKJw4i5Acisu/view?usp=sharing).

## Concept
To make a content pack that will support the analysis of neurodegenerative disease (NDD) genetics. 
###### This is in concert with Illumina ClinVar and PGX content packs regarding SNP selection. 

## Goals
We are aiming to:  
1. Identify coding and rare familial variants of interest to researchers on the NDD field.  
2. Improve imputation of known GWAS loci for NDDs across populations of diverse continental ancestries to facilitate trans-ethnic studies.  
3. Generally improve imputation quality across populations of diverse continental ancestries to facilitate risk locus discovery.  

## General design : 4 components

#### Component 1: HGMD systematic review

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

#### Component 3: Dense Tagging of GWAS regions.

Using PLINKv1.9, we identified tag SNPS per GWAS hit of interest for each disease of interest included in the following publications:  
Jansen et al, 2019 https://www.nature.com/articles/s41588-018-0311-9  
Kunkle et al, 2019 https://www.nature.com/articles/s41588-019-0358-2  
Nalls et al, 2019 https://www.biorxiv.org/content/10.1101/388165v3.article-info  
Iwaki et al, 2019 https://www.biorxiv.org/content/10.1101/585836v2  
Nicolas et al, 2019 https://www.cell.com/neuron/abstract/S0896-6273(18)30148-X  
Guerreiro et al, 2018 http://www.thelancet.com/retrieve/pii/S1474442217304003  
Hoglinger et al, 2011 https://www.ncbi.nlm.nih.gov/pubmed/21685912  
Ferrari et al, 2014 http://www.thelancet.com/retrieve/pii/S1474442214700651  

These GWAS hits are summarized in the table GWAShits.tab included in this repository.

We identified most distal tag SNPs for each hit across all 6 super-populations.

These regions identified here are considered our priority regions.

Additionally the 1805 SNPs from the extended polygenic risk score (PRS) in Nalls et al, 2019 will be included.  

Code for this analysis can be found in this repository.

#### Component 4: Imputation boosters for diverse populations.

We have decided on 2 sets of tag SNPs for each chip based on available custom content per base array.

Filtering for GSA based arrays:  
GWAS region tagging filters for inclusion are as follows
General imputation booster filters for inclusion are as follows

Code for this analysis can be found in this repository.

