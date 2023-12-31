
process MAPSEQ {

    label 'light' // Will likely need to give this task more CPUs 
    container = '/hps/nobackup/rdf/metagenomics/singularity_cache_nextflow/quay.io-biocontainers-mapseq-2.1.1--ha34dc8c_0.img'

    input:
    tuple val(project), val(sampleId), path(subunit_fasta)
    tuple path(db_fasta), path(db_tax), path(db_otu), path(db_mscluster), val(label)
    val outdir

    output:
    tuple val(project), val(sampleId), path('*.mseq'), emit: mapseq_out

    """
    mapseq $subunit_fasta $db_fasta $db_tax -tophits 80 -topotus 40 -outfmt 'simple' > ${subunit_fasta.simpleName}.mseq
    """

}
