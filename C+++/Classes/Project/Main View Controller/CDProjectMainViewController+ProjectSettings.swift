//
//  CDProjectMainViewController+ProjectSettings.swift
//  C+++
//
//  Created by 23786 on 2020/8/21.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDProjectMainViewController: CDProjectSettingsViewDelegate {
    
    func projectSettingsDidChangeVersion(to string: String) {
        // print("projectSettingsDidChangeVersion(to: \(string))")
        self.document?.project.version = string
        DispatchQueue.main.async {
            self.document?.save(nil)
        }
    }
    
    func projectSettingsDidChangeCompileCommandSettings(useDefault: Bool) {
        // print("projectSettingsDidChangeCompileCommandSettings(useDefault: \(useDefault))")
        self.document?.project.compileCommand = useDefault ? "Default" : "Custom"
        DispatchQueue.main.async {
            self.document?.save(nil)
        }
    }
    
}
