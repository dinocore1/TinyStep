
#import <tinystep/TSThread.h>

@implementation TSThread


-(id) initWithTarget:(id)aTarget
			selector:(SEL)aSelector
			object:(id)anArgument
{
	_target = RETAIN(aTarget);
	_selector = aSelector;
	_argument= RETAIN(anArgument);

	return self;
}

-(void) dealloc
{
	RELEASE(_target);
	_selector = nil;
	RELEASE(_argument);

	[super dealloc];
}

@end