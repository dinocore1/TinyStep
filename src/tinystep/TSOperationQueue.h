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
#import <tinystep/TSLinkedList.h>
#import <tinystep/TSArrayList.h>

@protocol Runnable <TSObject>
-(id)run;
@end

@protocol Future <TSObject>
-(id) get;
-(BOOL) isDone;
@end

@interface TSOperationQueue : TSObject {
	TSLinkedList* _queue;
	TSCondition* _lock;
	int _maxConcurrent;
	TSArrayList* _workerThreads;
	int _status;
}

-(id<Future>) post:(id<Runnable>) task;

-(void) setMaxConcurrent:(int) maxConcurrent;

-(void) start;
-(void) stop;

@end