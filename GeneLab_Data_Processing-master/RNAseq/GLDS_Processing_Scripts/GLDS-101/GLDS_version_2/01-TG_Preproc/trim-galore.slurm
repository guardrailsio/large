#!/bin/bash
#
#SBATCH --job-name="GLDS-101_trimgalore"
#SBATCH --output=TG_out_logs/GLDS-101_trimgalore_%A_%a.out
#SBATCH --mem=6000
#SBATCH --array=1-12
#
#SBATCH --mail-user=user@nasa.gov
#SBATCH --mail-type=END

start=$(date +%s)
echo "start time: $start"
echo $HOSTNAME
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

out_dir=/GLDS-101/01-TG_Preproc/Fastq
in_dir=/GLDS-101/00-RawData/Fastq

sample=$(cat samples.txt | sed -n ${SLURM_ARRAY_TASK_ID}p)

echo "SAMPLE: ${sample}"

call="trim_galore --gzip \
--phred33 \
--illumina \
--output_dir $out_dir \
--paired \
$in_dir/${sample}_R1_raw.fastq.gz $in_dir/${sample}_R2_raw.fastq.gz"

echo $call
eval $call

end=$(date +%s)
echo "end time: $end"
runtime_s=$(echo $(( end - start )))
echo "total run time(s): $runtime_s"
sec_per_min=60
sec_per_hr=3600
runtime_m=$(echo "scale=2; $runtime_s / $sec_per_min;" | bc)
echo "total run time(m): $runtime_m"
runtime_h=$(echo "scale=2; $runtime_s / $sec_per_hr;" | bc)
echo "total run time(h): $runtime_h"

