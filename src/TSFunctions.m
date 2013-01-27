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


#import <tinystep/TinyStep.h>


int
TSQuickSortPartition(id<TSList> list, id<TSComparator> comparator, int left, int right, int pivot)
{
	int i;
	id pivotValue = [list getAt:pivot];
	TSListSwap(list, pivot, right);
	int storeIndex = left;
	for(i=left;i<right;i++){
		if([comparator compareObj:[list getAt:i] to:pivotValue] < 0) {
			TSListSwap(list, i, storeIndex);
			storeIndex++;
		}
	}
	TSListSwap(list, storeIndex, right);
	return storeIndex;
}

void
TSQuickSort(id<TSList> list, id<TSComparator> comparator, int left, int right)
{
	//if the list has 2 or more items
	if(left < right){
		int pivot = ((right-left)/2)+left;
		pivot = TSQuickSortPartition(list, comparator, left, right, pivot);
		TSQuickSort(list, comparator, left, pivot-1);
		TSQuickSort(list, comparator, pivot+1, right);
	}
}

void
TSListSwap(id<TSList> list, int a, int b)
{
	id temp = [list getAt:a];
	[list set:a obj:[list getAt:b]];
	[list set:b obj:temp];
}

void
TSListSort(id<TSList> list, id<TSComparator> comparator)
{
	TSQuickSort(list, comparator, 0, [list size]-1);
}

void
TSListShuffle(id<TSList> list)
{
	int i;
	for(i=[list size]; i>1;i--){
		TSListSwap(list, i-1, rand()%i);
	}
}

#if defined(BUILD_DEBUG)

static char TSDEBUG_printobjbuf[1024];

static const char*
_NSPrintForDebugger(id object)
{
	if (object) {
		TSAutoreleasePool* pool = [TSAutoreleasePool new];
		TSString* str = [object toString];
		const char* cstr = [str cString];
		strncpy(TSDEBUG_printobjbuf, cstr, 1024);
		[pool release];
    	return TSDEBUG_printobjbuf;
	}
	return NULL;
}

#endif