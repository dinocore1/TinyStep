
#import <tinystep/TSLinkedList.h>

@interface TSLinkedListNode : TSObject {
	TSLinkedListNode* _prev;
	TSLinkedListNode* _next;
	id _data;
}

@end

@implementation TSLinkedList

-(id) init
{
	self = [super init];
	if(self) {
		
	}
	return self;
}

-(unsigned int) size
{
	return _size;
}

-(void)add:(id) obj
{
	TSLinkedListNode* node = [[TSLinkedListNode alloc] init];
}

@end