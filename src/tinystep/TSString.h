
#import <tinystep/TSObject.h>
#import <tinystep/TSComparator.h>

@interface TSString : TSObject {
  void* _buf;
  int _capacity;
}

- (id) initWithCString:(const char*)str;
- (const char*) cString;

@end

@interface TSStringComparator : TSObject<TSComparator> {
}

@end

@interface TSStringBuffer : TSObject {
	void* _buf;
	unsigned int _capacity;
	unsigned int _used;
}

-(void) appendCString:(char*)str;

-(TSString*) toString;

@end

