// ClangKit
 
#import <Cocoa/Cocoa.h>
#import "../clang-c/Index.h"
#import "CKTranslationUnit.h"

/*!
 * @typedef         CKTokenKind
 * @abstract        Token kind
 */
typedef NSInteger CKTokenKind;

/*!
 * @var             CKTokenKindPunctuation
 * @abstract        Token kind - Punctuation
 */
FOUNDATION_EXPORT CKTokenKind CKTokenKindPunctuation;

/*!
 * @var             CKTokenKindKeyword
 * @abstract        Token kind - Keyword
 */
FOUNDATION_EXPORT CKTokenKind CKTokenKindKeyword;

/*!
 * @var             CKTokenKindIdentifier
 * @abstract        Token kind - Identifier
 */
FOUNDATION_EXPORT CKTokenKind CKTokenKindIdentifier;

/*!
 * @var             CKTokenKindLiteral
 * @abstract        Token kind - Literal
 */
FOUNDATION_EXPORT CKTokenKind CKTokenKindLiteral;

/*!
 * @var             CKTokenKindComment
 * @abstract        Token kind - Comment
 */
FOUNDATION_EXPORT CKTokenKind CKTokenKindComment;

@class CKTranslationUnit;
@class CKCursor;
@class CKSourceLocation;

/*!
 * @class           CKToken
 * @abstract        Token class
 */
@interface CKToken: NSObject
{
@protected
    
    NSString         * _spelling;
    CKTokenKind        _kind;
    NSUInteger         _line;
    NSUInteger         _column;
    NSRange            _range;
    CKCursor         * _cursor;
    CKSourceLocation * _sourceLocation;
}

/*!
 * @property        spelling
 * @abstract        The token's spelling
 */
@property( atomic, readonly ) NSString * spelling;

/*!
 * @property        kind
 * @abstract        The token kind
 */
@property( atomic, readonly ) CKTokenKind kind;

/*!
 * @property        line
 * @abstract        The line number for the token
 */
@property( atomic, readonly ) NSUInteger line;

/*!
 * @property        column
 * @abstract        The column number for the token
 */
@property( atomic, readonly ) NSUInteger column;

/*!
 * @property        range
 * @abstract        The token's range
 */
@property( atomic, readonly ) NSRange range;

/*!
 * @property        cursor
 * @abstract        The token's cursor
 */
@property( atomic, readonly ) CKCursor * cursor;

/*!
 * @property        sourceLocation
 * @abstract        The source location of the token
 */
@property( atomic, readonly ) CKSourceLocation * sourceLocation;

/*!
 * @method          tokensForTranslationUnit:tokens:
 * @abstract        Gets a list of token objects from a translation unit
 * @param           translationUnit     The translation unit
 * @param           tokensPointer       Optional - Used to retrieve the internal libclang tokens
 * @return          An array of token objects
 */
+ ( NSArray * )tokensForTranslationUnit: ( CKTranslationUnit * )translationUnit tokens: ( void ** )tokensPointer;

@end
