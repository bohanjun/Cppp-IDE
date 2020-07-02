// ClangKit
 


#import "CKToken.h"
#import "CKToken+Private.h"
#import "CKTranslationUnit.h"
#import "CKCursor.h"

CKTokenKind CKTokenKindPunctuation  = CXToken_Punctuation;
CKTokenKind CKTokenKindKeyword      = CXToken_Keyword;
CKTokenKind CKTokenKindIdentifier   = CXToken_Identifier;
CKTokenKind CKTokenKindLiteral      = CXToken_Literal;
CKTokenKind CKTokenKindComment      = CXToken_Comment;

@implementation CKToken

@synthesize spelling        = _spelling;
@synthesize kind            = _kind;
@synthesize line            = _line;
@synthesize column          = _column;
@synthesize range           = _range;
@synthesize cursor          = _cursor;
@synthesize sourceLocation  = _sourceLocation;

+ ( NSArray * )tokensForTranslationUnit: ( CKTranslationUnit * )translationUnit tokens: ( void ** )tokensPointer
{
    CXToken        * cxTokens;
    NSMutableArray * tokens;
    CXFile           file;
    CXSourceLocation startLocation;
    CXSourceLocation endLocation;
    CXSourceRange    range;
    unsigned int     numTokens;
    unsigned int     i;
    CKToken        * token;
    
    ( void )translationUnit;
    
    file            = clang_getFile( translationUnit.cxTranslationUnit, translationUnit.path.fileSystemRepresentation );
    startLocation   = clang_getLocationForOffset( translationUnit.cxTranslationUnit, file, 0 );
    endLocation     = clang_getLocationForOffset( translationUnit.cxTranslationUnit, file, ( unsigned int )translationUnit.text.length );
    range           = clang_getRange( startLocation, endLocation );
    numTokens       = 0;
    cxTokens        = NULL;
    
    clang_tokenize
    (
        translationUnit.cxTranslationUnit,
        range,
        &cxTokens,
        &numTokens
    );
    
    if( numTokens == 0 )
    {
        return nil;
    }
    
    clang_annotateTokens( translationUnit.cxTranslationUnit, cxTokens, numTokens, NULL );
    
    tokens = [ NSMutableArray arrayWithCapacity: ( NSUInteger )numTokens ];
    
    for( i = 0; i < numTokens; i++ )
    {
        token = [ [ CKToken alloc ] initWithCXToken: cxTokens[ i ] translationUnit: translationUnit ];
        
        if( token != nil )
        {
            [ tokens addObject: token ];
            [ token release ];
        }
    }
    
    if( tokensPointer != NULL )
    {
        *( tokensPointer ) = ( char * )cxTokens;
    }
    
    return [ NSArray arrayWithArray: tokens ];
}

- ( void )dealloc
{
    [ _spelling         release ];
    [ _cursor           release ];
    [ _sourceLocation   release ];
    
    [ super dealloc ];
}

- ( NSString * )description
{
    NSString * description;
    NSString * kind;
    
    if( self.kind == CKTokenKindPunctuation )
    {
        kind = @"Punctuation";
    }
    else if( self.kind == CKTokenKindKeyword )
    {
        kind = @"Keyword";
    }
    else if( self.kind == CKTokenKindIdentifier )
    {
        kind = @"Identifier";
    }
    else if( self.kind == CKTokenKindLiteral )
    {
        kind = @"Literal";
    }
    else if( self.kind == CKTokenKindComment )
    {
        kind = @"Comment";
    }
    else
    {
        kind = @"Unknown";
    }
    
    description = [ super description ];
    description = [ description stringByAppendingFormat: @": %@[%lu:%lu] %@ (%@)",
                                                         kind,
                                                         ( unsigned long )( self.line ),
                                                         ( unsigned long )( self.column ),
                                                         self.spelling,
                                                         self.cursor.kindSpelling
                  ];
    
    return description;
}

@end
