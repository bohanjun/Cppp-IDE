// ClangKit

#import "CKCursor.h"
#import "../clang-c/Index.h"
#import <Cocoa/Cocoa.h>

/*!
 * @class           CKCompletionResult
 * @abstract        Completion result class
 */
@interface CKCompletionResult: NSObject
{
@protected
    
    CXCompletionString _string;
    CKCursorKind       _cursorKind;
    NSArray          * _chunks;
}

/*!
 * @property        text
 * @abstract        The completion result's text
 */
@property( atomic, readonly ) CXCompletionString * string;

/*!
 * @property        cursorKind
 * @abstract        The completion result's cursor kind
 */
@property( atomic, readonly ) CKCursorKind cursorKind;

/*!
 * @property        chunks
 * @abstract        The completion chunks (an array of CKCompletionChunk objects)
 */
@property( atomic, readonly ) NSArray * chunks;

/*!
 * @method          completionResultWithCXCompletionString:cursorKind:
 * @abstract        Gets a completion result from a completion string
 * @param           string      The completion string
 * @param           cursorKind  The cursor kind
 * @return          The completion result object
 * @discussion      The returned object is autoreleased.
 */
+ ( id )completionResultWithCXCompletionString: ( CXCompletionString )string cursorKind: ( CKCursorKind )cursorKind;

/*!
 * @method          initWithCXCompletionString:
 * @abstract        Initializes a completion result from a completion string
 * @param           string      The completion string
 * @param           cursorKind  The cursor kind
 * @return          The completion result object
 */
- ( id )initWithCXCompletionString: ( CXCompletionString )string cursorKind: ( CKCursorKind )cursorKind;

@end
