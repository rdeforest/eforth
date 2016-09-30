# First call by DataTable creates elements.
# Second call satisfies promises to cells.

log = (msg) -> $('body').append msg

try
  person = (name, info = {}) ->
    { role = "slacker", rollingSince = Date.now() } = info
    {name, role, rollingSince}

  columnData = (info) -> {key, value} for key, value of info
  ajaxCall = (url, cb) ->
    jsonData =
      first:
        [ person("Alice"), person("Bob"), person("Charles") ]
      second:
        'Alice':   columnData eat       : 7, sleep          : 9, work             : 8
        'Bob':     columnData poetry    : 3, tv             : 2, games            : 10
        'Charles': columnData horseshoe : 5, 'hand grenade' : 3, 'nuclear weapon' :  1

  makeMagicAccessor = ->
    results = {}

    magicCellFiller = (url, dataKey) ->
      (results[url] or= new Promise (resolve, reject) ->
        fakeAJAXcall url, (err, result) -> result
      ) .then ({fromUrl, data}) ->
          data[dataKey]

  fourthColumnAccessor = makeMagicAccessor()

  $("table").DataTable(
     data: dataset
     columns: [
       { data: "name"         }
       { data: "role"         }
       { data: "rollingSince" }
       { data: (row, type, newValue, meta) ->
           el = $("<div>")
           dataKey = row.name

           fourthColumnAccessor "http://example", dataKey
             .then (table) ->
               $(el).DataTable(
                 data: table
                 columns: [
                   { data: "key"   }
                   { data: "value" }
                 ]
               )
           el
       }
     ]
   )

catch e
  log JSON.stringify e, 0, 2
