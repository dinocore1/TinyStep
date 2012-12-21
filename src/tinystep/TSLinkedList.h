
#import <tinystep/TSObject.h>
#import <tinystep/TSList.h>

@class TSLinkedListNode;
@interface TSLinkedList : TSObject<TSList>{
	TSLinkedListNode* _start;
	TSLinkedListNode* _end;
	unsigned int _size;
}



@end
