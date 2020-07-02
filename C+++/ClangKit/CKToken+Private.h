// ClangKit

#import "CKToken.h"

@interface CKToken( Private )

- ( id )initWithCXToken: ( CXToken )token translationUnit: ( CKTranslationUnit * )translationUnit;

@end
