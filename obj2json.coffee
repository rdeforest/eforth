
# My own JSON formatter, with hookers and blackjack

flattenOnce = (l) -> l.reduce ((acc, item) -> acc.concat item), []

indent = (l, pad = '  ') -> l.map (s) -> pad + s

applyBrackets = (rep, brackets, indent) ->
  [left, right] = brackets
  left += ' '

  if rep.length is 1
    [ left + rep[0] + ' ' + right ]
  else
    [ left + rep[0]
      (indent rep[1..])...
      right
    ]

addComma = (l) ->
  [head..., tail] = l
  head.concat tail + ","

addCommas = (l) ->
  for rep, i in l
    if i isnt l.length - 1
      addComma rep
    else
      rep

arr2json = (obj) ->
  return [ '[]' ] if obj.length is 0

  brackets = ['[', ']']

  reps = obj.map (item) -> obj2json item

  applyBrackets flattenOnce(addCommas reps), brackets, indent

keyValueRep = (k, v, indent) ->
  kRep = JSON.stringify k

  vRep = obj2json v

  if vRep.length is 1
    [ "#{kRep}: #{vRep[0]}" ]
  else
    [ "#{kRep}:" ].concat indent vRep

obj2json = (obj) ->
  if 'object' isnt typeof obj
    return [ JSON.stringify obj ]

  if Array.isArray obj
    return arr2json obj

  reps =
    Object
      .getOwnPropertyNames obj
      .map (k) ->
        v = obj[k]
        keyValueRep k, v, indent

  applyBrackets flattenOnce(addCommas(reps)), ['{', '}'], indent
        
module.exports = (o) ->
  obj2json(o).join '\n'

Object.assign module.exports, { applyBrackets, flattenOnce, obj2json, arr2json, keyValueRep, addComma, addCommas, indent }

global.data = [
  { "alarmCustomer" : "S3"
    "metrics" : [
      "id" : 44
      "label" : "Requests by Operation" ]
  }
  { "alarmCustomer" : "Router-Info"
    "metrics" : [ {
      "id" : 307
      "label" : "Router to NFC host info" } ]
    "suppressingMetrics": [ {
      "id" : 1633
      "label" : "SNMP BytesIn by Interface and Host" } ]
    "suppressingCutoff": 60000000
  }
  { "alarmCustomer" : "Border-NetFlow"
    "metricCustomers" : [
      "Border-Incoming"
      "Border- Outgoing"
    ]
    "metrics" : [
      { "id" : 1198, "label" : "Border-Incoming-SrcIp-Packets" }
      { "id" : 1199, "label" : "Border-Outgoing-DestIp-Packets" }
    ]
    "suppressingMetrics": [ {
      "id" : 1633
      "label" : "SNMP        BytesIn by Interface and Host" } ]
    "suppressingCutoff": 60000000
  }
  { "alarmCustomer" : "Health", "metrics" : [ { "id" : 140012, "label" : "Health-SrcIp-Packets-Lossless-BOM" } ] }, { "alarmCustomer" : "DC-NetFlow", "metricCustomers" : [ "EC2-Incoming", "EC2-Outgoing", "S3-NetFlow-Outgoing", "S3-NetFlow-Incoming" ], "metrics" : [ { "id" : 74, "label" : "Packets by Source IP" }, { "id" : 46, "label" : "Packets by Source IP" } ], "suppressingMetrics": [ { "id" : 1633, "label" : "SNMP BytesIn by Interface and Host" } ], "suppressingCutoff": 60000000 }, { "alarmCustomer" : "S3-EventBus", "metrics" : [ { "id" : 1591, "label" : "Top agent hosts" } ] } ]
