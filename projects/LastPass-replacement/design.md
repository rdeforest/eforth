# Features

* decentralized / distributed
 * Secure versions of my data are held by my friends and vice-versa
* cross platform
* open standards
* offline operation
* web of trust
* need-to-know

# Terms

Using 'Secret Garden' terminology (need to see if I still have those notes...)

* Exhibit - a collection of secrets
* Patron - a viewer of exhibits
* Curator - a manager of exhibits
* Garden - a collection of curators, patrons and exhibits


# Objects

## Secret

* "name"
* "notes"
* location: SecretLocation
  * .get()
  * .set(data) => promise to write or fail
* .notes("newNotes"?)

## SecretLocation

* pad: SecretPad
* "offset"
* "length"
* .get()
* .set(data)

## SecretPad

* UUID
* assemblyInstructions
  * array of
    * assemblyAdapter
    * assemblyParameters

## AssemblyAdapter

methods:

* assemble()
  * returns data or failure reason(s)
* validate()
  * tests all branches of the tree
  * returns all results
* read(offset, len)
* write(offset, data)
* sync(timeout) - returns when all leaves have updated or timed out

### AnyOneAssembler

parameters:
* subAssemblies = array of AssemblyAdapters
* tried in order, first success is result

### XORAssembler

parameters:
* subAssemblies = array of AssemblyAdapters
* All outputs are XOR'd. If lengths don't match, pad ends with zeros.

### DecryptAssembler

* algo: string
* key: subAssembly
* cypherText: subAssembly

### FetchAssembler

* proto: ProtocolAdapter
* uri: subAssembly
* checksum: subAssembly

### StaticStringAssembler

For supplying strings to other assemblers

* data: string

## SecretPart

* chunk (hashAlgo, hash)
* offset
* length

## Chunk

* hashAlgo
* hash
* bits

## ChunkKey

## Chunk
