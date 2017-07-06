module.exports =
  starRotation = (matrix, width, center, t) ->
    return matrix unless t = t % 8

    radius = width >> 1
    [cx, cy] = center
    
    justSign = (n) -> if n then n / Math.abs(n) else 0

    angles = [[5, 6, 7]
              [4, 8, 0]
              [3, 2, 1]]

    cart2rad = (x, y) ->
      [dx, dy] = [x - cx, y - cy]
      r = Math.abs Math.max dx, dy
      angle =
        if (Math.abs(dx) > radius) or
           (Math.abs(dy) > radius) or
           dx and dy and dx not in [-dy, dy]
          8
        else
          angles[1 + justSign dy][1 + justSign dx]
      ret = [angle, r]
      #console.log "x #{x}, y #{y} -> angle #{angle}, r #{r}"
      ret
    
    sin = [0, 1, 1, 1, 0, -1, -1, -1]
    cos = sin[2..].concat sin[0..1]

    rad2cart = (angle, r) ->
      [dx, dy] = [r * cos[angle], r * sin[angle]]
      console.log "angle #{angle}, r #{r} -> dx #{dx}, dy #{dy}"
      ret = [cx + dx, cy + dy]

    ret = matrix
      .map (row, y) ->
        row.map (cell, x) ->
          [angle, r] = cart2rad x, y

          if angle is 8 then return cell

          fromAngle = (6 + angle + t) % 8

          [x2, y2] = rad2cart fromAngle, r
          matrix[y2][x2]

    console.log ret.map((row) -> row.join " ").join "\n"
    #ret
