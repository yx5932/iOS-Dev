//
//  ViewController.swift
//  Dice Roll
//
//  Created by Yan, Xin [sgxyan2] on 26/04/2019.
//  Copyright © 2019 Yan, Xin [sgxyan2]. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var Input: UITextField!
    
    @IBAction func GuessBtm(_ sender: Any) {
        let guessnumber = Input.text
        if guessnumber?.count != 0{
            let diceRoll = Int.random(in: 2..<13)
            if isPurnInt(string: Input.text!) == true{
                if Int(guessnumber!)! >= 2 && Int(guessnumber!)! <= 12{
                    if Int(guessnumber!) == diceRoll{
                        Result.text = "Right!\n\nMy number is \(diceRoll)"
                    }else{
                        Result.text = "Wrong!\n\nMy number is \(diceRoll)"
                    }
                }
                else{
                    Result.text = "Please input a number between 2 and 12"
                }
            }else{
                Result.text = "Invalid Input!\n\nPlease input a number between 2 and 12"
            }
        }else{
            Result.text = "You did not entered.\n\nPlease input a number between 2 and 12"
        }
        Result.isHidden = false
        self.view.endEditing(true)
        Input.text = ""
    }
    
    @IBOutlet weak var Result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Result.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    func isPurnInt(string: String) -> Bool {
        let scan: Scanner = Scanner(string: string)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
}

