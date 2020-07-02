// ClangKit

#import <Cocoa/Cocoa.h>
#import "../clang-c/Index.h"
/*!
 * @typedef         CKCompletionChunkKind
 * @abstract        Completion chunk kind
 */
typedef NSUInteger CKCompletionChunkKind;

/*!
 * @var             CKCompletionChunkKindOptional
 * @abstract        Completion chunk kind - Optional
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindOptional;

/*!
 * @var             CKCompletionChunkKindTypedText
 * @abstract        Completion chunk kind - Typed text
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindTypedText;

/*!
 * @var             CKCompletionChunkKindText
 * @abstract        Completion chunk kind - Text
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindText;

/*!
 * @var             CKCompletionChunkKindPlaceholder
 * @abstract        Completion chunk kind - Placeholder
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindPlaceholder;

/*!
 * @var             CKCompletionChunkKindInformative
 * @abstract        Completion chunk kind - Informative
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindInformative;

/*!
 * @var             CKCompletionChunkKindCurrentParameter
 * @abstract        Completion chunk kind - Current parameter
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindCurrentParameter;

/*!
 * @var             CKCompletionChunkKindLeftParen
 * @abstract        Completion chunk kind - Left parenthesis
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindLeftParen;

/*!
 * @var             CKCompletionChunkKindRightParen
 * @abstract        Completion chunk kind - Right parenthesis
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindRightParen;

/*!
 * @var             CKCompletionChunkKindLeftBracket
 * @abstract        Completion chunk kind - Left bracket
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindLeftBracket;

/*!
 * @var             CKCompletionChunkKindRightBracket
 * @abstract        Completion chunk kind - Right bracket
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindRightBracket;

/*!
 * @var             CKCompletionChunkKindLeftBrace
 * @abstract        Completion chunk kind - Left brace
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindLeftBrace;

/*!
 * @var             CKCompletionChunkKindRightBrace
 * @abstract        Completion chunk kind - Right brace
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindRightBrace;

/*!
 * @var             CKCompletionChunkKindLeftAngle
 * @abstract        Completion chunk kind - Left angle
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindLeftAngle;

/*!
 * @var             CKCompletionChunkKindRightAngle
 * @abstract        Completion chunk kind - Right angle
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindRightAngle;

/*!
 * @var             CKCompletionChunkKindComma
 * @abstract        Completion chunk kind - Comma
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindComma;

/*!
 * @var             CKCompletionChunkKindResultType
 * @abstract        Completion chunk kind - Result type
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindResultType;

/*!
 * @var             CKCompletionChunkKindColon
 * @abstract        Completion chunk kind - Colon
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindColon;

/*!
 * @var             CKCompletionChunkKindSemiColon
 * @abstract        Completion chunk kind - Semi colon
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindSemiColon;

/*!
 * @var             CKCompletionChunkKindEqual
 * @abstract        Completion chunk kind - Equal
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindEqual;

/*!
 * @var             CKCompletionChunkKindHorizontalSpace
 * @abstract        Completion chunk kind - Horizontal space
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindHorizontalSpace;

/*!
 * @var             CKCompletionChunkKindVerticalSpace
 * @abstract        Completion chunk kind - Vertical space
 */
FOUNDATION_EXPORT CKCompletionChunkKind CKCompletionChunkKindVerticalSpace;

/*!
 * @class           CKCompletionChunk
 * @abstract        Completion chunk class
 */
@interface CKCompletionChunk: NSObject
{
@protected

    NSString            * _text;
    CKCompletionChunkKind _kind;
}

/*!
 * @property        text
 * @abstract        The completion chunk's text
 */
@property( atomic, readonly ) NSString * text;

/*!
 * @property        kind
 * @abstract        The completion chunk's kind
 */
@property( atomic, readonly ) CKCompletionChunkKind kind;

/*!
 * @method          completionChunkWithCXCompletionString:chunkNumber:
 * @abstract        Gets a completion chunk from a completion string
 * @param           string      The completion string
 * @param           chunkNumber The chunk number
 * @return          The completion chunk object
 * @discussion      The returned object is autoreleased.
 */
+ ( id )completionChunkWithCXCompletionString: ( CXCompletionString )string chunkNumber: ( NSUInteger )chunkNumber;

/*!
 * @method          initWithCXCompletionString:chunkNumber:
 * @abstract        Initializes a completion chunk from a completion string
 * @param           string      The completion string
 * @param           chunkNumber The chunk number
 * @return          The completion chunk object
 */
- ( id )initWithCXCompletionString: ( CXCompletionString )string chunkNumber: ( NSUInteger )chunkNumber;

@end
