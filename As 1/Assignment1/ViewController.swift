//
//  ViewController.swift
//  Assignment1
//
//  Created by Yan, Xin [sgxyan2] on 07/03/2019.
//  Copyright © 2019 Yan, Xin [sgxyan2]. All rights reserved.
//

import UIKit

struct techReport: Decodable {
    let year: String
    let id: String
    let owner: String?
    let email: String?
    let authors: String
    let title: String
    let abstract: String?
    let pdf: URL?
    let comment: String?
    let lastModified: String
}

struct technicalReports: Decodable {
    let techreports2: [techReport]
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var a = [String]()
    var dict = [String:[techReport]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
    }
    
    func downloadJson(){
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/techreports/data.php?class=techreports2") {
            let session = URLSession.shared
            
            session.dataTask(with: url) { (data, response, err) in
                guard let jsonData = data else {
                    return }
                do{
                    let decoder = JSONDecoder()
                    let reportList = try decoder.decode(technicalReports.self, from: jsonData)
                    
                    for a in reportList.techreports2{
                        let akey = String(a.year)
                        if var aContents = self.dict[akey]{
                            aContents.append(a)
                            self.dict[akey] = aContents
                        }else{
                            self.dict[akey] = [a]
                        }
                        self.a = [String](self.dict.keys)
                        self.a = [String](self.dict.keys.sorted(by:{$0>$1}))
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
                }.resume()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.a.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return a[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let akey = a[section]
            if let aContents = dict[akey]{
                return aContents.count
            }
            return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActorCell") as? ActorCell else {return UITableViewCell()}
        let akey = a[indexPath.section]
        if let aContent = dict[akey]{
        cell.Title?.text = aContent[indexPath.row].title
        cell.Subtitle?.text = aContent[indexPath.row].authors
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let akey = a[indexPath.section]
        if let aContent = dict[akey]{
        let passdata = aContent[indexPath.row]
        self.performSegue(withIdentifier: "passdetail", sender: passdata)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passdetail"{
            let controller = segue.destination as! Page2
            controller.data = sender as? techReport
        }
    }

}

