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
#import <tinystep/TSList.h>

@interface TSLinkedList : TSObject<TSList>{
	struct TSLinkedListNode* _start;
	struct TSLinkedListNode* _end;
	unsigned int _size;
}


/**
add an item to the end of the list
*/
-(void) enqueue:(id) obj;

/**
removes the first item from the begining of the list
@returns the item at the begining of the list
*/
-(id) dequeue;


@end
