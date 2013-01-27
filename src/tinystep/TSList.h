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
#import <tinystep/TSConfig.h>
#import <tinystep/TSComparator.h>
#import <tinystep/TSIterator.h>

@protocol TSListIterator <TSIterator>

-(BOOL) hasPrevious;
-(id) previous;

@end

@protocol TSList

/*
 * returns the number of objects in the list
 */
-(unsigned int) size;

/*
 * removes all objects in the list
 */
-(void) clear;

/*
 * adds a new item at the end of the list
 */
-(void) add:(id) obj;

/*
 * inserts the item at the specified position. Shifts
 * the items currently at that position (if any) and any
 * subsequent items to the right (adds one to their indices).
 */
-(void) add:(id) obj index:(unsigned int) index;

/*
 * removes the item at index and returns
 */
-(id) remove:(unsigned int) index;

/*
 * Replaces the item at the specified position in this
 * list with the specified element
 */
-(id) set:(unsigned int) index obj:(id)obj;

/*
 * Returns the item at the specified position.
 */
-(id) getAt:(unsigned int) index;

/*
 * Returns an iterator for this list
 */
-(id<TSListIterator>) iterator;


@end

TSEXPORT void
TSListSwap(id<TSList> list, int a, int b);

TSEXPORT void
TSListSort(id<TSList> list, id<TSComparator> comparator);

TSEXPORT void
TSListShuffle(id<TSList> list);
