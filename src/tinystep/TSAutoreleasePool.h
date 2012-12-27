
#import <tinystep/TSObject.h>


struct autorelease_array_list;
@interface TSAutoreleasePool : TSObject {
	TSAutoreleasePool* _parent;
	TSAutoreleasePool* _child;
	struct autorelease_array_list* _released;
	struct autorelease_array_list* _released_head;
	unsigned int _released_count;

	/* The method to add an object to this pool used for faster calling*/
  	void (*_addImp)(id, SEL, id);
}

+(id) currentPool;
+(void) addObject: (id)anObj;

-(void) addObject: (id)anObj;

-(void) emptyPool;


@end