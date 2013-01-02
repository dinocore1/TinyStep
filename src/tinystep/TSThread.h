
#import <tinystep/TSObject.h>
#import <tinystep/TSAutoreleasePool.h>

typedef struct autorelease_thread_vars
{
  /* The current, default NSAutoreleasePool for the calling thread;
     the one that will hold objects that are arguments to
     [NSAutoreleasePool +addObject:]. */
  __unsafe_unretained TSAutoreleasePool *current_pool;

} thread_vars_struct;

@interface TSThread : TSObject {

#ifdef THREAD_SUPPORT
	pthread_t _thread_obj;
#endif

	id _target;
	SEL _selector;
	id _argument;

@public
	thread_vars_struct _autorelease_thread_vars;

}

+(TSThread*) currentThread;

-(id) initWithTarget:(id)aTarget 
			selector:(SEL)aSelector
			object:(id) anArgument; 

#ifdef THREAD_SUPPORT
-(void)start;
-(void)join;
#endif

@end

TSEXPORT TSThread*
TSCurrentThread();