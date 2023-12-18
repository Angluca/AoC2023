let ns = @["zero","one","two","three","four","five","six","seven","eight","nine"]
let nd = @["0","1","2","3","4","5","6","7","8","9"]
proc getd(s: string, l: int, ss: seq[string]): int =
  for d, sz in ss:
    let n = sz.len()-1
    if s[l..^1].len()-1 < n:
      continue
    elif s[l..l+n] == sz:
      return d
  return -1

proc getn(s: string): int =
  var l = 0; var r = s.len-1
  var ln, rn = -1
  while ln < 0 or rn < 0:
    while ln < 0 and l <= r:
      if s[l] > 'Z': ln = getd(s, l, ns)
      else: ln = getd(s, l, nd)
      l+=1
    while rn < 0 and r >= l:
      if s[r] > 'Z': rn = getd(s, r, ns)
      else: rn = getd(s, r, nd)
      r-=1
    if r < l and rn < 0: rn = ln
    if not (ln < 0 or rn < 0):
      return ln * 10 + rn

var txt = open("./day1.txt")
try:
  var l, n, ret = 0; var s = ""
  while true:
    s = txt.readLine()
    n = getn(s)
    ret += n; l += 1
    echo "--- l:", l," n:",n," result = ", ret , " ---"
except:
  txt.close()

