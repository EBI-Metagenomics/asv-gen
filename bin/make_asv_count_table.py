
import argparse
from collections import defaultdict
import pandas as pd

def parse_args():

    parser = argparse.ArgumentParser()

    parser.add_argument("-t", "--taxa", required=True, type=str, help="Path to merged FASTA to look for primers")
    parser.add_argument("-f", "--fwd", required=True, type=str, help="Path to merged FASTA to look for primers")
    parser.add_argument("-r", "--rev", required=True, type=str, help="Path to merged FASTA to look for primers")
    parser.add_argument("-a", "--amp", required=True, type=str, help="Path to merged FASTA to look for primers")
    parser.add_argument("-hd", "--headers", required=True, type=str, help="Path to merged FASTA to look for primers")
    parser.add_argument("-s", "--sample", required=True, type=str, help="Sample ID")

    args = parser.parse_args()
  
    _TAXA = args.taxa
    _FWD = args.fwd
    _REV = args.rev
    _AMP = args.amp
    _HEADERS = args.headers
    _SAMPLE = args.sample

    return _TAXA, _FWD, _REV, _AMP, _HEADERS, _SAMPLE


def main():

    _TAXA, _FWD, _REV, _AMP, _HEADERS, _SAMPLE = parse_args()
    
    taxa_df = pd.read_csv(_TAXA, sep="\t", dtype=str)
    taxa_df = taxa_df.fillna("0")
    taxa_df = taxa_df.sort_values(["Kingdom", "Phylum", "Class", "Order", "Genus"], ascending=True)

    amp_reads = [ read.strip() for read in list(open(_AMP, "r")) ]
    headers = [ read.split(" ")[0][1:] for read in list(open(_HEADERS, "r")) ]
    amp_region = ".".join(_AMP.split(".")[1:3])

    asv_dict = defaultdict(int)

    with open(_FWD, "r") as fwd_fr, open(_REV, "r") as rev_fr:

        counter = -1
        for line_fwd, line_rev in zip(fwd_fr, rev_fr):

            counter += 1
            line_fwd = line_fwd.strip()
            line_rev = line_rev.strip()

            fwd_asvs = line_fwd.split(",")
            rev_asvs = line_rev.split(",")

            asv_intersection = list(set(fwd_asvs).intersection(rev_asvs))
            
            if len(asv_intersection) == 0:
                continue
            
            if len(asv_intersection) == 1 and asv_intersection[0] == "0":
                continue
            
            if headers[counter] in amp_reads:
                asv_dict[int(asv_intersection[0]) - 1] += 1
    
    tax_assignment_dict = defaultdict(int)

    for i in range(len(taxa_df)):
        
        sorted_index = taxa_df.index[i]
        asv_count = asv_dict[sorted_index]

        if asv_count == 0:
            continue

        k = taxa_df.loc[sorted_index, "Kingdom"]
        p = taxa_df.loc[sorted_index, "Phylum"]
        c = taxa_df.loc[sorted_index, "Class"]
        o = taxa_df.loc[sorted_index, "Order"]
        f = taxa_df.loc[sorted_index, "Family"]
        g = taxa_df.loc[sorted_index, "Genus"]        

        tax_assignment = ""

        while True:

            if k != "0":
                k = "_".join(k.split(" "))
                if k != "Archaea" and k != "Bacteria":
                    tax_assignment += f"sk__Eukaryota\tk__{k}"
                else:
                    tax_assignment += f"sk__{k}\tk__"
            else:
                break

            if p != "0":
                p = "_".join(p.split(" "))
                tax_assignment += f"\tp__{p}"
            else:
                break
            if c != "0":
                c = "_".join(c.split(" "))
                tax_assignment += f"\tc__{c}"
            else:
                break
            if o != "0":
                o = "_".join(o.split(" "))
                tax_assignment += f"\to__{o}"
            else:
                break
            if f != "0":
                f = "_".join(f.split(" "))
                tax_assignment += f"\tf__{f}"
            else:
                break
            if g != "0":
                g = "_".join(g.split(" "))
                tax_assignment += f"\tg__{g}"
            break

        if tax_assignment == "":
            continue

        tax_assignment_dict[tax_assignment] += asv_count

    with open(f"./{_SAMPLE}_{amp_region}_asv_krona_counts.txt", "w") as fw:
        for tax_assignment, count in tax_assignment_dict.items():
            fw.write(f"{count}\t{tax_assignment}\n")
    

if __name__ == "__main__":
    main()