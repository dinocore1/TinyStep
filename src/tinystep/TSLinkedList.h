
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

@end
