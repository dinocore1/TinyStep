
#import <tinystep/TSMemZone.h>
#include <stdlib.h>

typedef struct TSMemZone {
	void* (*malloc)(size_t size);
	void (*free)(void* ptr);
	const char* name;
} TSMemZone;

static TSMemZone defaultZone = {
	malloc,
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

void
TSFree(TSMemZone* zone, void* ptr)
{
	zone->free(ptr);
}

