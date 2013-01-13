#import <tinystep/TSObject.h>
#import <tinystep/TSList.h>

@interface TSArrayList : TSObject<TSList> {
	id* _objarray;
	unsigned int _capacity;
	unsigned int _size;
}

-(id) initWithCapacity:(unsigned int) capacity;


@end