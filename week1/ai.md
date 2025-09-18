AI models used:
- ChatGPT (GPT-5)

Prompts:

actions.yml:
- Explain the different parts of this file and why they are needed.
- - Walked though how the file works.

evaluate.sh:
- Given this output of contigs (pasted output) write a bash function to calculate the N50.
- - Upon iteratively giving input, arrived on a working solution.
- Record the execution runtime of the Python and Codon scripts in the form MM:SS:MS.
- - Produced a working solution.
- Format the table so the rows and columns align properly (with a screenshot of the output).
- - First solution was misaligned.
- - Second iteration was successful. 

code: 
- Copied error with associated code: utils.py:16 (29-62): error: cannot use calls in type signatures...
- - A tuple was written using (..., ..., ...) instead of tuple[...]
- Make the changes needed for this file to work with Codon, this includes type hinting.
- - Gave a first baseline change. 
- - Needed to make manual changes to fix errors.

other:
- Are there any options to increase the stack size above the hard size for Mac.
- - Ran into issues with stack size. 
- - Turns out there are not, but the increase works for the GitHub runner.
