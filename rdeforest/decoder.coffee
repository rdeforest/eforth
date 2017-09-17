test = Buffer.from ('''
  \u0000
    \u0001 \u0000 \u0007 Service
        \t \u0000      5 com.amazon.apolloapi.coral.generated#ApolloAPIService
    \u0002 \u0000 \u0007 Service
   
    \u0001 \u0000   \t Operation
        \t \u0000    = com.amazon.apolloapi.coral.generated#DescribeAutoScalingGroup
    \u0002 \u0000   \t Operation

    \u0001 \u0000 \u0007 Version
        \t \u0000 \u0003 1.0
    \u0002 \u0000 \u0007 Version

    \u0001 \u0000 \u0005 Input
    \u0000
      \u0001 \u0000 \u0006 __type
          \t \u0000      D  com.amazon.apolloapi.coral.generated#DescribeAutoScalingGroupRequest
      \u0002 \u0000 \u0006 __type
      
      \u0001 \u0000 \u000f IncludeChildren
      \u000b               \u0001
      \u0002 \u0000 \u000f IncludeChildren
      
      \u0001 \u0000 \u001a AutoScalingGroupIdentifier
      \u0000
        \u0001 \u0000 \u0006 __type
            \t \u0000      A com.amazon.apollo.base.coral.generated#AutoScalingGroupIdentifier
        \u0002 \u0000 \u0006 __type

        \u0001 \u0000 \u001a EnvironmentStageIdentifier
        \u0000
          \u0001 \u0000 \u0005 Stage
              \t \u0000 \u0004 Prod
          \u0002 \u0000 \u0005 Stage

          \u0001 \u0000 \u000f EnvironmentName
              \t \u0000 \u001c EICheshire/EISWS/Internal/JP
          \u0002 \u0000 \u000f EnvironmentName
          
        \u0003
        \u0002 \u0000 \u001a EnvironmentStageIdentifier

        \u0001 \u0000 \u0013 AutoScalingGroupTag
            \t \u0000 \u0004 2am4
        \u0002 \u0000 \u0013 AutoScalingGroupTag
        
      \u0003
      \u0002 \u0000 \u001a AutoScalingGroupIdentifier
    \u0003
    \u0002 \u0000 \u0005 Input
  \u0003
 '''.replace /[ \r\n]/g, '')

class Element
  constructor: (@buffer, idx = 0) ->
    @idx = idx

    if @constructor is Element
      unless klass = Element[typeName = @readType()]
        throw new Error "Unknown element type '#{typeName}'"

      #console.log "@#{@idx - 1}: Detected #{klass.name}"

      return new klass @buffer, @idx

    #console.log "Constructed #{@constructor.name}"

    @readValue()
    @len = @idx - idx
    #console.log "#{@constructor.name}: len #{@len}, value #{@value}"

  readValue: ->

  types:
    0:  'Document'
    1:  'Group'
    2:  'EndGroup'
    3:  'EndDocument'
    9:  'PascalString'
    11: 'Binary'

  readOctet: ->
    #console.log "@#{@idx}: #{
    octet = @buffer.readUInt8 @idx++
    #}"

    octet

  readType: ->
    @types[typeId = @readOctet()] or
      throw new Error "Unknown element type '#{typeId}'"

class Element.EndGroup extends Element
  readValue: ->
    {@idx, @value} = (new Element.PascalString @buffer, @idx)

class Element.EndDocument extends Element
  # Document ends have no data

class Element.Binary extends Element
  readValue: -> @value = not not @readOctet()

class Element.PascalString extends Element
  readValue: ->
    len    = @readOctet() * 256 + @readOctet()
    subbuf = @buffer.slice @idx, @idx += len

    #console.log "value: " +
    s = subbuf.toString()

    @value = s

class Element.Document extends Element
  readValue: ->
    @value = []
    keys   = {}
    dupes  = false

    loop
      {@idx} = v = new Element @buffer, @idx

      break if v instanceof Element.EndDocument

      @value.push v.value

    for v in @value
      if 'object' isnt typeof v or Object.keys(v).length > 1 or keys[k = Object.keys(v)[0]]
        return

      keys[k] = true

    @value = Object.assign {}, @value...

class Element.Group extends Element
  readValue: ->
    { @idx } = key = new Element.PascalString @buffer, @idx

    elements =
      loop
        { @idx } = value = new Element @buffer, @idx
        break if value instanceof Element.EndGroup
        value.value

    if elements.length is 1 then elements = elements[0]

    @value = "#{name = key.value}": elements

    #console.log "Group: ", @

    if name isnt value.value
      throw new Error "Unmatched braces: #{key.value} vs #{value.value}"


msg = "\u0000\u0001\u0000\u0007Service\t\u00005com.amazon.apolloapi.coral.generated#ApolloAPIService\u0002\u0000\u0007Service\u0001\u0000\tOperation\t\u0000=com.amazon.apolloapi.coral.generated#DescribeAutoScalingGroup\u0002\u0000\tOperation\u0001\u0000\u0007Version\t\u0000\u00031.0\u0002\u0000\u0007Version\u0001\u0000\u0005Input\u0000\u0001\u0000\u0006__type\t\u0000Dcom.amazon.apolloapi.coral.generated#DescribeAutoScalingGroupRequest\u0002\u0000\u0006__type\u0001\u0000\u000FIncludeChildren\u000B\u0001\u0002\u0000\u000FIncludeChildren\u0001\u0000\u001AAutoScalingGroupIdentifier\u0000\u0001\u0000\u0006__type\t\u0000Acom.amazon.apollo.base.coral.generated#AutoScalingGroupIdentifier\u0002\u0000\u0006__type\u0001\u0000\u001AEnvironmentStageIdentifier\u0000\u0001\u0000\u0005Stage\t\u0000\u0004Prod\u0002\u0000\u0005Stage\u0001\u0000\u000FEnvironmentName\t\u0000\u001CEICheshire/EISWS/Internal/JP\u0002\u0000\u000FEnvironmentName\u0003\u0002\u0000\u001AEnvironmentStageIdentifier\u0001\u0000\u0013AutoScalingGroupTag\t\u0000\u00042am4\u0002\u0000\u0013AutoScalingGroupTag\u0003\u0002\u0000\u001AAutoScalingGroupIdentifier\u0003\u0002\u0000\u0005Input\u0003"

decode = (buffer) -> (new Element Buffer.from buffer).value

module.exports = {decode, Element, msg}

Object.assign global, module.exports
