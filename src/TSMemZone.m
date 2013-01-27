/*
    Copyright 2013 Paul Soucy

    This file is part of TinyStep.

    TinyStep is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    TinyStep is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser Public License
    along with TinyStep.  If not, see <http://www.gnu.org/licenses/>.
*/



#import <tinystep/TSMemZone.h>
#include <stdlib.h>

typedef struct TSMemZone {
	void* (*malloc)(size_t size);
	void* (*realloc)(void* ptr, size_t size);
	void (*free)(void* ptr);
	const char* name;
} TSMemZone;

static TSMemZone defaultZone = {
	malloc,
	realloc,
	free,
	"default zone"
};


TSMemZone*
TSDefaultZone()
{
	return &defaultZone;
}

void*
TSMalloc(TSMemZone* zone, size_t size)
{
	return zone->malloc(size);
}

void*
TSRealloc(TSMemZone* zone, void* ptr, size_t size)
{
	return zone->realloc(ptr, size);
}

void
TSFree(TSMemZone* zone, void* ptr)
{
	zone->free(ptr);
}

