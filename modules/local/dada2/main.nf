
process DADA2 {
    // Run DADA2 pipeline including read-tracking

    label 'very_heavy'
    // publishDir "${outdir}/${project}/${sampleId}/asv-gen", pattern : "*.tsv" , mode : "copy" 
    // publishDir "${outdir}/${project}/${sampleId}/asv-gen", pattern : "*chimeric.txt" , mode : "copy" 
    // publishDir "${outdir}/${project}/${sampleId}/asv-gen", pattern : "*matched.txt" , mode : "copy" 


    input:
    tuple val(meta), path(reads)
    path dada2_db
    val(db_label)

    output:
    tuple val(meta), path("*map.txt"), path("*chimeric.txt"), path("*matched.txt"), path("*taxa.tsv"), optional: true, emit: dada2_out

    """
    if [[ ${meta.single_end} = true ]]; then
        Rscript /hps/software/users/rdf/metagenomics/service-team/users/chrisata/asv_gen/bin/dada2.R ${meta.id} $db_label $dada2_db $reads
    else
        Rscript /hps/software/users/rdf/metagenomics/service-team/users/chrisata/asv_gen/bin/dada2.R ${meta.id} $db_label $dada2_db ${reads[0]} ${reads[1]}
    fi
    """

}
