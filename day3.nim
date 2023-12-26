import std/[strutils, strformat, tables]

const maxw = 141
var gears = newOrderedTable[int, int]() # xy, id
var ids: seq[int]
var ratios: seq[int]

template isNum(n: char|int): bool =
  (if n.int > 0x2f and n.int < 0x3A: true else: false)
template isSym(n: char|int): bool =
  (if not (n.int == 0xa or n.int == 0x2e or (n.int > 0x2f and n.int < 0x3A)): true else: false)

proc collide(map: cstring, xy: int): int =
  if (not isNum(map[xy])) or gears.hasKey(xy): return 1
  let px = xy %% maxw
  var lt, rt = 0
  while true:
    if px - lt - 1 < 0: break
    if isNum(map[xy-lt-1]): lt+=1
    else: break
  while true:
    if px + rt + 1 > maxw - 1: break
    if isNum(map[xy+rt+1]): rt+=1
    else: break

  let sx = xy - lt
  let sw = lt + rt + 1
  var sz: array[8, byte]
  copyMem(sz.addr, map[sx].addr, sw)
  let n = parseInt($cast[cstring](sz.addr))
  let id = ids.len + 1
  ids.add(n)
  result = n
  for i in 0..<sw:
    if gears.hasKey(sx + i): continue
    gears.add(sx + i, id)

proc collision(map: cstring, xy: int) =
  var ns: array[8, int]
  ns[0] = collide(map, xy - maxw - 1)
  ns[1] = collide(map, xy - maxw)
  ns[2] = collide(map, xy - maxw + 1)
  ns[3] = collide(map, xy - 1)
  ns[4] = collide(map, xy + 1)
  ns[5] = collide(map, xy + maxw - 1)
  ns[6] = collide(map, xy + maxw)
  ns[7] = collide(map, xy + maxw + 1)
  if map[xy] == '*':
    var r = 1; var t = 0
    for i in 0..<ns.len:
      if ns[i] > 1: t.inc
      r *= ns[i]
    if t > 1: ratios.add(r)

var txt = open("day3.txt")
try:
  let map = txt.readAll()
  for xy in 0..<map.len:
    if isSym(map[xy]):
      collision(map, xy)
  var n = 0
  for i in 0..<ids.len:
    n += ids[i]
  var rn = 0
  for i in 0..<ratios.len:
    rn += ratios[i]
  echo "part1 = ", n
  echo "part2 = ", rn
except:
  echo "----- error -----"
finally:
  txt.close()

