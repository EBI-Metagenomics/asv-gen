
include { MAPSEQ } from '../modules/mapseq.nf'
include { MAPSEQ2BIOM } from '../modules/mapseq2biom.nf'
include { KRONA } from '../modules/krona.nf'

workflow MAPSEQ_OTU_KRONA {
    
    take:
        subunit_fasta
        silva_tuple
        outdir

    main:

        MAPSEQ(
            subunit_fasta,
            silva_tuple,
            outdir
        )

        MAPSEQ2BIOM(
            MAPSEQ.out.mapseq_out,
            silva_tuple,
            outdir
        )

        krona_input = MAPSEQ2BIOM.out.mapseq2biom_out
                      .map( { tuple(it[0], it[1], it[3]) } )

        KRONA(
            krona_input,
            silva_tuple,
            outdir
        )

    emit:
        krona_input = krona_input
        krona_out = KRONA.out.krona_out
    
}