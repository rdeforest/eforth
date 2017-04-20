###

Once upon a time, in a kingdom far, far away, there lived a king Byteasar VIII.
The king came down in history as a great warrior, since he managed to defeat
the enemy that has been capturing the cities of the kingdom over more than a
century. When the war was over, most of the cities were almost completely
destroyed, and there was no way to raise them from the debris. Byteasar decided
to start cities renovation by merging them.

The king decided to merge each pair of cities cityi, cityi+1 for i = 0, 2, 4,
... if they were connected by one of the two-way roads running through the
kingdom.

Initially, all information about the roads were stored in the roadRegister.
Your task is to return the roadRegister after the merging was performed,
assuming that after merging the cities reindexation is done in such way that
city formed out of cities a and b (where a < b) receives index a, and all the
cities with numbers i (where i > b) get numbers i - 1.

###

class City
  constructor: (@roads) ->

  roadTo: (other) ->
  roadFrom: (other) ->

class RoadRegister
  constructor: (@roadRegister) ->


  cities: ->


mergingCities = (roadRegister) ->
 register = new RoadRegister roadRegister

