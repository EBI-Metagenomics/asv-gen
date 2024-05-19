
process STD_PRIMER_FLAG {
    // Check for presence of standard library of primers (stored in ./data/standard_primers)
    tag "$meta.id"
    label 'very_light'
    conda "${projectDir}/conf/environment.yml"

    // TODO: add a container

    input:
    tuple val(meta), path(reads_merged)
    path(std_primer_library)

    output:
    tuple val(meta), path("*std_primers.fasta"), emit: std_primer_out
    path "*std_primer_out.txt"

    script:
    """
    standard_primer_matching -i $reads_merged -p $std_primer_library -s ${meta.id}_${meta.var_region} -o ./
    """

}
