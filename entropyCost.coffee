module.exports.cost =
cost = (entropyBits = cost.entropyBits
        dollarsPerkWh = cost.dollarsPerkWh
        hostPowerDrawWatts = cost.hostPowerDrawWatts
        hashesPerSecond = cost.hashesPerSecond
        timeLimit = cost.timeLimit) ->
  seconds = 2 ** entropyBits / hashesPerSecond
  kWh = seconds * hostPowerDrawWatts / 3600000
  hostsNeeded = Math.ceil seconds / timeLimit

  dollars = dollarsPerkWh * kWh

  {seconds, kWh, hostsNeeded, dollars}

Object.assign cost,
  entropyBits       : 64
  dollarsPerkWh     : 0.10
  hostPowerDrawWatts: 500   # 180 for GPU, 70 for rest of machine, x2 for cooling
  hashesPerSecond   : 2900  # per https://gist.github.com/epixoip/a83d38f412b4737e99bbef804a270c40
  timeLimit         : 86400
