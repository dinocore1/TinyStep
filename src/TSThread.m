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



#import <tinystep/TSThread.h>
#import <tinystep/TSAutoreleasePool.h>
#import <objc/runtime.h>


static TSThread* mainthread = nil;
#ifdef THREAD_SUPPORT
static pthread_key_t thread_object_key;
#endif


@implementation TSThread

+(void) initialize
{
	mainthread = [TSThread new];
#ifdef THREAD_SUPPORT
	pthread_key_create(&thread_object_key, NULL);
	pthread_setspecific(thread_object_key, mainthread);
#endif
	
}

-(id) init
{
	self = [super init];
	if(self){
		_target = nil;
		_argument = nil;
	}
	return self;
}

-(id) initWithTarget:(id)aTarget
			selector:(SEL)aSelector
			object:(id)anArgument
{
	self = [super init];
	if(self) {
		_target = RETAIN(aTarget);
		_selector = aSelector;
		_argument = RETAIN(anArgument);
	}

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
	TSThread* retval = nil;
#ifdef THREAD_SUPPORT
	retval = pthread_getspecific(thread_object_key);
#else
	retval = mainthread;
#endif
	return retval;
}

#ifdef THREAD_SUPPORT

void* TSThreadStart(void* obj)
{
	TSThread* threadobj = (TSThread*) obj;
	pthread_setspecific(thread_object_key, threadobj);
	OBJCSENDMESSAGE(obj, @selector(realstart), nil);
	pthread_exit(NULL);
}

-(void) realstart
{
	_autorelease_thread_vars.current_pool = NULL;
	TSAutoreleasePool* pool = [TSAutoreleasePool new];
	OBJCSENDMESSAGE(_target, _selector, _argument);
	[pool dealloc];
}

-(void) start
{
	pthread_attr_t attr;
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
	pthread_create(&_thread_obj, &attr, TSThreadStart, self);
	pthread_attr_destroy(&attr);
}

-(void) join
{
	void* retobj = NULL;
	int rc = pthread_join(_thread_obj, &retobj);
}

#endif

@end
