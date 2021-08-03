//
//  ViewController.swift
//  Shopping List
//
//  Created by Xin.Yan on 2019/5/6.
//  Copyright © 2019 Yan Xin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var myitem = [Items]()
    
    @IBOutlet weak var myField: UITextField!
    
    @IBAction func Addbtm(_ sender: Any) {
        let item = Items(context: PersistenceService.context)
        item.items = myField.text
        PersistenceService.saveContext()
        self.myitem.append(item)
        
        let indexPath = IndexPath(row: myitem.count-1, section: 0)
        myTable.beginUpdates()
        myTable.insertRows(at: [indexPath], with: .automatic)
        myTable.endUpdates()
        
        self.view.endEditing(true)
        myField.text = ""
    }
    
    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fetchRequest: NSFetchRequest<Items> = Items.fetchRequest()
        do{
            let item = try PersistenceService.context.fetch(fetchRequest)
            self.myitem = item
        }
        catch{}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myitem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myitemm = myitem[indexPath.row]
        
        let mycell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        mycell.textLabel?.text = myitemm.items
        return mycell
    }
    
    @IBAction func EndEditting(_ sender: Any) {
        self.view.endEditing(true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

