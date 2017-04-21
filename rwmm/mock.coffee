# Just a sort of working pseudo-code version of what would later be done in C
# or C++. Features:
#
#  - copy-on-write
#  - reference counting
#  - double-pointers allow objects to move behind the scenes

class BlobOwner
  constructor: ->
    @blobs []


class StrongRef
  constructor: (@owner, @size) ->

  copyForWrite: (@owner, @offset, @length) ->

class WeakRef extends StrongRef
  constructor: (@owner, @size, @sourceRef, @offset) ->

  copyForWrite: (@owner, @offset, @length) ->

class AllocatedChunk
  constructor: (@pool, @offset, @size) ->

class MemoryPool
  constructor: (@size) ->
    @heap    = Buffer.alloc @size
    @objects = []
    @refs    = []
    @setupFreeLists()

  setupFreeLists: ->
    pending = @size
    top = 0
    size = 1024
    n++ while n ** 2 < @size
    @freeLists = []

    while pending and n > 8
      n--
      bsize = n**2
      @freeLists[n] = @freeBlock top, bsize
      top += bsize

  acquire: (size) ->

  alloc: (size) ->
    offset = @acquire size
    @objects.push o = new AllocatedChunk @, offset, size

class Consumer

