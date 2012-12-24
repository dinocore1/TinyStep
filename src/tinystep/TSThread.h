
#import <tinystep/TSObject>

@interface TSThread : TSObject {

#ifdef THREAD_SUPPORT
	pthread_t thread_obj;
#endif

	id _target;
	SEL _selector;
	id _argument;

}

+(TSThread*) currentThread;

-(id) initWithTarget:(id)aTarget 
			selector:(SEL)aSelector
			object:(id) anArgument; 

-(void)start;

@end