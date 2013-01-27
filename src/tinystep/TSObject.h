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


#import <objc/runtime.h>
#import <tinystep/TSConfig.h>

#ifdef BUILD_DEBUG
long 
TSGetNumLiveObjects();
#endif

@class TSString;
@protocol TSObject 
-(id)retain;
-(void)release;
-(id)autorelease;
-(int)retainCount;
@end

@interface TSObject <TSObject> {
	Class isa;
}


+(Class)class;
+(Class)superclass;
+alloc;
+(id)new;

-self;
-(Class)class;
-(Class)superclass;
-(id)init;
-(void)dealloc;


-(TSString*) className;
-(IMP)methodForSelector:(SEL)aSelector;
-(BOOL)respondsToSelector:(SEL)aSelector;

-(unsigned int) hash;
-(BOOL) isEqual:(id) obj;
-(TSString*) toString;

@end

