
#import <tinystep/TSObject.h>

@interface TSString : TSObject {
  void* _buf;
  int _capacity;
}

- (id) initWithCString:(const char*)str;
- (const char*) cString;

@end

