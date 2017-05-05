qvmm++

- units of allocation are called blobs
- blobs have double-pointers or bi-directional pointers to allow movement
- they have an owner
- other owners may request read-only copies
- doing so causes the primary owner's reference to become a copy of a shared reference
- copies use the same storage unless they're mutated
- when mutated, copies become their own blobs
- blobs are only ref-counted in the sense that copies which still consume a blob when its owner dies must 

# More generically

Initial references are strong
Additional references are week until they are mutated
Then they become strong and the original's reference may become weak

