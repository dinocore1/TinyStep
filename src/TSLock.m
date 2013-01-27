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


#import <tinystep/TSLock.h>

@implementation TSLock

-(id) init
{
	self = [super init];
	if(self){
#ifdef THREAD_SUPPORT 
		pthread_mutexattr_t mta;
		pthread_mutexattr_init(&mta);
		pthread_mutexattr_settype(&mta, PTHREAD_MUTEX_RECURSIVE);

		pthread_mutex_init(&_mutex, NULL);
		pthread_mutexattr_destroy(&mta);
#endif
	}
	return self;
}

-(void) dealloc
{
#ifdef THREAD_SUPPORT 
	pthread_mutex_destroy(&_mutex);
#endif
	[super dealloc];
}

-(void) lock
{
#ifdef THREAD_SUPPORT 
	pthread_mutex_lock(&_mutex);
#endif
}

-(void) unlock
{
#ifdef THREAD_SUPPORT 
	pthread_mutex_unlock(&_mutex);
#endif
}

@end