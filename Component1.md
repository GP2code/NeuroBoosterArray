## HGMD systematic review
Faraz systematically reviewed HGMD extracting all variants relating to the annotations for the diseases below. Similar to NeuroX and NeuroArray efforts.  
Spreadsheet is in this repo as ```HGMD 2019-1 scrape draft3.xlsx```.

## HGMD scraping
Used HGMD version: 2019-1

Excel file includes two sheets:
1. Nucleotide Substitutions (Missense/Nonsense, Regulatory, Splicing)
2. Nucleotide Deletions,Insertions and Indels

### Count
Nucleotide Substitutions = 26,541
Nucleotide Deletions,Insertions and Indels = 8,617
**Total variants = 35,158**

### Method

We have searched for mutations which includes the following terms in their "disease/phenotypes" field:
- Amyotrophic lateral sclerosis
- Spastic paraplegia
- Parkinson
- Alzheimer
- Gaucher disease
- Rett syndrome
- CADASIL
- Frontotemporal
- Ataxia
- Fabry disease
- Cardiomyopathy
- Retinitis pigmentosa
- Niemann-Pick
- Muscular dystrophy
- dyskinesia
- Neuronal ceroid lipofuscinosis
- Deafness
- Spinal muscular atrophy
- Sandhoff
- Tay-Sachs
- leukoencephalopathy
- Multiple system atrophy
- Neurodegeneration with brain iron accumulation
- Restless legs syndrome
- Kufor-Rakeb syndrome
- supranuclear palsy
- Dystonia
- Neuro
- Lewy bodies


We can possibily include the following "disease/phenotypes" as well:
- Autism
- Hearing loss
- Phenylketonuria
- Schizophrenia
- Usher syndrome
- Rubinstein-Taybi
- Gangliosidosis
- Leber congenital amaurosis
- Stargardt
- Albinism
- Haemochromatosis
- Progressive external ophthalmoplegia
- Wilson
- Papillon-Lefevre
- Bardet-Biedl
- Cystinuria
- Joubert
- Fanconi anaemia
- IBMPFD
- Hypercholesterolaemia
- Thalassaemia
- Mucopolysaccharidosis
- Complex I deficiency
- Marfan syndrome
- Methylmalonic aciduria
- Aromatic L-amino acid decarboxylase deficiency
- Alpers syndrome
- Mucolipidosis
- Corticobasal
- Tourette syndrome

## Space concerns versus annotations
It is likely that we will have to exclude the variants annotated with class "DM?" based on lack of evidence and INDELS due to array design issues.
This would bring the count down from 35,158 to 26,149.
If we further filter to just variants with rsIDs it goes to 10,268 variants.

## KOL engagement
List circulated to KOLs May 8th 2019, with a 2 week limit to add any variants desired in a similar format.  
Submissions of ancillary variants due to Mike Nalls by Wednesday May 22nd at CoB eastern US time.
This list is ```HGMD_to_collabs.txt``` and includes only a limited number of fields.
KOLs must justify variants.

## PD risk PRS list
See the file in this repo ```PD_PRS.txt```. SNP IDs are in gr37, CHR:BP format.
