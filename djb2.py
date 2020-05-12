# From http://www.cse.yorku.ca/~oz/hash.html

import sys

def djb2Hash(string):                                                                                                                                
    hash = 5381
    for char in string:
        hash = (( hash << 5) + hash) + ord(char)
    return(hash & 0xFFFFFFFF) # limit to DWORD size
      
# main
if (len(sys.argv) == 2):
    print(hex(djb2Hash(sys.argv[1])))
else:
    print("Example: djb2.py CreateFileA")
