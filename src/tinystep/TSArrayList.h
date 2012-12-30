#import <tinystep/TSObject.h>
#import <tinystep/TSList.h>

typedef struct aliterator
{
	unsigned int index;
} aliterator;

@interface TSArrayList : TSObject<TSList> {
	id* _objarray;
	unsigned int _capacity;
	unsigned int _size;
}

-(id) initWithCapacity:(unsigned int) capacity;


-(void) iterator:(aliterator*) it;
-(BOOL) next:(aliterator*) it obj:(id*)objptr;

@end