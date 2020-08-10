//
//  CDProjectTableView.swift
//  C+++
//
//  Created by 23786 on 2020/5/12.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDProjectTableView: CDSnippetTableView {
    
    @objc dynamic var paths = [String]() {
        didSet {
            setup(cells: self.cells)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.cells = load()
        
    }
    
    override func load() -> [CDSnippetTableViewCell] {
        var array = [CDProjectTableViewCell]()
        for i in self.paths {
            array.append(CDProjectTableViewCell(path: i))
        }
        return array
    }
    
    /*override func save() {
        (self.window?.contentViewController as! CDProjectViewController).saveProject(self)
    }*/
    
    override func allItemTitles() -> [String] {
        
        var res = [String]()
        for i in self.cells {
            res.append((i as! CDProjectTableViewCell).path)
        }
        return res
        
    }
    
    
}
