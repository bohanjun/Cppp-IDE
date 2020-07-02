// ClangKit
 
#import <Cocoa/Cocoa.h>

@class CKDiagnostic;

/*!
 * @class           CKFixIt
 * @abstract        Fix-it class
 */
@interface CKFixIt: NSObject
{
@protected
    
    NSString * _string;
    NSRange    _range;
}

/*!
 * @property        string
 * @abstract        The fix-it's string
 */
@property( atomic, readonly ) NSString * string;

/*!
 * @property        range
 * @abstract        The fix-it's range
 */
@property( atomic, readonly ) NSRange range;

/*!
 * @method          fixItsForDiagnostic:
 * @abstract        Gets fix-it objects from a diagnostic object
 * @param           diagnostic  The diagnostic object
 * @return          An array of fix-it objects
 */
+ ( NSArray * )fixItsForDiagnostic: ( CKDiagnostic * )diagnostic;

/*!
 * @method          fixItWithDiagnostic:index:
 * @abstract        Gets a fix-it object from a diagnostic object
 * @param           diagnostic  The diagnostic object
 * @param           index       The index
 * @return          The fix-it object
 * @discussion      The returned object is autoreleased.
 */
+ ( id )fixItWithDiagnostic: ( CKDiagnostic * )diagnostic index: ( NSUInteger )index;

/*!
 * @method          initWithDiagnostic:index:
 * @abstract        Initializes a fix-it object with a diagnostic object
 * @param           diagnostic  The diagnostic object
 * @param           index       The index
 * @return          The fix-it object
 */
- ( id )initWithDiagnostic: ( CKDiagnostic * )diagnostic index: ( NSUInteger )index;
    
@end
