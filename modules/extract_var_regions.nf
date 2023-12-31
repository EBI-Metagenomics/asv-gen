process EXTRACT_VAR_REGIONS {

    label 'light'
    publishDir "${outdir}/${project}/${sampleId}/amplified-region-inference", pattern : "*.fastq.gz" , mode : "copy"
    container = '/hps/nobackup/rdf/metagenomics/singularity_cache/quay.io_biocontainers_seqtk:1.3.sif'

    input:
    tuple val(project), val(sampleId), path(var_region_path), path(fastq)
    val outdir

    output:
    tuple val(project), val(sampleId), val(var_region), path("*.fastq.gz"), emit: extracted_var_out
    tuple val(project), val(sampleId), val(var_region), path(var_region_path), emit: extracted_var_path
    
    script:
    var_region = "${var_region_path.baseName.split('\\.')[1,2].join('-')}"

    """
    seqtk subseq $fastq $var_region_path > ${fastq.baseName}_${var_region}_extracted.fastq
    gzip ${fastq.baseName}_${var_region}_extracted.fastq
    """

}