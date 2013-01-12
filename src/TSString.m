
#import <tinystep/TSString.h>
#import <tinystep/TSMemZone.h>
#import <stdlib.h>
#import <string.h>

@implementation TSString

- (id) initWithCString:(const char*)str
{
    self = [super init];
    if(self) {
        _capacity = strlen(str) * (sizeof(char) + 1);
        _buf = TSDefaultMalloc(_capacity);
        memset(_buf, 0, _capacity);
        memcpy(_buf, str, _capacity);
    }
    return self;
}

-(const char *)cString
{
    return (const char*)_buf;
}

-(void) dealloc
{
	if(_buf) {
		TSDefaultFree(_buf);
	}
	_capacity = -1;
	[super dealloc];
}

-(TSString*) toString
{
    return self;
}

@end

@implementation TSStringComparator

-(int) compareObj:(id)a to:(id)b
{
    const char* astr = [a cString];
    const char* bstr = [b cString];

    return strcmp(astr, bstr);
}

@end


#define DEFAULT_CAPACTIY 256

@implementation TSStringBuffer

-(id) init
{
    self = [super init];
    if(self) {
        _buf = TSDefaultMalloc(DEFAULT_CAPACTIY);
        //memset(_buf, 0, DEFAULT_CAPACTIY);
        _capacity = DEFAULT_CAPACTIY;
        _used = 0;
    }
    return self;
}

-(void) appendCString:(char*)str
{
    unsigned int size = strlen(str);
    while((sizeof(char) * (_used + size + 1)) > _capacity) {
        int newsize = _capacity*2;
        _buf = TSDefaultRealloc(_buf, newsize);
        _capacity = newsize;
    }
    char* theStr = (char*)_buf;
    strcat(&theStr[_used], str);
    _used += size;
}

-(void) dealloc
{
    TSDefaultFree(_buf);
    [super dealloc];
}

-(TSString*) toString
{
    return [[TSString alloc] initWithCString:_buf];
}

@end
