#import <tinystep/TSList.h>



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

#ifdef BUILD_DEBUG

const char *_NSPrintForDebugger(id object)
{
  /* This is not really what _NSPrintForDebugger should do, but it
     is a simple test if gdb can call this function */
	if (object && [object respondsToSelector:@selector(toString)]) {
    	return [[object toString] cString];
	}

  return NULL;
}

#endif