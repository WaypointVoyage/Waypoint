#!/usr/bin/env python

mapSize = (2732.0, 1794.0 - 255.0,)

points = [
   (312, 1273),
   (292, 1017),
   (94, 610),
   (633, 479),
   (409, 345),
   (919, 400),
   (1103, 655),
   (1597, 795),
   (2057, 986),
   (2044, 836),
   (1782, 476),
   (2323, 327),
]

def do_print(prefix, x, y):
    print("{}(to: WPTTrailMapNode.scaledPoint(x: {}, y: {}, size: size))".format(
        prefix, x / mapSize[0], y / mapSize[1]
    ))

do_print("path.move", points[0][0], points[0][1])
for coord in points[1:]:
    do_print("path.addLine", coord[0], coord[1])
