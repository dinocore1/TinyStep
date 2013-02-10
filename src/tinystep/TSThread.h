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
+(void) sleep:(double) seconds;

-(id) initWithTarget:(id)aTarget 
			selector:(SEL)aSelector
			object:(id) anArgument; 

#ifdef THREAD_SUPPORT
-(void)start;
-(void)join;
#endif

@end

