#!/usr/bin/env python

map_size = (2732.0, 2049.0)
aspect_ratio = 16.0 / 9.0
h = map_size[0] / aspect_ratio
print("h: {}".format(h))
ymin = (map_size[1] - h) / 2.0
ymax = ymin + h

point_count = 12
points = [
    (330, 515), # start
    (400, 600),
    (380, 690),
    (290, 780), # 1
    (118, 930),
    (100, 1032),
    (95, 1181), # 2
    (81, 1328),
    (213, 977),
    (633, 1313), # 3
    (951, 1570),
    (274, 1283),
    (409, 1446), # 4
    (512, 1654),
    (655, 1643),
    (915, 1391), # 5
    (1212, 1265),
    (1233, 1234),
    (1100, 1133), # 6
    (1063, 631),
    (1459, 597),
    (1598, 1000), # 7
    (1860, 945),
    (2268, 226),
    (2056, 808), # 8
    (1584, 434),
    (1757, 1227),
    (2042, 958), # 9
    (2063, 1151),
    (1979, 1260),
    (1781, 1312), # 10
    (1555, 1609),
    (1904, 1791),
    (2318, 1470), # treasure
]

def convert_x(x):
    return x / map_size[0]

def convert_y(y):
    return 1 - (y - ymin) / h

for i in range(point_count):
    if i == 0:
        p = points[0]
        print("path.move(to: WPTTrailMapNode.scaledPoint(x: {}, y: {}, size: size))".format(
            convert_x(p[0]), convert_y(p[1])
        ))
    else:
        target = points[3 * i]
        other1 = points[3 * i - 2]
        other2 = points[3 * i - 1]
        print("path.addCurve(to: {}, controlPoint1: {}, controlPoint2: {})".format(
            "WPTTrailMapNode.scaledPoint(x: {}, y: {}, size: size)".format(
                convert_x(target[0]), convert_y(target[1])
            ),
            "WPTTrailMapNode.scaledPoint(x: {}, y: {}, size: size)".format(
                convert_x(other1[0]), convert_y(other1[1])
            ),
            "WPTTrailMapNode.scaledPoint(x: {}, y: {}, size: size)".format(
                convert_x(other2[0]), convert_y(other2[1])
            )
        ))
