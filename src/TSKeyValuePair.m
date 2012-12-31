#import <tinystep/TSKeyValuePair.h>


@implementation TSKeyValuePair

-(id) initWithPair:(id) key value:(id)value
{
	self = [super init];
	if(self) {
		_key = [key retain];
		_value = [value retain];
	}
	return self;
}

-(id) key
{
	return _key;
}

-(id) value
{
	return _value;
}

-(void) dealloc
{
	[_key release];
	[_value release];
	[super dealloc];
}

@end