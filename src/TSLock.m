#import <tinystep/TSLock.h>

@implementation TSLock

-(id) init
{
	self = [super init];
	if(self){
#ifdef THREAD_SUPPORT 
		pthread_mutexattr_t mta;
		pthread_mutexattr_init(&mta);
		pthread_mutexattr_settype(&mta, PTHREAD_MUTEX_RECURSIVE);

		pthread_mutex_init(&_mutex, NULL);
		pthread_mutexattr_destroy(&mta);
#endif
	}
	return self;
}

-(void) dealloc
{
#ifdef THREAD_SUPPORT 
	pthread_mutex_destroy(&_mutex);
#endif
	[super dealloc];
}

-(void) lock
{
#ifdef THREAD_SUPPORT 
	pthread_mutex_lock(&_mutex);
#endif
}

-(void) unlock
{
#ifdef THREAD_SUPPORT 
	pthread_mutex_unlock(&_mutex);
#endif
}

@end