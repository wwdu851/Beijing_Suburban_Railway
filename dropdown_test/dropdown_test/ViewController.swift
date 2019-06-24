//
//  ViewController.swift
//  dropdown_test
//
//  Created by William Du on 5/22/31 H.
//  Copyright © 31 Weiran Du. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
    
    let station = ["Yanqing","Nankou","HTD","HEHE"]

    
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pressed(_ sender: UIButton) {
    }
    
}

