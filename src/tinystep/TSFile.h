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


#import <tinystep/TSString.h>

#include <stdio.h>

@interface TSFile : TSObject {
	TSString* _pathname;
}

-(id) initWithFile:(TSFile*) parent path:(TSString*)child;
-(id) initWithPath:(TSString*) pathname;

-(BOOL) exists;
-(BOOL) isDirectory;
-(BOOL) isFile;
-(TSString*) absolutePath;

@end

@interface TSRandomAccessFile : TSObject {
	TSFile* _file;
	FILE* _filehandle;
}

-(id) initWithFile:(TSFile*) file mode:(const char*)mode;

-(size_t) read:(uint8_t*) buf len:(size_t)len;
-(size_t) write:(uint8_t*) buf len:(size_t)len;
-(BOOL) seek:(long int) offset origin:(int) origin;

@end