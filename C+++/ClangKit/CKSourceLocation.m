// ClangKit
 


#import "CKSourceLocation.h"

@implementation CKSourceLocation

@synthesize ptrData1 = _ptrData1;
@synthesize ptrData2 = _ptrData2;
@synthesize intData  = _intData;
@synthesize fileName = _fileName;

+ ( id )sourceLocationWithPointerData1: ( const void * )ptrData1 pointerData2: ( const void * )ptrData2 intData: ( unsigned int )intData
{
    return [ [ [ self alloc ] initWithPointerData1: ptrData1 pointerData2: ptrData2 intData: intData ] autorelease ];
}

- ( id )initWithPointerData1: ( const void * )ptrData1 pointerData2: ( const void * )ptrData2 intData: ( unsigned int )intData
{
    CXSourceLocation location;
    CXFile           file;
    CXString         fileName;
    unsigned int     line;
    unsigned int     column;
    unsigned int     offset;
    
    if( ( self = [ self init ] ) )
    {
        _ptrData1 = ptrData1;
        _ptrData2 = ptrData2;
        _intData  = intData;
        
        location.ptr_data[ 0 ] = ptrData1;
        location.ptr_data[ 1 ] = ptrData2;
        location.int_data      = intData;
        
        clang_getExpansionLocation( location, &file, &line, &column, &offset );
        
        fileName = clang_getFileName( file );
        
        if( clang_getCString( fileName ) != NULL )
        {
            _fileName = [ [ NSString alloc ] initWithCString: clang_getCString( fileName ) encoding: NSUTF8StringEncoding ];
        }
    }
    
    return self;
}

- ( void )dealloc
{
    [ _fileName release ];
    
    [ super dealloc ];
}

@end
