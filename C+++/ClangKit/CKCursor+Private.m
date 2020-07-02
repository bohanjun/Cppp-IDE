// ClangKit
 


#import "CKCursor+Private.h"
#import "CKSourceLocation.h"

@implementation CKCursor( Private )

- ( id )initWithCXCursor: ( CXCursor )cursor
{
    CXString            displayName;
    CXString            kindSpelling;
    CXSourceLocation    location;
    
    if( ( self = [ self init ] ) )
    {
        if( clang_Cursor_isNull( cursor ) )
        {
            [ self release ];
            
            return nil;
        }
        
        _cxCursorPointer = calloc( sizeof( CXCursor ), 1 );
        
        memcpy( _cxCursorPointer, &cursor, sizeof( CXCursor ) );
        
        _kind         = clang_getCursorKind( cursor );
        displayName   = clang_getCursorDisplayName( cursor );
        kindSpelling  = clang_getCursorKindSpelling( ( enum CXCursorKind )_kind );
        _displayName  = [ [ NSString alloc ] initWithCString: clang_getCString( displayName) encoding: NSUTF8StringEncoding ];
        _kindSpelling = [ [ NSString alloc ] initWithCString: clang_getCString( kindSpelling) encoding: NSUTF8StringEncoding ];
        location      = clang_getCursorLocation( cursor );
        _location     = [ [ CKSourceLocation alloc ] initWithPointerData1: location.ptr_data[ 0 ] pointerData2: location.ptr_data[ 1 ] intData: location.int_data ];
        
        if( clang_isCursorDefinition( cursor ) )
        {
            _isDefinition = YES;
        }
        
        [ self definition ];
        [ self referenced ];
        
        if( clang_isDeclaration(     ( enum CXCursorKind )_kind ) ) { _isDeclaration     = YES; }
        if( clang_isReference(       ( enum CXCursorKind )_kind ) ) { _isReference       = YES; }
        if( clang_isPreprocessing(   ( enum CXCursorKind )_kind ) ) { _isPreprocessing   = YES; }
        if( clang_isExpression(      ( enum CXCursorKind )_kind ) ) { _isExpression      = YES; }
        if( clang_isAttribute(       ( enum CXCursorKind )_kind ) ) { _isAttribute       = YES; }
        if( clang_isInvalid(         ( enum CXCursorKind )_kind ) ) { _isInvalid         = YES; }
        if( clang_isStatement(       ( enum CXCursorKind )_kind ) ) { _isStatement       = YES; }
        if( clang_isTranslationUnit( ( enum CXCursorKind )_kind ) ) { _isTranslationUnit = YES; }
        if( clang_isUnexposed(       ( enum CXCursorKind )_kind ) ) { _isUnexposed       = YES; }
    }
    
    return self;
}

@end
