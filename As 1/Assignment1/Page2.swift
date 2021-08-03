//
//  Page2.swift
//  Assignment1
//
//  Created by Yan, Xin [sgxyan2] on 12/03/2019.
//  Copyright © 2019 Yan, Xin [sgxyan2]. All rights reserved.
//

import UIKit
import MessageUI
import CoreData
class Page2: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var P2Title: UILabel!
    @IBOutlet weak var P2Author: UILabel!
    @IBOutlet weak var P2Content: UILabel!
    @IBOutlet weak var P2Fav: UISwitch!
    
    @IBAction func viewfullreport(_ sender: Any) {
        if data?.pdf != nil{
            let url = data?.pdf
            UIApplication.shared.open((url)! as URL, options: [:], completionHandler: nil)
        }else{
            self.showMessage(atitle: "Can't open pdf", message: "There's no pdf file.")
        }
    }
    
    @IBAction func emailauthor(_ sender: Any) {
        if MFMailComposeViewController.canSendMail(){
            let mailCVC = configureMailController()
            self.present(mailCVC, animated: true, completion: nil)
        }else{
            self.showMessage(atitle: "Can't send email", message: "You haven't set your email account.")
        }
    }
    
    
    var data : techReport?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        P2Fav.isOn = false
        P2Title.text = data?.title
        P2Author.text = data?.authors
        let newcontent = data?.abstract
        var newcontent2 = newcontent?.replacingOccurrences(of: "<P>", with: "")
        newcontent2 = newcontent2?.replacingOccurrences(of: "<p>", with: "")
        newcontent2 = newcontent2?.replacingOccurrences(of: "<I>", with: "")
        newcontent2 = newcontent2?.replacingOccurrences(of: "</I>", with: "")
        newcontent2 = newcontent2?.replacingOccurrences(of: "<em>", with: "")
        newcontent2 = newcontent2?.replacingOccurrences(of: "</em>", with: "")
        P2Content.text = newcontent2
        
        // Do any additional setup after loading the view.
    }
    
//    func swAction(sw:UISwitch){
//        let app = UIApplication.shared.delegate as! AppDelegate
//        let context = app.persistentContainer.viewContext
//        let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: context) as! Favorite
//        if sw.isOn{
//            favorite.iffav = true
//            print(favorite.iffav)
//        }else{
//            favorite.iffav = false
//            print(favorite.iffav)
//        }
//    }
    func configureMailController() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients([(data?.email)!])
        mailComposeVC.setSubject("Sending to Author")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        controller.dismiss(animated: true, completion: nil)
        
        switch result{
        case .sent:
            self.showMessage(atitle: "Succeed", message: "Your email has been sent successfully.")
        case .cancelled:
            self.showMessage(atitle: "Cancalled", message: "Your email has been Cancelled.")
        case .saved:
            self.showMessage(atitle: "Saved", message: "Your email has been saved.")
        case .failed:
            self.showMessage(atitle: "Failed", message: "Your email didn't send successfully.")
        }
    }
    
    func showMessage(atitle: String, message: String){
        let ErrorAlert = UIAlertController(title: atitle, message: message, preferredStyle: .alert)
        ErrorAlert.addAction(UIAlertAction(title: "Sure", style: .cancel))
        self.present(ErrorAlert, animated: true){}
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
