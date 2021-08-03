//
//  PlacesViewController.swift
//  My Favorite Place
//
//  Created by Xin.Yan on 2019/5/10.
//  Copyright © 2019 Yan Xin. All rights reserved.
//

import UIKit
import CoreData

var places = [Dictionary<String, String>()]
var currentPlace = -1

class PlacesViewController: UITableViewController {
    
    var MyPlace = [PlaceCD]()
    
    @IBOutlet var table: UITableView!
   
    @IBAction func AddPlace(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest: NSFetchRequest<PlaceCD> = PlaceCD.fetchRequest()
        do{
            var place00 = try PlaceCoreData.context.fetch(fetchRequest)
            if place00.count == 0{
                let place01 = PlaceCD(context: PlaceCoreData.context)
                place01.lat = 53.406566
                place01.long = -2.966531
                place01.location = "Ashton Building"
                PlaceCoreData.saveContext()
                place00 = try PlaceCoreData.context.fetch(fetchRequest)
            }
            self.MyPlace = place00
            print(MyPlace.count, "0")
            places.remove(at: 0)
            for a in place00{
                places.append((["name":a.location!, "lat": String(a.lat), "lon":String(a.long)]))
            }
            tableView.reloadData()
        }catch{}
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        if places[indexPath.row]["name"] != nil {
        cell.textLabel?.text = places[indexPath.row]["name"]
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPlace = indexPath.row
        performSegue(withIdentifier: "to Map", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let fetchRequest: NSFetchRequest<PlaceCD> = PlaceCD.fetchRequest()
        do{
            self.MyPlace = try PlaceCoreData.context.fetch(fetchRequest)
        }catch{}

        print(MyPlace.count, "1")
        currentPlace = -1
        table.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            places.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            let PlacetoDelete = MyPlace[indexPath.row]
            PlaceCoreData.context.delete(PlacetoDelete)
            PlaceCoreData.saveContext()
        }
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
