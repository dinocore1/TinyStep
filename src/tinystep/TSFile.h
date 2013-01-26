#import <tinystep/TSString.h>


@interface TSFile : TSObject {
	TSString* _pathname;
}

-(id) initWithFile:(TSFile*) parent path:(TSString*)child;
-(id) initWithPath:(TSString*) pathname;

-(BOOL) exists;
-(BOOL) isDirectory;
-(BOOL) isFile;

@end