
#import <tinystep/TSHashMap.h>
#import <tinystep/TSMemZone.h>
#import <tinystep/TSArrayList.h>

#define DEFAULT_TABLESIZE 32

@implementation TSHashMap

unsigned int inline 
betterhash(unsigned int key){
	/* Robert Jenkins' 32 bit Mix Function */
	key += (key << 12);
	key ^= (key >> 22);
	key += (key << 4);
	key ^= (key >> 9);
	key += (key << 10);
	key ^= (key >> 2);
	key += (key << 7);
	key ^= (key >> 12);

	/* Knuth's Multiplicative Method */
	key = (key >> 3) * 2654435761;

	return key;
}

-(id) init
{
	self = [super init];
	if(self) {
		_table = TSDefaultMalloc( sizeof(TSArrayList*) * DEFAULT_TABLESIZE );
		_tableSize = DEFAULT_TABLESIZE;
	}
	return self;
}

-(unsigned int) size
{
	return _size;
}

-(void) clear
{

}

-(id) put:(id)key value:(id)value
{

}

-(id) get:(id)key
{
	id retval = nil;
	unsigned int index = betterhash([key hash]) % _tableSize;
	TSArrayList* list = _table[index];

	id obj = nil;
	aliterator it;
	[list iterator:&it];
	while([list next:&it obj:&obj]){
		if([obj isEqual:key]){
			retval = obj;
			break;
		}
	}

	return retval;
}

@end