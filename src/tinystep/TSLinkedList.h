
#import <tinystep/TSObject.h>
#import <tinystep/TSList.h>



typedef struct lliterator
{
	struct TSLinkedListNode* node;
} lliterator;

@interface TSLinkedList : TSObject<TSList>{
	struct TSLinkedListNode* _start;
	struct TSLinkedListNode* _end;
	unsigned int _size;
}

-(void) iterator:(lliterator*) it;
-(BOOL) next:(lliterator*) it obj:(id*)objptr;


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
