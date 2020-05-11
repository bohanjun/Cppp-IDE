//
//  ViewController(OutlineView).swift
//  C+++
//
//  Created by 23786 on 2020/5/11.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDProjectData: NSObject {
    
    var children = [CDProjectDataItem]()
    var name: String
    
    class func load(dictionary: [NSDictionary]) -> [CDProjectData] {
        
        var datas = [CDProjectData]()
        
        for i in dictionary {
            
            let item = CDProjectData(name: i.object(forKey: "name") as! String)
            let items =  i.object(forKey: "items") as! [NSDictionary]
            
            for dict in items {
                let dataItem = CDProjectDataItem(dictionary: dict)
                item.children.append(dataItem)
                
            }
            
            datas.append(item)
            
        }
        
        return datas
        
    }
    
    init(name: String) {
        self.name = name
    }
    
}


class CDProjectDataItem: NSObject {
    var fileName: String
    init(dictionary: NSDictionary) {
        self.fileName = dictionary.object(forKey: "name") as! String
    }
}

extension ViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let i = item as? CDProjectData {
            return i.children.count
        }
        return datas.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let i = item as? CDProjectData {
            return i.children[index]
        }
        return datas[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let i = item as? CDProjectData {
            return i.children.count > 0
        }
        return false
    }
    
}
