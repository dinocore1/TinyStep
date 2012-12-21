
#import <tinystep/TSString.h>
#import <stdlib.h>
#import <string.h>

@implementation TSString

- (id) initWithCString:(const char*)str
{
    self = [super init];
    if(self) {
        _capacity = strlen(str) * sizeof(char);
        _buf = malloc(_capacity);
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
		free(_buf);
	}
	_capacity = -1;
	[super dealloc];
}

@end
