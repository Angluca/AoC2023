import std/[strutils, strformat, math]

var points, i = 0
var ns: seq[int]
try:
  for line in lines("day4.txt"):
    let card = line.split(':')
    let group = card[1].split('|')
    let g1 = group[0].splitWhitespace()
    let g2 = group[1].splitWhitespace()

    var wn = 0
    for n in g1:
      if n in g2:
        wn.inc

    if wn > 0: points += (1 shl (wn - 1)) # part1
    # part2
    while wn+i > ns.high: ns.add(1)
    for n in 1..wn:
      ns[n+i] += ns[i]
    i.inc
  echo "part1 = ", points
  echo "part2 = ", sum(ns)
except:
  echo "------ error -------"


