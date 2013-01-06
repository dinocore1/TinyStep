#import <tinystep/TSCondition.h>

@implementation TSCondition

-(id) init
{
	self = [super init];
	if(self){
#ifdef THREAD_SUPPORT
		pthread_cond_init (&_condition, NULL);
#endif
	}
	return self;
}

-(void) dealloc
{
#ifdef THREAD_SUPPORT 
	pthread_cond_destroy(&_mutex);
#endif
	[super dealloc];
}

-(void) wait
{
#ifdef THREAD_SUPPORT
	pthread_cond_wait(&_condition, &_mutex);
#endif
}

-(void) signal
{
#ifdef THREAD_SUPPORT
	pthread_cond_signal(&_condition);
#endif
}

-(void) signalAll
{
#ifdef THREAD_SUPPORT
	pthread_cond_broadcast(&_condition);
#endif
}

@end