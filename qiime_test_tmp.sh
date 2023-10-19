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

qiime feature-classifier classify-sklearn \
  --i-classifier silva-16S-V1-3-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification training_taxonomy.qza

qiime metadata tabulate \
  --m-input-file training_taxonomy.qza \
  --o-visualization training_taxonomy.qzv


exit 0

