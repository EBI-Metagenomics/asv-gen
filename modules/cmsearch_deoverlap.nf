
rfam_clan = file("/hps/software/users/rdf/metagenomics/service-team/users/chrisata/asv_gen/data/rfam/ribo.claninfo")

process CMSEARCH_DEOVERLAP {

    label 'light' 
    publishDir "${outdir}/${project}/${sampleId}/sequence-categorisation/", mode : "copy"
    container = '/hps/nobackup/rdf/metagenomics/singularity_cache_nextflow/quay.io-biocontainers-perl-5.22.2.1.img'

    input:
    tuple val(project), val(sampleId), path(cmsearch_out)
    val outdir

    output:
    tuple val(project), val(sampleId), path("${cmsearch_out}.deoverlapped"), emit: cmsearch_deoverlap_out

    """
    perl /hps/software/users/rdf/metagenomics/service-team/users/chrisata/asv_gen/bin/cmsearch-deoverlap.pl --clanin $rfam_clan $cmsearch_out
    """

}
