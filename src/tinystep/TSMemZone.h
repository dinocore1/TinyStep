
#import <tinystep/TSConfig.h>

#if	defined(__cplusplus)
extern "C" {
#endif

struct TSMemZone;

TSEXPORT void* 
TSMalloc(struct TSMemZone* zone, unsigned int size);

TSEXPORT void
TSFree(struct TSMemZone* zone, void* ptr);

TSEXPORT struct TSMemZone*
TSDefaultZone();

#if	defined(__cplusplus)
}
#endif

#define TSDefaultMalloc(size) TSMalloc(TSDefaultZone(), size);
#define TSDefaultFree(ptr) TSFree(TSDefaultZone(), ptr);