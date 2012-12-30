
#import <tinystep/TSConfig.h>

#if	defined(__cplusplus)
extern "C" {
#endif

struct TSMemZone;

TSEXPORT void* 
TSMalloc(struct TSMemZone* zone, size_t size);

TSEXPORT void*
TSRealloc(struct TSMemZone* zone, void* ptr, size_t size);

TSEXPORT void
TSFree(struct TSMemZone* zone, void* ptr);

TSEXPORT struct TSMemZone*
TSDefaultZone();

#if	defined(__cplusplus)
}
#endif

#define TSDefaultMalloc(size) TSMalloc(TSDefaultZone(), size)
#define TSDefaultRealloc(ptr, size) TSRealloc(TSDefaultZone(), ptr, size);
#define TSDefaultFree(ptr) TSFree(TSDefaultZone(), ptr)