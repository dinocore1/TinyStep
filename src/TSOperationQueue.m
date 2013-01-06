#import <tinystep/TSOperationQueue.h>
#import <tinystep/TSAutoreleasePool.h>
#import <tinystep/TSThread.h>

@interface FutureImp : TSObject<Future> {
@public
	id<Runnable> _runnable;
	id _retval;
	BOOL _isDone;
}

@end

@implementation FutureImp

-(id) initWithRunnable:(id<Runnable>)aRunnable
{
	self = [super init];
	if(self) {
		_runnable = RETAIN(aRunnable);
		_isDone = NO;
	}
	return self;
}

-(void) dealloc
{
	RELEASE(_runnable);
	RELEASE(_retval);
	[super dealloc];
}

-(id) get
{
	return _retval;
}

-(BOOL) isDone
{
	return _isDone;
}

@end

#define IDLE 0
#define RUNNING 1
#define STOPPING 2

@implementation TSOperationQueue

-(id) init
{
	self = [super init];
	if(self) {
		_queue = [TSLinkedList new];
		_lock = [TSLock new];
		_maxConcurrent = 1;
		_workerThreads = [[TSArrayList alloc] initWithCapacity:_maxConcurrent];
		_status = IDLE;
	}
	return self;
}

-(id<Future>) post:(id<Runnable>)task
{
	FutureImp* retval = nil;
	[_lock lock];
	if(_status != STOPPING){
		retval = [[FutureImp alloc] initWithRunnable:task];
		[_queue enqueue:retval];
		[_lock signalAll];
	}
	[_lock unlock];

	return retval;
}

-(void) start
{
	[_lock lock];
	_status = RUNNING;
	[_lock unlock];
	int i;
	for(i=0;i<_maxConcurrent;i++){
		TSThread* t = [[TSThread alloc] initWithTarget:self
							selector:@selector(runWorker)
							object:nil];
		[_workerThreads add:t];
		[t start];
	}
}

-(void) stop
{
	[_lock lock];
	_status = STOPPING;
	[_lock unlock];

	aliterator it;
	TSThread* t = nil;
	[_workerThreads iterator:&it];
	while([_workerThreads next:&it obj:&t]){
		[t join];
	}

}

-(int) getStatus
{
	int retval;
	[_lock lock];
	retval = _status;
	[_lock unlock];
	return retval;
}

-(void) runWorker
{
	while([self getStatus] == RUNNING) {

		[_lock lock];
		while(_queue.size == 0) {
			[_lock wait];
		}

		TSAutoreleasePool* pool = [TSAutoreleasePool new];
		FutureImp* future = [_queue dequeue];
		[_lock unlock];

		
		future->_retval = [future->_runnable run];
		

		RETAIN(future->_retval);
		future->_isDone = YES;

		[pool release];
	}
}

@end