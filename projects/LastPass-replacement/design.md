# Let's try again

```coffeescript

  definitions =
    secret:
      clearText: "String"
      recoveryMethod:
        connectionInfo: ObjectImplementing 'fetch'
        recoveryParameters: [ "String" ]


```

- Secret
  - clearText
  - recoveryMethod, id
  - description

- RecoveryMethod
  - protocol
  - connection info
  - ...

- Viewer
  - public key

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
