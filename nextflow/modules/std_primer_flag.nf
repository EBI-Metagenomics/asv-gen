
process STD_PRIMER_FLAG {
    // Check for presence of standard library of primers (stored in ./data/standard_primers)

    label 'light'
    publishDir "${outdir}/${project}", mode : "copy"

    input:
    tuple  val(project), val(sampleId), path(fastq)
    val outdir

    output:
    tuple val(project), val(sampleId), path("*std_primers.fasta"), emit: std_primer_out
    path "*std_primer_out.txt"


    """
    python /hps/software/users/rdf/metagenomics/service-team/users/chrisata/asv_gen/bin/standard_primer_agrep.py -i $fastq -s ${fastq.simpleName} -o ./
    """

}
