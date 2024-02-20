
process ASSESS_MCP_CONS {
    // Use Most Common Prefix (MCP) method to generate curves of base conservation
    tag "$meta.id"
    label 'light'

    input:
    tuple val(meta), val(fwd_flag), val(rev_flag), path(reads_merged)

    output:
    tuple val(meta), path("*mcp_cons.tsv"), optional: true, emit: mcp_cons_out

    """
    if [[ ${fwd_flag} = "auto" ]] && [[ ${rev_flag} = "auto" ]]; then
        python /hps/software/users/rdf/metagenomics/service-team/users/chrisata/asv_gen/bin/assess_mcp_proportions_MERGED.py -i $reads_merged -s ${meta.id}_${meta.var_region} -st FR -o ./
    elif [[ ${fwd_flag} = "auto" ]]; then
        python /hps/software/users/rdf/metagenomics/service-team/users/chrisata/asv_gen/bin/assess_mcp_proportions_MERGED.py -i $reads_merged -s ${meta.id}_${meta.var_region} -st F -o ./
    elif [[ ${rev_flag} = "auto" ]]; then
        python /hps/software/users/rdf/metagenomics/service-team/users/chrisata/asv_gen/bin/assess_mcp_proportions_MERGED.py -i $reads_merged -s ${meta.id}_${meta.var_region} -st R -o ./
    else
        touch ${meta.id}_${meta.var_region}_mcp_cons.tsv
    fi
    """

}