//
//  CDProjectDocument+UI.swift
//  C+++
//
//  Created by 23786 on 2020/8/11.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

extension CDProjectDocument {
    
    func openDocument(item: CDProjectItem) {
        
        self.contentViewController?.contentVC?.view.removeFromSuperview()
        
        switch item {
            
            case .document(let document):
                
                self.contentViewController?.projectSettingsView?.isHidden = true
                
                self.contentViewController.documentInfoFileNameLabel.stringValue = document.path.nsString.lastPathComponent
                self.contentViewController.documentInfoFilePathLabel.stringValue = document.path
                var documentType = "Other"
                switch document.path.nsString.pathExtension.lowercased() {
                    case "cpp", "cxx", "c++": documentType = "C++ Source"
                    case "c": documentType = "C Source"
                    case "h", "hpp", "h++": documentType = "Header"
                    case "in": documentType = "Input File"
                    case "out", "ans": documentType = "Output File"
                    default: break
                }
                documentType = "Type: \(documentType)"
                
                self.contentViewController.documentInfoFileTypeLabel.stringValue = documentType
                self.contentViewController.documentInfoDescription.string = document.fileDescription ?? ""
                
                // Try to open the document in a content view controller.
                do {
                    
                    self.contentViewController.contentVC.representedObject = try CDCodeDocument(contentsOf: URL(fileURLWithPath: document.path), ofType: "C++ Source")
                    
                    /*for view in self.contentViewController.fileView.subviews {
                        view.removeFromSuperview()
                    }*/
                    
                    self.contentViewController.contentVC.view.frame = self.contentViewController.fileView.bounds
                    self.contentViewController.contentVC.loadView()
                    self.contentViewController.contentVC.view.translatesAutoresizingMaskIntoConstraints = false
                    self.contentViewController.contentVC.enterSimpleMode(nil)
                    let contraint1 = NSLayoutConstraint(item: self.contentViewController.contentVC.view, attribute: .top, relatedBy: .equal, toItem: self.contentViewController.fileView, attribute: .top, multiplier: 1.0, constant: 0.0)
                    let contraint2 = NSLayoutConstraint(item: self.contentViewController.contentVC.view, attribute: .bottom, relatedBy: .equal, toItem: self.contentViewController.fileView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                    let contraint3 = NSLayoutConstraint(item: self.contentViewController.contentVC.view, attribute: .leading, relatedBy: .equal, toItem: self.contentViewController.fileView, attribute: .leading, multiplier: 1.0, constant: 0.0)
                    let contraint4 = NSLayoutConstraint(item: self.contentViewController.contentVC.view, attribute: .trailing, relatedBy: .equal, toItem: self.contentViewController.fileView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
                    self.contentViewController.contentVC.view.updateConstraints()
                    self.contentViewController.fileView.addSubview(self.contentViewController.contentVC.view)
                    self.contentViewController.contentVC.pathControl.isHidden = true
                    self.contentViewController.fileView.addConstraints([contraint1, contraint2, contraint3, contraint4])
                    
                } catch {
                    
                    self.contentViewController.showAlert("Error", "Unable to open file. The file may have been moved to another directory or deleted.")
                    
                }
                
            case .project(_):
                
                self.contentViewController?.projectSettingsView?.isHidden = false
                
                self.contentViewController.documentInfoFileNameLabel.stringValue = self.fileURL?.lastPathComponent ?? "Not saved"
                self.contentViewController.documentInfoFilePathLabel.stringValue = self.fileURL?.path ?? "Not saved"
                self.contentViewController.documentInfoFileTypeLabel.stringValue = "Type: Project"
                self.contentViewController.documentInfoDescription.string = project.fileDescription ?? ""
                
            case .folder(let folder):
                
                self.contentViewController?.projectSettingsView?.isHidden = true
                
                self.contentViewController.documentInfoFileNameLabel.stringValue = folder.name
                self.contentViewController.documentInfoFilePathLabel.stringValue = "-"
                self.contentViewController.documentInfoFileTypeLabel.stringValue = "Type: Folder"
                self.contentViewController.documentInfoDescription.string = folder.fileDescription ?? ""
                
        }
        
    }
    

    
}
