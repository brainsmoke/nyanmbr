
import sys, itertools

def coord_to_byte(x, y):
    x, y = x+10, y+4
    if x > 0x1f or y > 0x7:
        raise Exception()

    return (x&0x1f) | (y&0x07)<<5

def word_to_byte(w):
    x = (w+640)%1280 - 640
    x, y = x/4+10, (w-x)/1280+4
    return (x&0x1f) | (y&0x07)<<5

def byte_to_word(b):
    b <<= 2
    x=b
    b >>= 7
    b = b*1152
    return -5160+x+b

_ = -1
X = -2
TERM=4

stars = (

(
	(_, _, _, 1, _, _, _),
	(_, _, _, 2, _, _, _),
	(_, _, _, _, _, _, _),
	(3, 4, _, X, _, 5, 6),
	(_, _, _, _, _, _, _),
	(_, _, _, 7, _, _, _),
	(_, _, _, 8, _, _, _),
),

(
	(_, _, _, 0, _, _, _),
	(_, 7, _, _, _, 1, _),
	(_, _, _, _, _, _, _),
	(6, _, _, X, _, _, 2),
	(_, _, _, _, _, _, _),
	(_, 5, _, _, _, 3, _),
	(_, _, _, 4, _, _, _),
),

)

io_stars = (

(
	(_, _, _, 0, _, _, _),
	(_, _, _, _, _, _, _),
	(_, _, _, 1, _, _, _),
	(_, _, _, X, _, _, _),
	(_, _, _, 2, _, _, _),
	(_, _, _, _, _, _, _),
	(_, _, _, 3, _, _, _),
),

(
	(_, _, _, 0, _, _, _),
	(_, 7, _, _, _, 1, _),
	(_, _, _, _, _, _, _),
	(6, _, _, X, _, _, 2),
	(_, _, _, _, _, _, _),
	(_, 5, _, _, _, 3, _),
	(_, _, _, 4, _, _, _),
),

)

def find_coord(n, grid):
	for y,row in enumerate(grid):
		for x,cell in enumerate(row):
			if cell == n:
				return (x, y)
	return None

def get_coord_list(grid, ysink=1):
	l = []
	last = find_coord(X, grid)
	for i in itertools.count():
		coord = find_coord(i, grid)

		if coord == None and i == 0:
			coord = last

		if coord == None:
			break

		l.append( (coord[0]-last[0], coord[1]-last[1]) )

		last = (coord[0], coord[1]+ysink)

	return l

for i, frame in enumerate(stars):
	print ".byte "+', '.join( str(coord_to_byte(x, y)) for x, y in get_coord_list(frame) ) + ', '+str(TERM)

for i, frame in enumerate(io_stars):
	print ".byte "+', '.join( str(coord_to_byte(x, y)) for x, y in get_coord_list(frame,ysink=2) ) + ', '+str(TERM)


