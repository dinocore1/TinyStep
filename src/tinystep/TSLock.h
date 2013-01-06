#import <tinystep/TSObject.h>

@interface TSLock : TSObject {

#ifdef THREAD_SUPPORT
	pthread_mutex_t _mutex;
#endif
	
}

-(void) lock;
-(void) unlock;

@end