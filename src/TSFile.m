#import <tinystep/TSFile.h>
#import <tinystep/TSConfig.h>

#if defined(HAVE_SYS_TYPES_H)
#import <sys/types.h>
#endif

#if defined(HAVE_SYS_STAT_H)
#import <sys/stat.h>
#endif

@implementation TSFile

-(id) initWithFile:(TSFile*) parent path:(TSString*)child
{
	self = [super init];
	if(self) {
		TSStringBuffer* buf = [TSStringBuffer new];
		[buf appendCString:[parent->_pathname cString]];
		[buf appendCString:PATH_SEPARATOR];
		[buf appendCString:child];
		_pathname = [buf toString];
		[buf release];
	}
	return self;
}

-(id) initWithPath:(TSString*) pathname
{
	self = [super init];
	if(self) {
		_pathname = [pathname retain];
	}
	return self;
}

-(void) dealloc
{
	[_pathname release];
	[super dealloc];
}

-(BOOL) exists
{
	struct stat sb;
	int retval = stat([_pathname cString], &sb);

	return retval == 0;
}

-(BOOL) isDirectory
{
	struct stat sb;
	stat([_pathname cString], &sb);

	int retval = S_ISDIR(sb.st_mode);
	return retval;
}

-(BOOL) isFile
{
	struct stat sb;
	stat([_pathname cString], &sb);

	int retval = S_ISREG(sb.st_mode);
	return retval;
}

@end