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


#import <tinystep/TSCondition.h>
#import <tinystep/TSTime.h>

@implementation TSCondition

-(id) init
{
	self = [super init];
	if(self){
#ifdef THREAD_SUPPORT
		pthread_cond_init (&_condition, NULL);
#endif
	}
	return self;
}

-(void) dealloc
{
#ifdef THREAD_SUPPORT 
	pthread_cond_destroy(&_condition);
#endif
	[super dealloc];
}

-(void) wait
{
#ifdef THREAD_SUPPORT
	pthread_cond_wait(&_condition, &_mutex);
#endif
}

-(void) waitFor:(double) seconds
{
#ifdef THREAD_SUPPORT
    struct timespec time = TSDoubleToTimeSpec(seconds);
    pthread_cond_timedwait(&_condition, &_mutex, &time);
#endif
}

-(void) signal
{
#ifdef THREAD_SUPPORT
	pthread_cond_signal(&_condition);
#endif
}

-(void) signalAll
{
#ifdef THREAD_SUPPORT
	pthread_cond_broadcast(&_condition);
#endif
}

@end