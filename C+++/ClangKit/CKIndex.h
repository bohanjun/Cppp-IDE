// ClangKit
 
#import <Cocoa/Cocoa.h>
#import "../clang-c/Index.h"

/*!
 * @class           CKIndex
 * @abstract        Index class
 */
@interface CKIndex: NSObject
{
@protected
    
    CXIndex _cxIndex;
    BOOL    _excludeDeclarationsFromPCH;
    BOOL    _displayDiagnostics;
}

/*!
 * @property        cxIndex
 * @abstract        Internal libclang index object
 */
@property( atomic, readonly ) CXIndex cxIndex;

/*!
 * @property        excludeDeclarationsFromPCH
 * @abstract        Whether to exclude declarations from the PCH file or not
 */
@property( atomic, readwrite, assign ) BOOL excludeDeclarationsFromPCH;

/*!
 * @property        displayDiagnostics
 * @abstract        Whether to display diagnostics or not
 */
@property( atomic, readwrite, assign ) BOOL displayDiagnostics;

/*!
 * @method          index
 * @abstract        Gets an index object
 * @return          The index object
 * @discussion      The returned object is autoreleased.
 */
+ ( id )index;

@end
