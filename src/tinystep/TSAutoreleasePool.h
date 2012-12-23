
#import <tinystep/TSObject.h>


struct autorelease_array_list;
@interface TSAutoreleasePool : TSObject {
	TSAutoreleasePool* _parent;
	struct autorelease_array_list* _released;
	struct autorelease_array_list* _released_head;
	unsigned _released_count;
}

+(void) addObject: (id)anObj;
+(id) currentPool;

-(void) addObject: (id)anObj;


@end