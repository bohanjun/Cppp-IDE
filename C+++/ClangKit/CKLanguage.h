//
//  CKLanguage.h
//  C+++
//
//  Created by 23786 on 2020/7/1.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

#ifndef CKLanguage_h
#define CKLanguage_h

typedef enum {
    CKLanguageNone   = 0x00,    /*! Unknown language */
    CKLanguageC      = 0x01,    /*! C source code */
    CKLanguageCPP    = 0x02,    /*! C++ source code */
    CKLanguageObjC   = 0x03,    /*! Objective-C source code */
    CKLanguageObjCPP = 0x04     /*! Objective-C++ source code */
} CKLanguage;

#endif /* CKLanguage_h */
