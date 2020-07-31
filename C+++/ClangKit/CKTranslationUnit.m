// ClangKit
 


#import "CKTranslationUnit.h"
#import "CKTranslationUnit+Private.h"
#import "CKIndex.h"
#import "CKDiagnostic.h"
#import "CKToken.h"
#import "CKCompletionResult.h"

@implementation CKTranslationUnit

@synthesize path                = _path;
@synthesize cxTranslationUnit   = _cxTranslationUnit;
@synthesize index               = _index;

+ ( id )translationUnitWithPath: ( NSString * )path
{
    return [ [ [ self alloc ] initWithPath: path ] autorelease ];
}

+ ( id )translationUnitWithPath: ( NSString * )path index: ( CKIndex * )index
{
    return [ [ [ self alloc ] initWithPath: path index: index ] autorelease ];
}

+ ( id )translationUnitWithPath: ( NSString * )path args: ( NSArray * )args
{
    return [ [ [ self alloc ] initWithPath: path args: args ] autorelease ];
}

+ ( id )translationUnitWithPath: ( NSString * )path index: ( CKIndex * )index args: ( NSArray * )args
{
    return [ [ [ self alloc ] initWithPath: path index: index args: args ] autorelease ];
}

+ ( id )translationUnitWithText: ( NSString * )text language: ( CKLanguage )language
{
    return [ [ [ self alloc ] initWithText: text language: language ] autorelease ];
}

+ ( id )translationUnitWithText: ( NSString * )text language: ( CKLanguage )language index: ( CKIndex * )index
{
    return [ [ [ self alloc ] initWithText: text language: language index: index ] autorelease ];
}

+ ( id )translationUnitWithText: ( NSString * )text language: ( CKLanguage )language args: ( NSArray * )args
{
    return [ [ [ self alloc ] initWithText: text language: language args: args ] autorelease ];
}

+ ( id )translationUnitWithText: ( NSString * )text language: ( CKLanguage )language index: ( CKIndex * )index args: ( NSArray * )args
{
    return [ [ [ self alloc ] initWithText: text language: language index: index args: args ] autorelease ];
}

- ( id )initWithPath: ( NSString * )path
{
    return [ self initWithPath: path index: nil args: nil ];
}

- ( id )initWithPath: ( NSString * )path index: ( CKIndex * )index
{
    return [ self initWithPath: path index: index args: nil ];
}

- ( id )initWithPath: ( NSString * )path args: ( NSArray * )args
{
    return [ self initWithPath: path index: nil args: args ];
}

- ( id )initWithPath: ( NSString * )path index: ( CKIndex * )index args: ( NSArray * )args
{
    return [ self initWithPath: path text: nil index: index args: args ];
}

- ( id )initWithText: ( NSString * )text language: ( CKLanguage )language
{
    return [ self initWithText: text language: language index: nil args: nil ];
}

- ( id )initWithText: ( NSString * )text language: ( CKLanguage )language index: ( CKIndex * )index
{
    return [ self initWithText: text language: language index: index args: nil ];
}

- ( id )initWithText: ( NSString * )text language: ( CKLanguage )language args: ( NSArray * )args
{
    return [ self initWithText: text language: language index: nil args: args ];
}

- ( id )initWithText: ( NSString * )text language: ( CKLanguage )language index: ( CKIndex * )index args: ( NSArray * )args
{
    
    CFUUIDRef     uuid;
    CFStringRef   uuidString;
    NSString    * extension;
    NSString    * tempFileName;
    NSString    * tempFile;
    char          buffer[ 40 ];
    char        * s;
    
    uuid         = CFUUIDCreate( kCFAllocatorDefault );
    uuidString   = CFUUIDCreateString( kCFAllocatorDefault, uuid );
    
    memset( buffer, 0, 40 );
    CFStringGetCString( uuidString, buffer, 40, kCFStringEncodingUTF8 );
    
    switch( language )
    {
        case CKLanguageC:       extension = @".c";      break;
        case CKLanguageCPP:     extension = @".cpp";    break;
        case CKLanguageObjC:    extension = @".m";      break;
        case CKLanguageObjCPP:  extension = @".mm";     break;
        case CKLanguageNone:    extension = @"";        break;
        default:                extension = @"";        break;
    }
    
    tempFileName = [ NSString stringWithFormat: @"C+++_ClangKit_TempFile_%s%@", buffer, extension ];
    tempFile     = [[[[[[[NSFileManager alloc] init] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] firstObject] URLByAppendingPathComponent:@"C+++"] URLByAppendingPathComponent:tempFileName] path];
    
    CFRelease( uuid );
    CFRelease( uuidString );
    
    if( tempFile.fileSystemRepresentation )
    {
        s = strdup( tempFile.fileSystemRepresentation );
        
        if( s == NULL )
        {
            [ self release ];
            
            return nil;
        }
        
        if( mkstemp( s ) == -1 )
        {
            free( s );
            
            [ self release ];
            
            return nil;
        }
        
        free( s );
        
        return [ self initWithPath: tempFile text: text index: index args: args ];
    }
       
    [ self release ];
    
    return nil;
}

