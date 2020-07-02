// ClangKit
 


#import "CKCompletionChunk.h"

CKCompletionChunkKind CKCompletionChunkKindOptional         = CXCompletionChunk_Optional;
CKCompletionChunkKind CKCompletionChunkKindTypedText        = CXCompletionChunk_TypedText;
CKCompletionChunkKind CKCompletionChunkKindText             = CXCompletionChunk_Text;
CKCompletionChunkKind CKCompletionChunkKindPlaceholder      = CXCompletionChunk_Placeholder;
CKCompletionChunkKind CKCompletionChunkKindInformative      = CXCompletionChunk_Informative;
CKCompletionChunkKind CKCompletionChunkKindCurrentParameter = CXCompletionChunk_CurrentParameter;
CKCompletionChunkKind CKCompletionChunkKindLeftParen        = CXCompletionChunk_LeftParen;
CKCompletionChunkKind CKCompletionChunkKindRightParen       = CXCompletionChunk_RightParen;
CKCompletionChunkKind CKCompletionChunkKindLeftBracket      = CXCompletionChunk_LeftBracket;
CKCompletionChunkKind CKCompletionChunkKindRightBracket     = CXCompletionChunk_RightBracket;
CKCompletionChunkKind CKCompletionChunkKindLeftBrace        = CXCompletionChunk_LeftBrace;
CKCompletionChunkKind CKCompletionChunkKindRightBrace       = CXCompletionChunk_RightBrace;
CKCompletionChunkKind CKCompletionChunkKindLeftAngle        = CXCompletionChunk_LeftAngle;
CKCompletionChunkKind CKCompletionChunkKindRightAngle       = CXCompletionChunk_RightAngle;
CKCompletionChunkKind CKCompletionChunkKindComma            = CXCompletionChunk_Comma;
CKCompletionChunkKind CKCompletionChunkKindResultType       = CXCompletionChunk_ResultType;
CKCompletionChunkKind CKCompletionChunkKindColon            = CXCompletionChunk_Colon;
CKCompletionChunkKind CKCompletionChunkKindSemiColon        = CXCompletionChunk_SemiColon;
CKCompletionChunkKind CKCompletionChunkKindEqual            = CXCompletionChunk_Equal;
CKCompletionChunkKind CKCompletionChunkKindHorizontalSpace  = CXCompletionChunk_HorizontalSpace;
CKCompletionChunkKind CKCompletionChunkKindVerticalSpace    = CXCompletionChunk_VerticalSpace;

@implementation CKCompletionChunk

@synthesize text = _text;
@synthesize kind = _kind;

+ ( id )completionChunkWithCXCompletionString: ( CXCompletionString )string chunkNumber: ( NSUInteger )chunkNumber
{
    return [ [ [ self alloc ] initWithCXCompletionString: string chunkNumber: chunkNumber ] autorelease ];
}

- ( id )initWithCXCompletionString: ( CXCompletionString )string chunkNumber: ( NSUInteger )chunkNumber
{
    CXString text;
    
    if( ( self = [ self init ] ) )
    {
        _kind = clang_getCompletionChunkKind( string, ( unsigned int )chunkNumber );
        text  = clang_getCompletionChunkText( string, ( unsigned int )chunkNumber );
        _text = [ [ NSString alloc ] initWithCString: clang_getCString( text ) encoding: NSUTF8StringEncoding ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ _text release ];
    
    [ super dealloc ];
}

- ( NSString * )description
{
    NSString * kind;
    
    if( _kind == CKCompletionChunkKindOptional )
    {
        kind = @"Optional";
    }
    else if( _kind == CKCompletionChunkKindTypedText )
    {
        kind = @"Typed text";
    }
    else if( _kind == CKCompletionChunkKindText )
    {
        kind = @"Text";
    }
    else if( _kind == CKCompletionChunkKindPlaceholder )
    {
        kind = @"Placeholder";
    }
    else if( _kind == CKCompletionChunkKindInformative )
    {
        kind = @"Informative";
    }
    else if( _kind == CKCompletionChunkKindCurrentParameter )
    {
        kind = @"Parameter";
    }
    else if( _kind == CKCompletionChunkKindLeftParen )
    {
        kind = @"Left parenthesis";
    }
    else if( _kind == CKCompletionChunkKindRightParen )
    {
        kind = @"Right parenthesis";
    }
    else if( _kind == CKCompletionChunkKindLeftBracket )
    {
        kind = @"Left bracket";
    }
    else if( _kind == CKCompletionChunkKindRightBracket )
    {
        kind = @"Right bracket";
    }
    else if( _kind == CKCompletionChunkKindLeftBrace )
    {
        kind = @"Left brace";
    }
    else if( _kind == CKCompletionChunkKindRightBrace )
    {
        kind = @"Right brace";
    }
    else if( _kind == CKCompletionChunkKindLeftAngle )
    {
        kind = @"Left angle";
    }
    else if( _kind == CKCompletionChunkKindRightAngle )
    {
        kind = @"Right angle";
    }
    else if( _kind == CKCompletionChunkKindComma )
    {
        kind = @"Comma";
    }
    else if( _kind == CKCompletionChunkKindResultType )
    {
        kind = @"Result type";
    }
    else if( _kind == CKCompletionChunkKindColon )
    {
        kind = @"Colon";
    }
    else if( _kind == CKCompletionChunkKindSemiColon )
    {
        kind = @"Semi colon";
    }
    else if( _kind == CKCompletionChunkKindEqual )
    {
        kind = @"Equal";
    }
    else if( _kind == CKCompletionChunkKindHorizontalSpace )
    {
        kind = @"Horizontal space";
    }
    else if( _kind == CKCompletionChunkKindVerticalSpace )
    {
        kind = @"Vertical space";
    }
    else
    {
        kind = @"N/A";
    }
    
    return [ NSString stringWithFormat: @"%@: %@ - %@", [self className], kind, _text ];
}

@end
