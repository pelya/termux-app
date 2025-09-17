     .global blob
     .global blob_size
     .section .rodata
 blob:
 #if defined __i686__
     .incbin "bootstrap-noexe-i686.zip"
 #elif defined __x86_64__
     .incbin "bootstrap-noexe-x86_64.zip"
 #elif defined __aarch64__
     .incbin "bootstrap-noexe-aarch64.zip"
 #elif defined __arm__
     .incbin "bootstrap-noexe-arm.zip"
 #else
 # error Unsupported arch
 #endif
 1:
 blob_size:
     .int 1b - blob
