#
#PBS -l select=1:ncpus=10:mem=400gb
#PBS -l walltime=100:00:00
#PBS -k oe
#PBS -M csr745@newcastle.edu.au
#PBS -m bae

cd $PBS_O_WORKDIR

source /etc/profile.d/modules.sh
module --silent load qiime/2019.10-python3.6
module --silent load R/4.0.1
module --silent load qiime/2019.10-python3.6
module --silent load R/4.0.1


export TMPDIR=/home/csr745/qiime_tmp


qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads  silva-138-ssu-nr99-seqs-derep-uniq.qza \
  --i-reference-taxonomy silva-138-ssu-nr99-tax-derep-uniq.qza \
  --o-classifier silva-16S-V1-3-classifier.qza \
  --p-classify--chunk-size 700 \
  --verbose

exit 0

