
#import <tinystep/TSThread.h>

static BOOL threads_setup = NO;

TSThread*
TSCurrentThread()
{
	TSThread* retval = nil;
#ifdef THREAD_SUPPORT
	static pthread_key_t thread_object_key;
	if(threads_setup == NO){
		pthread_key_create(&thread_object_key, NULL);
		threads_setup = YES;
	}

	retval = pthread_getspecific(thread_object_key);
	if(retval == NULL){
		retval = [[TSThread alloc] init];
		pthread_setspecific(thread_object_key, retval);
	}

#else
	if(threads_setup == NO){
		retval = [[TSThread alloc] init];
		static TSThread* mainthread = retval;
		threads_setup = YES;
	}

#endif

	return retval;
}


@implementation TSThread

-(id) init
{
	_target = nil;
	_argument = nil;
}

-(id) initWithTarget:(id)aTarget
			selector:(SEL)aSelector
			object:(id)anArgument
{
	_target = RETAIN(aTarget);
	_selector = aSelector;
	_argument = RETAIN(anArgument);

	return self;
}

-(void) dealloc
{
	RELEASE(_target);
	RELEASE(_argument);

	[super dealloc];
}

+(TSThread*)currentThread
{
	return TSCurrentThread();
}

#ifdef THREAD_SUPPORT
-(void) start
{

}
#endif

@end