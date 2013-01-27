/*
    Copyright 2013 Paul Soucy

    This file is part of TinyStep.

    TinyStep is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    TinyStep is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser Public License
    along with TinyStep.  If not, see <http://www.gnu.org/licenses/>.
*/


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
		_lock = [TSCondition new];
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
	[_lock signalAll];
	[_lock unlock];

	TSThread* t = nil;
	id<TSIterator> it = [_workerThreads iterator];
	while([it hasNext]){
		t = [it next];
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

-(FutureImp*) getNextTask
{
	FutureImp* retval = nil;
	[_lock lock];
	while(_status == RUNNING){
		if(_queue.size == 0){
			[_lock wait];
		} else {
			retval = [_queue dequeue];
			break;
		}
	}
	[_lock unlock];
	return retval;
}

-(void) runWorker
{
	TSAutoreleasePool* pool = [TSAutoreleasePool new];

	FutureImp* future = nil;
	while((future = [self getNextTask]) != nil) {

		future->_retval = [future->_runnable run];

		RETAIN(future->_retval);
		future->_isDone = YES;

		[pool emptyPool];
		
	}
	
	[pool release];
	
}

@end