- ( void )dealloc
{
    int i;
    
    if( _tokens.count > 0 )
    {
        clang_disposeTokens( _cxTranslationUnit, _tokensPointer, ( unsigned int )_tokens.count );
    }
    
    clang_disposeTranslationUnit( _cxTranslationUnit );
    
    for( i = 0; i < _numArgs; i++ )
    {
        free( _args[ i ] );
    }
    
    free( ( void * )_args );
    
    if( _unsavedFile != NULL )
    {
        [ [ NSFileManager defaultManager ] removeItemAtPath: _path error: NULL ];
        
        free( _unsavedFile );
    }
    
    [ _path         release ];
    [ _text         release ];
    [ _index        release ];
    [ _diagnostics  release ];
	[ _lock			release ];
    
    [ super dealloc ];
}

- ( void )reparse
{
    @synchronized( self )
    {
		[ _lock lock ];
		
        if( _tokens.count > 0 )
        {
            clang_disposeTokens( _cxTranslationUnit, _tokensPointer, ( unsigned int )_tokens.count );
            
            _tokensPointer = NULL;
        }
        
        [ _tokens       release ];
        [ _diagnostics  release ];
        
        _tokens      = nil;
        _diagnostics = nil;
        
        clang_reparseTranslationUnit
        (
            _cxTranslationUnit,
            ( _unsavedFile == NULL ) ? 0 : 1,
            _unsavedFile,
            clang_defaultReparseOptions( _cxTranslationUnit )
          | CXTranslationUnit_DetailedPreprocessingRecord
          | CXTranslationUnit_PrecompiledPreamble
          | CXTranslationUnit_CacheCompletionResults
          | CXTranslationUnit_Incomplete
        );
		
		[ _lock unlock ];
        
        [ self tokens ];
        [ self diagnostics ];
    }
}

- ( NSArray * )diagnostics
{
    @synchronized( self )
    {
        if( _diagnostics == nil )
        {
			[ _lock lock ];
			
            _diagnostics = [ [ CKDiagnostic diagnosticsForTranslationUnit: self ] retain ];
			
			[ _lock unlock ];
        }
        
        return _diagnostics;
    }
}

- ( NSArray * )tokens
{
    @synchronized( self )
    {
        if( _tokens == nil )
		{
			[ _lock lock ];
			
            _tokens = [ [ CKToken tokensForTranslationUnit: self tokens: &_tokensPointer ] retain ];
			
			[ _lock unlock ];
        }
        
        return _tokens;
    }
}

- ( NSString * )text
{
    @synchronized( self )
    {
        return _text;
    }
}

- ( void )setText: ( NSString * )text
{
    @synchronized( self )
    {
        if( _unsavedFile == NULL )
        {
            _unsavedFile = calloc( sizeof( struct CXUnsavedFile ), 1 );
        }
        
        if( _unsavedFile != NULL )
        {
            if( _text != text )
            {
                [ _text release ];
                
                _text = [ text retain ];
            }
            @try
            {
                ( ( struct CXUnsavedFile * )_unsavedFile )->Filename = _path.fileSystemRepresentation;
                ( ( struct CXUnsavedFile * )_unsavedFile )->Contents = _text.UTF8String;
                ( ( struct CXUnsavedFile * )_unsavedFile )->Length   = _text.length;
                
                [ self reparse ];
            }
            @catch ( NSException * e )
            {
                ( void )e;
            }
        }
    }
}

- ( CXFile )cxFile
{
    @synchronized( self )
    {
        return clang_getFile( _cxTranslationUnit, _path.fileSystemRepresentation );
    }
}

- ( NSString * )description
{
    NSString * description;
    
    description = [ super description ];
    description = [ description stringByAppendingFormat: @"%@", self.path ];
    
    return description;
}

- ( NSArray * )completionResultsForLine: ( NSUInteger )line column: ( NSUInteger )column
{
    NSMutableArray        * array;
    CXCodeCompleteResults * results;
    unsigned                i;
    CXCompletionResult      result;
    CKCompletionResult    * completionResult;
    
	[ _lock lock ];
    
	if( _unsavedFile != NULL )
    {
        ( ( struct CXUnsavedFile * )_unsavedFile )->Filename = _path.fileSystemRepresentation;
        ( ( struct CXUnsavedFile * )_unsavedFile )->Contents = _text.UTF8String;
        ( ( struct CXUnsavedFile * )_unsavedFile )->Length   = _text.length;
    }
    
    results = clang_codeCompleteAt
    (
        _cxTranslationUnit,
        _path.fileSystemRepresentation,
        ( unsigned int )line,
        ( unsigned int )column,
        _unsavedFile,
        ( _unsavedFile == NULL ) ? 0 : 1,
        clang_defaultCodeCompleteOptions()
    );
    
    if( results == NULL )
    {
		[ _lock unlock ];
		
		return nil;
    }
    
    array = [ NSMutableArray arrayWithCapacity: ( NSUInteger )( results->NumResults ) ];
    
    for( i = 0; i < results->NumResults; i++ )
    {
        result           = results->Results[ i ];
        completionResult = [ CKCompletionResult completionResultWithCXCompletionString: result.CompletionString cursorKind: ( CKCursorKind )result.CursorKind ];
        
        if( completionResult != nil )
        {
            [ array addObject: completionResult ];
        }
    }
    
    clang_disposeCodeCompleteResults( results );
	
	[ _lock unlock ];
    
    return [ NSArray arrayWithArray: array ];
}

@end
