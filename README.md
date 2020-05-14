# DynamicKernelShellcode
An example of how x64 kernel shellcode can dynamically find and use kernel APIs (exported from ntoskrnl). <br> Tested on Windows 10 x64 (1903)   
The shellcode is capable of returning function addresses from ntoskrnl. For more practical use, it can easily be modified to call these functions. I used [FASM](https://flatassembler.net/) as the assembler, but there is no special syntax so others should work. The Python file included is capable of generating the hashes needed.

## Useful resources
 - [DoublePulsar Shellcode Information](https://zerosum0x0.blogspot.com/2017/04/doublepulsar-initial-smb-backdoor-ring.html)
 - [Super useful information about IDT](https://ired.team/miscellaneous-reversing-forensics/windows-kernel/interrupt-descriptor-table-idt)
 - [PE Format Image](https://en.wikipedia.org/wiki/Portable_Executable#/media/File:Portable_Executable_32_bit_Structure_in_SVG_fixed.svg)
 - [Great In Depth Information on PE Format](https://github.com/corkami/docs/blob/master/PE/PE.md)
 - [djb2 algorithm](http://www.cse.yorku.ca/~oz/hash.html)
