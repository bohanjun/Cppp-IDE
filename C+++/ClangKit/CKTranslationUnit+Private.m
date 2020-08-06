// ClangKit
 


#import "CKTranslationUnit+Private.h"
#import "CKIndex.h"

@implementation CKTranslationUnit( Private )

- ( id )initWithPath: ( NSString * )path text: ( NSString * )text index: ( CKIndex * )index args: ( NSArray * )args
{
    NSUInteger i;
    id         arg;
    
    if( ( self = [ self init ] ) )
    {
		_lock  = [ NSLock new ];
        _path  = [ path copy ];
        _index = ( index == nil ) ? [ CKIndex new ] : [ index retain ];
        
        if( text == nil )
        {
            _text = [ [ NSString stringWithContentsOfFile: _path encoding: NSUTF8StringEncoding error: NULL ] retain ];
            
            if( _text.length == 0 )
            {
                [ self release ];
                
                return nil;
            }
        }
        else
        {
            _text        = [ text retain ];
            _unsavedFile = calloc( sizeof( struct CXUnsavedFile ), 1 );
            
            if( _unsavedFile == NULL )
            {
                [ self release ];
                
                return nil;
            }
            
            ( ( struct CXUnsavedFile * )_unsavedFile )->Filename = _path.fileSystemRepresentation;
            ( ( struct CXUnsavedFile * )_unsavedFile )->Contents = _text.UTF8String;
            ( ( struct CXUnsavedFile * )_unsavedFile )->Length   = _text.length;
        }
        
        if( args.count > 0 )
        {
            _args = ( char ** )calloc( sizeof( char * ), args.count );
            
            if( _args == NULL )
            {
                [ self release ];
                
                return nil;
            }
            
            i = 0;
            
            for( arg in args )
            {
                if( [ arg isKindOfClass: [ NSString class ] ] == NO )
                {
                    continue;
                }
                
                _args[ i ] = calloc( sizeof( char ), strlen( ( ( NSString * )arg ).UTF8String ) + 1 );
                
                if( _args[ i ] == NULL )
                {
                    [ self release ];
                    
                    return nil;
                }
                
                strlcpy( ( char * )_args[ i ], ( ( NSString * )arg ).UTF8String, strlen( ( ( NSString * )arg ).UTF8String ) + 1 );
                
                i++;
                
                _numArgs = ( int )i;
            }
        }
        
        _cxTranslationUnit = clang_parseTranslationUnit
        (
            _index.cxIndex,
            _path.fileSystemRepresentation,
            ( const char * const * )_args,
            _numArgs,
            _unsavedFile,
            ( _unsavedFile == NULL ) ? 0 : 1,
            clang_defaultEditingTranslationUnitOptions()
          //| CXTranslationUnit_DetailedPreprocessingRecord
          //| CXTranslationUnit_PrecompiledPreamble
          //| CXTranslationUnit_CacheCompletionResults
          //| CXTranslationUnit_Incomplete
        );
        
        if( _cxTranslationUnit == NULL )
        {
            [ self release ];
            
            return nil;
        }
        
        [ self tokens ];
        [ self diagnostics ];
    }
    
    return self;
}

@end
