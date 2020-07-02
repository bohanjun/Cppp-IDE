// ClangKit

#import <Cocoa/Cocoa.h>
#import "../clang-c/Index.h"

/*!
 * @class           CKSourceLocation
 * @abstract        Source location class
 */
@interface CKSourceLocation: NSObject
{
@protected
    
    const void * _ptrData1;
    const void * _ptrData2;
    unsigned int _intData;
    NSString   * _fileName;
}

/*!
 * @property        ptrData1
 * @abstract        Internal pointer data 1
 */
@property( atomic, readonly ) const void * ptrData1;

/*!
 * @property        ptrData2
 * @abstract        Internal pointer data 1
 */
@property( atomic, readonly ) const void * ptrData2;

/*!
 * @property        intData
 * @abstract        Internal integer data
 */
@property( atomic, readonly ) unsigned int intData;

/*!
 * @property        fileName
 * @abstract        The source location's filename
 */
@property( atomic, readonly ) NSString * fileName;

/*!
 * @method          sourceLocationWithPointerData1:pointerData2:intData:
 * @abstract        Gets a source location object
 * @param           ptrData1    Pointer data 1
 * @param           ptrData2    Pointer data 2
 * @param           intData     Integer data
 * @return          The source location object
 * @discussion      The returned object is autoreleased.
 */
+ ( id )sourceLocationWithPointerData1: ( const void * )ptrData1 pointerData2: ( const void * )ptrData2 intData: ( unsigned int )intData;

/*!
 * @method          initWithPointerData1:pointerData2:intData:
 * @abstract        Initializes a source location object
 * @param           ptrData1    Pointer data 1
 * @param           ptrData2    Pointer data 2
 * @param           intData     Integer data
 * @return          The source location object
 */
- ( id )initWithPointerData1: ( const void * )ptrData1 pointerData2: ( const void * )ptrData2 intData: ( unsigned int )intData;

@end
