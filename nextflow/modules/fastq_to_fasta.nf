
process fastq_to_fasta {
    
    label 'light'
    // publishDir "${outdir}/merged/${project}", mode : "copy"
    container = '/hps/nobackup/rdf/metagenomics/singularity_cache/quay.io_biocontainers_seqtk:1.3.sif'

    input:
    tuple val(project), path(fastq)
    val outdir

    output:
    tuple val(project), path("*.fasta"), emit: merged_fasta

    """
    seqtk seq -a $fastq > ${fastq.simpleName}.fasta
    """

}
