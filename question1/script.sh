#!/bin/bash

### Load Digital Alliance module dependencies for nf-core/ampliseq
module load StdEnv/2023
module load python/3.13.2
module load rust/1.76.0
module load postgresql/16.0
python -m venv nf-core-env
source nf-core-env/bin/activate
python -m pip install nf_core==3.2.0
module load nextflow/24.04.4
module load apptainer/1.3.5
export NXF_SINGULARITY_CACHEDIR=~/scratch/NXF_SINGULARITY_CACHEDIR



### Input Variables

# Primers provided by interviewer
FW_PRIMER="TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGGTGCCAGCMGCCGCGGTAA"
RV_PRIMER="GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGGACTACHVGGGTWTCTAAT"

# Input parameters
SAMPLESHEET=~/scratch/samplesheet.tsv
OUTDIR=~/scratch/ampliseq_results
REFERENCE=~/scratch/silva_nr99_v138.2_toGenus_trainset.fa.gz
REFERENCE_SP=~/scratch/silva_v138.2_assignSpecies.fa.gz
METADATA=~/scratch/metadata.tsv


### Uncomment below to download nf-core/ampliseq workflow 
# export NFCORE_PL=ampliseq
# export PL_VERSION=2.12.0
# nf-core download ${NFCORE_PL} --container-cache-utilisation amend --container-system  singularity   --compress none -r ${PL_VERSION}

### Uncomment to download Silva databases
# wget https://zenodo.org/records/14169026/files/silva_nr99_v138.2_toGenus_trainset.fa.gz
# wget https://zenodo.org/records/14169026/files/silva_v138.2_assignSpecies.fa.gz

cd ~/scratch/nf-core-ampliseq_2.12.0/2_12_0/

# Run local version of ampliseq
nextflow run main.nf \ 
	-profile singularity \ 
	--input $SAMPLESHEET \ 
	--FW_primer $FW_PRIMER \ 
	--RV_primer $RV_PRIMER \ 
	--outdir $OUTDIR \ 
	--dada_ref_tax_custom $REFERENCE \ 
	--dada_ref_tax_custom_sp $REFERENCE_SP \ 
	--trunc_qmin 32 \ 
	--double_primer \ 
	--vsearch_cluster \ 
	--metadata $METADATA 
