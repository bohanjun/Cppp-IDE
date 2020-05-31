//
//  CDProjectTableView.swift
//  C+++
//
//  Created by 23786 on 2020/5/12.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDProjectTableView: CDTableView {
    
    @objc dynamic var paths = [String]() {
        didSet {
            setup()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.cells = load()
        
    }
    
    override func load() -> [CDTableViewCell] {
        var array = [CDProjectTableViewCell]()
        for i in self.paths {
            array.append(CDProjectTableViewCell(path: i))
        }
        return array
    }
    
    override func save() {
        
    }
    
}
