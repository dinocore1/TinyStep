
#import <tinystep/TSObject.h>
#import <tinystep/TSList.h>

struct TSLinkedListNode;
@interface TSLinkedList : TSObject<TSList>{
	struct TSLinkedListNode* _start;
	struct TSLinkedListNode* _end;
	unsigned int _size;
}



@end
