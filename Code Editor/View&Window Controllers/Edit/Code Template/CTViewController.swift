//
//  CTViewController.swift
//  Code Editor
//
//  Created by apple on 2020/3/25.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

let NameCodePairs: Dictionary = [
    "  For Statement": "\nfor (int i = , i <= , i ++ ) {\n\t\n}",
    "  If Statement": "\nif () {\n\t\n}",
    "  While Statement": "\nwhile () {\n\t\n}",
    "  If-else Statement": "\nif () {\n\t\n} else {\n\t\n}",
    "  Struct Declaration": "\nstruct TNode {\n\tint a, b;\n\tTNode(int x, int y) : a(x), b(y){}\n};",
    "  Switch Statement" : "\nswitch () {\n\tcase : break;\n\tcase : break;\n}",
    "  Function Declaration": "\nvoid func(int a, ...) {\n\t\n}",
    "  DFS Template": "void dfs(int t) {\n\tif (/*Reaches the End*/) {\n\t\t/*Output;*/\n\t\treturn;\n\t}\n\tfor (int i = ; /*Every Possible Answers*/; i ++) {\n\t\tif (!gVis[i]) {\n\t\t\tgVis[i] = 1; // Change\n\t\t\t// Do Something;\n\t\t\tdfs(t + 1);\n\t\t\tgVis[i] = 0; // Recover\n\t\t}\n\t}\n}",
    "  Bubble Sort": "for (int i = 1; i <= n - 1; i ++) {\n\tfor (int j = 1; j <= n - i; j ++) {\n\t\tif(a[j] < a[j + 1]) swap(a[j], a[j + 1]);\n\t}\n}",
    "  Bucket Sort": "int a;\nfor (int i = 0; i < arr.count; i ++) {\n\tscanf(\"%d\", &a);\n\tn[a] += 1;\n}\n// output\nfor (int i = 0; i < arr.count; i ++) {\n\tfor(int j = 1; j <= n[i]; j ++)\n\t\tprintf(\"%d \", i);\n}",
    "  Binary Search": "void binarySearch(int x) {\n\tint L = 1, R = MAXN, mid;\n\twhile (L < R) {\n\t\tmid = (L + R) / 2;\n\t\tif (x >= n[mid]) {\n\t\t\tL = mid;\n\t\t} else {\n\t\t\tR = mid - 1;\n\t\t}\n\t}\n\tprintf(\"%d\", n[L]);\n}"
]

class CTViewController: NSViewController {

    @IBOutlet weak var ctview: CTView!
    @IBOutlet weak var scrollView: NSScrollView!
    
    @IBAction func setCTView(_ sender: NSButton) {
        let Code = NameCodePairs[sender.title]
        var Title = sender.title
        Title.removeFirst()
        Title.removeFirst()
        self.ctview.reinit(name: Title, code: Code ?? "Error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        // scroll to top
        self.scrollView.contentView.scroll(to: NSPoint(x: 0, y: self.scrollView.contentSize.height))
        scrollView.reflectScrolledClipView(scrollView.contentView)
        
        
        // init the CTView
        self.ctview.reinit(name: "For Statement", code: NameCodePairs["  For Statement"] ?? "Error")
        
    }
    
}
