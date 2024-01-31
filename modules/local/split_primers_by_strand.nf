
process SPLIT_PRIMERS_BY_STRAND {
    // Split the concatenated primer files into two, one containing the fwd primers, and one for the rev

    label 'light'
    // publishDir "${outdir}/${project}/${sampleId}/primer-identification", mode : "copy" 
    
    input:
    tuple val(meta), path(concat_primers)

    output:
    tuple val(meta), path("fwd_primer.fasta"), path("rev_primer.fasta"), emit: stranded_primer_out

    shell:
    '''
    if [[ -s !{concat_primers} ]]; then

        fwd_flag="$(grep -A 1 --no-group-separator '^>.*F' !{concat_primers} || true)"
        rev_flag="$(grep -A 1 --no-group-separator '^>.*R' !{concat_primers} || true)"

        if [[ ! -z $fwd_flag ]]; then
            grep -A 1 --no-group-separator '^>.*F' !{concat_primers} > ./fwd_primer.fasta
        else
            touch ./fwd_primer.fasta
        fi

        if [[ ! -z $rev_flag ]]; then
            grep -A 1 --no-group-separator '^>.*R' !{concat_primers} > ./rev_primer.fasta
        else
            touch ./rev_primer.fasta
        fi
    fi
    '''
}