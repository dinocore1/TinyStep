#import <tinystep/TSMap.h>
#import <tinystep/TSObject.h>

@class TSArrayList;
@interface TSHashMap : TSObject<TSMap> {
	TSArrayList** _table;
	int _tableSize;
	unsigned int _size;
} 

@end