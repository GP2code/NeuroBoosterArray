## This component has 2 parts:
#### 1. HGMD systematic review
#### 2. KOL SNP sumbissions

## HGMD systematic review
Faraz systematically reviewed HGMD extracting all variants relating to the annotations for the diseases below and Genomics England panel list. Similar to NeuroX and NeuroArray efforts.  
Spreadsheet is in this repo as ```HGMD crawl - disease and gene based - v4```.

Used HGMD version: 2019-1

Excel file includes two sheets:
1. Nucleotide Substitutions (Missense/Nonsense, Regulatory, Splicing)
2. Nucleotide Deletions,Insertions and Indels

### Count
Nucleotide Substitutions = 69,809
Nucleotide Deletions,Insertions and Indels = 20,082
**Total variants = 89,891**

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
- Autism
- Schizophrenia

We can possibily include the following "disease/phenotypes" as well:
- Hearing loss
- Phenylketonuria
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

### Genomics England expert panel mining

Data pull for Genomics England panels from May 9th 2019.
Genes from the following diseases were extracted if they met the "Expert Review Green":
- Amyotrophic lateral sclerosis_motor neuron disease
- Early onset dementia (encompassing fronto-temporal dementia and prion disease)
- Hereditary ataxia - adult onset
- Hereditary ataxia
- Hereditary neuropathy
- Hereditary spastic paraplegia
- Inherited white matter disorders
- Neurodegenerative disorders - adult onset
- Neuromuscular disorders
- Neurotransmitter disorders
- Pain syndromes
- Parkinson Disease and Complex Parkinsonism
- Paroxysmal neurological disorders, pain disorders and sleep disorders
- White matter disorders - adult onset

Filtered as below:
```
cd ~/Downloads/genomicsEnglandPanels_May9th2019
cat *.tsv | grep 'Expert Review Green' | grep -v 'Model_Of_Inheritance' > ../temp.tsv
awk '{ if ($2 == "gene") {print} }' ../temp.tsv > genes.tab
awk '{ if ($2 == "str") {print} }' ../temp.tsv > str.tab
```
This gives us 1114 genes and 85 str. There is some overlap across disease panels though.
```
sort -u -k1,1 genes.tab > genesUniq.tab
sort -u -k1,1 str.tab > strUniq.tab
```
After filtering out duplicate gene and STR names, we get down to 590 candidate NDD genes and 17 STRs.

Additional lysosomal storage disorder genes added by KoLs. We requeried HGMD includign these genes.

#### In total we queried 625 genes in the file ```geneList.csv``` during the HGMD pull.

### Space concerns versus annotations
It is likely that we will have to exclude the variants annotated with class "DM?" based on lack of evidence and INDELS due to array design issues.
This would bring the count down from almost 90K to 55,712.
If we further filter to just variants with rsIDs it goes to 21,612 variants.

## KOL variant submissions
KOLs also submitted asianNDD, mito and additional pharmaco variants.
These can be found in ```Asian_*_variants.txt and pharmaco_variants.txt```. Mitochondrial variants are pending.

## PD risk PRS list
See the file in this repo ```PD_PRS.txt```. SNP IDs are in gr37, CHR:BP format.
