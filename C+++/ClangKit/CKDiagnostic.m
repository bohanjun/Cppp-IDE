// ClangKit

#import "CKDiagnostic.h"
#import "CKDiagnostic+Private.h"
#import "CKTranslationUnit.h"

CKDiagnosticSeverity CKDiagnosticSeverityIgnored  = CXDiagnostic_Ignored;
CKDiagnosticSeverity CKDiagnosticSeverityNote     = CXDiagnostic_Note;
CKDiagnosticSeverity CKDiagnosticSeverityWarning  = CXDiagnostic_Warning;
CKDiagnosticSeverity CKDiagnosticSeverityError    = CXDiagnostic_Error;
CKDiagnosticSeverity CKDiagnosticSeverityFatal    = CXDiagnostic_Fatal;

@implementation CKDiagnostic

@synthesize cxDiagnostic    = _cxDiagnostic;
@synthesize spelling        = _spelling;
@synthesize severity        = _severity;
@synthesize fixIts          = _fixIts;
@synthesize line            = _line;
@synthesize column          = _column;
@synthesize range           = _range;

+ ( NSArray * )diagnosticsForTranslationUnit: ( CKTranslationUnit * )translationUnit
{
    unsigned int     numDiagnostics;
    unsigned int     i;
    NSMutableArray * diagnostics;
    CKDiagnostic   * diagnostic;
    
    numDiagnostics = clang_getNumDiagnostics( translationUnit.cxTranslationUnit );
    diagnostics    = [ NSMutableArray arrayWithCapacity: ( NSUInteger )numDiagnostics ];
    
    for( i = 0; i < numDiagnostics; i++ )
    {
        diagnostic = [ CKDiagnostic diagnosticWithTranslationUnit: translationUnit index: i ];
        
        if( diagnostic != nil )
        {
            [ diagnostics addObject: diagnostic ];
        }
    }
    
    return [ NSArray arrayWithArray: diagnostics ];
}

+ ( id )diagnosticWithTranslationUnit: ( CKTranslationUnit * )translationUnit index: ( NSUInteger )index
{
    return [ [ [ self alloc ] initWithTranslationUnit: ( CKTranslationUnit * )translationUnit index: index ] autorelease ];
}

- ( id )initWithTranslationUnit: ( CKTranslationUnit * )translationUnit index: ( NSUInteger )index
{
    if( ( self = [ self initWithCXDiagnostic: clang_getDiagnostic( translationUnit.cxTranslationUnit, ( unsigned int )index ) translationUnit: translationUnit ] ) )
    {}
    
    return self;
}

- ( void )dealloc
{
    clang_disposeDiagnostic( _cxDiagnostic );
    
    [ _fixIts   release ];
    [ _spelling release ];
    
    [ super dealloc ];
}

- ( NSString * )description
{
    NSString * description;
    NSString * severity;
    
    if( self.severity == CKDiagnosticSeverityError )
    {
        severity = @"Error";
    }
    else if( self.severity == CKDiagnosticSeverityFatal )
    {
        severity = @"Fatal";
    }
    else if( self.severity == CKDiagnosticSeverityIgnored )
    {
        severity = @"Ignored";
    }
    else if( self.severity == CKDiagnosticSeverityNote )
    {
        severity = @"Note";
    }
    else if( self.severity == CKDiagnosticSeverityWarning )
    {
        severity = @"Warning";
    }
    else
    {
        severity = @"Unknown";
    }
    
    description = [ super description ];
    description = [ description stringByAppendingFormat: @": %@[%lu:%lu] - %@",
                                                         severity,
                                                         ( unsigned long )( self.line ),
                                                         ( unsigned long )( self.column ),
                                                         self.spelling
                  ];
    
    return description;
}

@end
