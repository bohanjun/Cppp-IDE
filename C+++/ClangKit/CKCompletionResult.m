// ClangKit
 


#import "CKCompletionResult.h"
#import "CKCompletionChunk.h"

@class CKTranslationUnit;

@implementation CKCompletionResult

@synthesize string      = _string;
@synthesize cursorKind  = _cursorKind;
@synthesize chunks      = _chunks;

+ ( id )completionResultWithCXCompletionString: ( CXCompletionString )string cursorKind: ( CKCursorKind )cursorKind
{
    return [ [ [ self alloc ] initWithCXCompletionString: string cursorKind: cursorKind ] autorelease ];
}

- ( id )initWithCXCompletionString: ( CXCompletionString )string cursorKind: ( CKCursorKind )cursorKind
{
    unsigned int        chunkCount;
    unsigned int        i;
    NSMutableArray    * chunks;
    CKCompletionChunk * chunk;
    
    if( ( self = [ self init ] ) )
    {
        _string     = string;
        _cursorKind = cursorKind;
        chunkCount  = clang_getNumCompletionChunks( string );
        chunks      = [ NSMutableArray arrayWithCapacity: ( NSUInteger )chunkCount ];
        
        for( i = 0; i < chunkCount; i++ )
        {
            chunk = [ CKCompletionChunk completionChunkWithCXCompletionString: string chunkNumber: ( NSUInteger )i ];
            
            if( chunk != nil )
            {
                [ chunks addObject: chunk ];
            }
        }
        
        _chunks = [ [ NSArray alloc ] initWithArray: chunks ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ _chunks  release ];
    
    [ super dealloc ];
}

@end
