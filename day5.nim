import std/strutils
const Part1 = false # false is Part2
type
  Range = tuple[st, ed: uint = 0]
  RgTs = tuple[rg: Range, st = 0u]
func range(st: uint, n: SomeNumber = 1): Range = (st, st+n.uint)
template isInRange(s: Range, t: RgTs): untyped = isInRange(s, t.rg, t.st)
proc isInRange(self, a: Range, tgst = 0u): (bool, Range) =
  if (a.ed < self.st and a.st < self.st) or (a.st > self.ed and a.ed > self.ed): return
  var rg, tg: Range
  rg.st = if self.st < a.st: a.st else: self.st
  rg.ed = if self.ed < a.ed: self.ed else: a.ed
  tg.st = ((rg.st.int64 - a.st.int64) + tgst.int64).uint
  tg.ed = ((rg.ed.int64 - rg.st.int64) + tg.st.int64).uint
  return (true, tg)

var txt = open("day5.txt")
try:
  let tt = txt.readAll()
  var tall = tt.split("\n\n")
  var
    tmp = tall[0].split(": ")[1].split()
    maps: seq[seq[RgTs]]
    seeds: seq[Range]
    ts,n = 0u
  for s in tmp:
    if Part1: # part 1
      seeds.add(range(s.parseUInt))
    else: # Part2
      n.inc
      case n:
      of 1: ts = s.parseUInt
      else:
        n = 0
        seeds.add(range(ts, s.parseUInt))

  for q in tall[1..^1]:
    var
      t = q.split(":")[1].splitWhitespace
      tt: seq[RgTs]
      ts, rs, n = 0u
    for s in t:
      n.inc
      case n:
      of 1: ts = s.parseUInt
      of 2: rs = s.parseUInt
      else:
        n = 0
        tt.add(((rs, rs+s.parseUInt), ts))
    maps.add(tt)

  var curRangs, nextRanges: seq[Range]
  curRangs = seeds
  for map in maps:
    for cur in curRangs:
      var tmp: seq[Range]
      for rgts in map:
        var (yes, tg) = isInRange(cur, rgts)
        if yes:
          tmp.add(tg)
      if tmp.len > 0: nextRanges.add(tmp)
      else: nextRanges.add(cur)
    curRangs = nextRanges
    nextRanges = @[]
  var ret = uint.high
  for cur in curRangs:
    if cur.st < ret:
      ret = cur.st
  echo ret
except:
  echo "------ error -------"
finally:
  txt.close()


