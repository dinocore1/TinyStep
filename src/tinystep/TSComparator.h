
@protocol TSComparator


/**
* Compares its two arguments for order. Returns a negative integer, zero, or a positive
 integer as the first argument is less than, equal to, or greater than the second.
*/
-(int) compareObj:(id) a to:(id)b;

@end