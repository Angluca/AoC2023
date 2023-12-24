import strutils, strformat
const maxrgb = [12, 13, 14]
var txt = open("./day2.txt")
try:
  var ret, powers = 0; var line = ""
  var r, g, b, id = 0
  while true:
    r=0;g=0;b=0;id=0
    line = txt.readLine()
    let ids = line.split(':')
    id = splitWhitespace(ids[0])[1].parseInt
    for group in ids[1].split(';'):
      for color in group.split(','):
        let cns = color.splitWhitespace()
        var n = 0
        let tmpn = cns[0].parseInt()
        case cns[1]
        of "red":
          n = maxrgb[0];
          if r < tmpn: r = tmpn
        of "green":
          n = maxrgb[1]
          if g < tmpn: g = tmpn
        of "blue":
          n = maxrgb[2]
          if b < tmpn: b = tmpn
        else: discard
        if tmpn > n: id = 0
    ret += id
    powers += r * g * b
    echo "--- id:$#, ret:$#, powers:$# ---" % [$id, $ret, $powers]
except:
  txt.close()

