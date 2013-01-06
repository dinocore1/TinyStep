#import <tinystep/TSLock.h>

@interface TSCondition : TSLock {
#ifdef THREAD_SUPPORT
	pthread_cond_t _condition;
#endif
}

-(void) wait;
-(void) signal;
-(void) signalAll;

@end