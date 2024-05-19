
process MAKE_ASV_COUNT_TABLES {
    tag "$meta.id"
    label 'process_long'
    conda "${projectDir}/conf/environment.yml"
    // TODO: use a container

    input:
    tuple val(meta), path(maps), path(asvtaxtable), path(reads), path(extracted_var_path)

    output:
    tuple val(meta), path("*asv_krona_counts.txt"), emit: asv_count_tables_out

    script:
    """
    if [[ ${meta.single_end} = true ]]; then
        zcat $reads | sed -n "1~4p" > headers.txt
        python make_asv_count_table.py -t $asvtaxtable -f $maps -a $extracted_var_path -hd ./headers.txt  -s ${meta.id}
    else
        zcat ${reads[0]} | sed -n "1~4p" > headers.txt
        python make_asv_count_table.py -t $asvtaxtable -f ${maps[0]} -r ${maps[1]} -a $extracted_var_path -hd ./headers.txt  -s ${meta.id}
    fi
    """
}
