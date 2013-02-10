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
#import <tinystep/TSTime.h>


@interface FutureImp : TSObject<Future> {
@public
	id<Runnable> _runnable;
	id _retval;
	BOOL _isDone;
	double _runat;
}

@end

@implementation FutureImp

-(id) initWithRunnable:(id<Runnable>)aRunnable runat:(double)runat;
{
	self = [super init];
	if(self) {
		_runnable = RETAIN(aRunnable);
		_isDone = NO;
		_runat = runat;
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

@interface ClockTimeComparator : TSObject<TSComparator> {
}

@end

@implementation ClockTimeComparator

-(int) compareObj:(id)a to:(id)b
{
	FutureImp* fa = (FutureImp*)a;
	FutureImp* fb = (FutureImp*)b;

	double at = fa->_runat;
	double bt = fb->_runat;

	double diff = at-bt;
	int retval = 0;
	if(diff > 0.0){
		retval = 1;
	} else if(diff < 0.0) {
		retval = -1;
	}

	return retval;
}

@end

#define IDLE 0
#define RUNNING 1
#define STOPPING 2

@implementation TSOperationQueue


static ClockTimeComparator* sClickTimeCompare;

+(void)initialize
{
	sClickTimeCompare = [ClockTimeComparator new];
}

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
	return [self postWithDelay:task delay:0.0];
}

-(id<Future>) postWithDelay:(id<Runnable>) task delay:(double)secdelay
{
	FutureImp* retval = nil;
	[_lock lock];
	if(_status != STOPPING){
		struct timespec nowtime;
		clock_gettime(CLOCK_MONOTONIC, &nowtime);
		double runat = TSTimeSpecToDouble(nowtime) + secdelay;
		retval = [[FutureImp alloc] initWithRunnable:task runat:runat];
		[_queue enqueue:retval];
		TSListSort(_queue, sClickTimeCompare);
		[_lock signalAll];
	}
	[_lock unlock];

	return [retval autorelease];
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
			retval = [_queue getAt:0];
			struct timespec nowtime;
			clock_gettime(CLOCK_MONOTONIC, &nowtime);
			double nowtimed = TSTimeSpecToDouble(nowtime);

			if(retval->_runat > nowtimed){
				[_lock waitFor:retval->_runat-nowtimed];
			} else {
				[_queue dequeue];
				break;
			}
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