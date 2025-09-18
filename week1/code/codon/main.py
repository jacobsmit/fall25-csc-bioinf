import sys
from utils import read_data
from dbg import DBG

# In Codon, there's no need to set recursion limit like Python
# sys.setrecursionlimit(1000000)  <-- remove this

def main():
    # Ensure proper usage
    if len(sys.argv) < 2:
        print("Usage: ./main <data_folder>")
        sys.exit(1)

    # Get the input data folder
    data_path = "./" + sys.argv[1]
    output_path = data_path + "/contig.fasta"


    # Load FASTA files
    short1, short2, long1 = read_data(data_path)

    # Initialize the de Bruijn graph with k-mer size 25
    k: int = 25
    dbg = DBG(k=k, data_list=[short1, short2, long1])

    # Generate contigs and write to output file
    with open(output_path, "w") as f:
        for i in range(20):
            c = dbg.get_longest_contig()
            if c is None:
                break
            print(i, len(c))
            f.write(f">contig_{i}\n")
            f.write(c + "\n")

if __name__ == "__main__":
    main()
