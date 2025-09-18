import os

# Read a FASTA file and return a list of strings
def read_fasta(path: str, name: str) -> list[str]:
    data: list[str] = []
    full_path = path + '/' + name
    with open(full_path, 'r') as f:
        for line in f:
            line = line.strip()
            if line and line[0] != '>':  # skip header lines
                data.append(line)
    print(name, len(data), len(data[0]))
    return data

# Read the three datasets and return them
def read_data(path: str) -> tuple[list[str], list[str], list[str]]:
    short1 = read_fasta(path, "short_1.fasta")
    short2 = read_fasta(path, "short_2.fasta")
    long1 = read_fasta(path, "long.fasta")
    return short1, short2, long1
