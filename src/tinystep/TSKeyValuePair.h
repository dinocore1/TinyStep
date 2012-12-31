#import <tinystep/TSObject.h>

@interface TSKeyValuePair : TSObject {
	id _key;
	id _value;
}

-(id) initWithPair:(id) key value:(id)value;

@property (readonly) id key;
@property (readonly) id value;

@end