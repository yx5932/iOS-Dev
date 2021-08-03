//
//  ViewController.swift
//  Times Table
//
//  Created by Yan Xin on 2019/5/01.
//  Copyright © 2019 Yan Xin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{

    var myNumber = Int()
    var myResult = [Int]()
    var length = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTable.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var myField: UITextField!
    
    @IBAction func myButton(_ sender: Any) {
        if myField.text?.count == 0{
            showMessage(atitle: "Oops!", message: "You have not entered a number")
            myTable.isHidden = true
        }else{
            if isPureInt(string: myField.text!) == true{
                myResult = [Int]()
                myNumber = Int(myField.text!)!
                for i in 1..<length+1{	2222222222222222
                    let times = Int(i) * myNumber
                    myResult.append(times)
                }
                self.myTable.reloadData()
                self.view.endEditing(true)
                myTable.isHidden = false
            }else{
                showMessage(atitle: "Oops! Invalid input!", message: "Please input a number")
                myTable.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var myTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return length
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mycell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "myCell")
        if myResult.count == 20{
//            mycell.textLabel?.text = ""
//        }else{
            mycell.textLabel?.text = "\(String(myNumber)) × \(indexPath.row + 1) = \(String(myResult[indexPath.row]))"
        }
        return mycell
    }
    
    func showMessage(atitle: String, message: String){
        let ErrorAlert = UIAlertController(title: atitle, message: message, preferredStyle: .alert)
        present(ErrorAlert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            ErrorAlert.dismiss(animated: false, completion: nil)
        }
    }
    
    func isPureInt(string: String) -> Bool {
        let scan: Scanner = Scanner(string: string)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let permision = "+-1234567890"
        let permisionSet = CharacterSet(charactersIn: permision)
        let typed = CharacterSet(charactersIn: string)
        return permisionSet.isSuperset(of: typed)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

