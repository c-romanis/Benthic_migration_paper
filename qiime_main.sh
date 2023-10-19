#
#PBS -l select=1:ncpus=5:mem=200gb
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

qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path /home/csr745/Chapter_3/forward/ \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path /home/csr745/Chapter_3/demux-single-end.qza
 

qiime demux summarize \
  --i-data /home/csr745/Chapter_3/demux-single-end.qza \
  --o-visualization /home/csr745/Chapter_3/demux-single-end.qzv

qiime dada2 denoise-single \
  --i-demultiplexed-seqs /home/csr745/Chapter_3/demux-single-end.qza \
  --p-trim-left 5 \
  --p-trunc-len 240 \
  --o-table /home/csr745/Chapter_3/chpt3_table.qza \
  --o-representative-sequences /home/csr745/Chapter_3/chpt3_single_rep-seqs.qza \
  --o-denoising-stats /home/csr745/Chapter_3/chpt3_single_denoising-stats.qza

qiime feature-table summarize \
  --i-table /home/csr745/Chapter_3/chpt3_table.qza \
  --o-visualization /home/csr745/Chapter_3/chpt3_single_table.qzv \
  --m-sample-metadata-file /home/csr745/Chapter_3/chpt3_sample_metadata.tsv

qiime feature-table tabulate-seqs \
  --i-data /home/csr745/Chapter_3/chpt3_single_rep-seqs.qza \
  --o-visualization /home/csr745/Chapter_3/chpt3_single_rep-seqs.qzv

qiime metadata tabulate \
  --m-input-file /home/csr745/Chapter_3/chpt3_single_denoising-stats.qza \
  --o-visualization /home/csr745/Chapter_3/chpt3_single_denoising-stats.qzv
 
qiime feature-classifier classify-sklearn \
  --i-classifier /home/csr745/silva-16S-V1-3-classifier.qza \
  --i-reads /home/csr745/Chapter_3/chpt3_single_rep-seqs.qza \
  --o-classification /home/csr745/Chapter_3/chpt3_single_taxonomy.qza

qiime metadata tabulate \
  --m-input-file /home/csr745/Chapter_3/chpt3_single_taxonomy.qza \
  --o-visualization /home/csr745/Chapter_3/chpt3_single_taxonomy.qzv

qiime taxa barplot \
  --i-table /home/csr745/Chapter_3/chpt3_table.qza \
  --i-taxonomy /home/csr745/Chapter_3/chpt_3_taxonomy.qza \
  --m-metadata-file /home/csr745/Chapter_3/chpt3_sample_metadata.tsv \
  --o-visualization /home/csr745/Chapter_3/chpt3_taxa-bar-plot.qzv

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences /home/csr745/Chapter_3/chpt3_single_rep-seqs.qza \
  --o-alignment /home/csr745/Chapter_3/chpt3_single_aligned-rep-seqs.qza \
  --o-masked-alignment /home/csr745/Chapter_3/chpt3_single_masked-aligned-rep-seqs.qza \
  --o-tree /home/csr745/Chapter_3/chpt3_single_unrooted-tree.qza \
  --o-rooted-tree /home/csr745/Chapter_3/chpt3_single_rooted-tree.qza

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny /home/csr745/Chapter_3/chpt3_single_rooted-tree.qza \
  --i-table /home/csr745/Chapter_3/chpt3_table.qza \
  --p-sampling-depth 25000 \
  --m-metadata-file /home/csr745/Chapter_3/chpt3_sample_metadata.tsv \
  --output-dir /home/csr745/Chapter_3/core-metrics-results

qiime diversity alpha-rarefaction \
  --i-table /home/csr745/Chapter_3/chpt3_table.qza \
  --i-phylogeny /home/csr745/Chapter_3/chpt3_single_rooted-tree.qza \
  --p-max-depth 124870 \
  --m-metadata-file /home/csr745/Chapter_3/chpt3_sample_metadata.tsv \
  --o-visualization /home/csr745/Chapter_3/chpt3_single_alpha-rarefaction.qzv

exit 0
