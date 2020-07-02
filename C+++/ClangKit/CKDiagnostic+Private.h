// ClangKit

#import "CKDiagnostic.h"

@interface CKDiagnostic( Private )

- ( id )initWithCXDiagnostic: ( CXDiagnostic )diagnostic translationUnit: ( CKTranslationUnit * )translationUnit;

@end
