//
//  CDProjectNewFileChooseTypeViewController.swift
//  C+++
//
//  Created by 23786 on 2020/8/16.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

protocol CDProjectNewFileChooseTypeViewControllerDelegate {
    func newFileCreated(atPath: String)
}

class CDProjectNewFileChooseTypeViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    var delegate: CDProjectNewFileChooseTypeViewControllerDelegate?
    
    static let supportedFileTypes: KeyValuePairs<String, [String]> = [
        "C++ Source": ["cpp", "cxx", "c++"],
        "C/C++ Header": ["h", "hpp", "h++"],
        "C Source": ["c"],
        "Text File": [],
        "Markdown File": ["md"]
    ]
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return CDProjectNewFileChooseTypeViewController.supportedFileTypes.count
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = CDProjectNewFileChooseTypeViewControllerCollectionViewItem()
        item.loadView()
        item.setType(
            typeName: CDProjectNewFileChooseTypeViewController.supportedFileTypes[indexPath.item].key,
            typeExtension: CDProjectNewFileChooseTypeViewController.supportedFileTypes[indexPath.item].value.first ?? "txt"
        )
        return item
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.selectItems(at: [IndexPath(item: 0, section: 0)], scrollPosition: .leadingEdge)
    }
    
    
    
}

extension CDProjectNewFileChooseTypeViewController {
    
    @IBAction func cancel(_ sender: Any?) {
        self.dismiss(nil)
    }
    
    @IBAction func done(_ sender: Any?) {
        let `extension` = CDProjectNewFileChooseTypeViewController.supportedFileTypes[self.collectionView.selectionIndexPaths.first?.item ?? 0].value
        let panel = NSSavePanel()
        panel.allowedFileTypes = `extension`
        let result = panel.runModal()
        if result == .OK && panel.url != nil {
            FileManager.default.createFile(atPath: panel.url!.path, contents: nil)
            self.delegate?.newFileCreated(atPath: panel.url!.path)
        }
        self.dismiss(nil)
    }
    
}
