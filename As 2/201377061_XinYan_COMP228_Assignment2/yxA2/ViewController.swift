//
//  ViewController.swift
//  yxA2
//
//  Created by zhananhua on 2019/4/11.
//  Copyright © 2019 xin.yan. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

struct ArtWork: Decodable {
    var id: String?
    var title: String?
    var artist: String?
    var yearOfWork: String?
    var Information: String?
    var lat: String?
    var long: String?
    var location: String?
    var locationNotes: String?
    var lastModified: String?
    var fileName: String?
}

struct technicalReports: Decodable {
    let campus_artworks: [ArtWork]
}

//To foramat the annotations
class myPin: NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle:String, pinSubtitle:String, location:CLLocationCoordinate2D){
        self.title = pinTitle
        self.subtitle = pinSubtitle
        self.coordinate = location
    }
}

//----create global variables/strings/dictionaries/etc. for functions to use
var info = [ArtWork]()
var getdata = [ArtWork]()
var artfile = [Artfile]()

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MKMapViewDelegate,UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mymap: MKMapView!
    @IBOutlet weak var mysearchbar: UISearchBar!
    @IBOutlet weak var mytable: UITableView!
    @IBOutlet weak var DetailSubView: UIView!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var SubViewTable: UITableView!
    
    //----create global variables/strings/dictionaries/etc. for functions to use
    var locationManager = CLLocationManager()
    var all = [String]()
    var selected = [String]()
    var dict = [String:[ArtWork]]()
    var dict2 = [String:[ArtWork]]()
    var searching = false
    var search = [String]()
    var headSection = [String]()
    var mylocation = CLLocation(latitude: 53.406566, longitude: -2.966531)
    var firsttime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchInfo()
        LoadData()
        readData()
        closeButton()
        setlocation()
        FormatOfSubView()
        DetailSubView.isHidden = true
    }
    
    //----Ask for authorization to find user's location
    func setlocation(){
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //----Set the region of the map and show the user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationOfUser = locations[0]
        let latitude = locationOfUser.coordinate.latitude
        let longitude = locationOfUser.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.002
        let lonDelta: CLLocationDegrees = 0.002
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mymap.setRegion(region, animated: true)
        mylocation = CLLocation(latitude: locationOfUser.coordinate.latitude, longitude: locationOfUser.coordinate.longitude)
    }
    
    //----Use the url to download json file and save it to core data.
    func LoadData(){
        if let FirstUrl = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artworksOnCampus/data.php?class=campus_artworks&lastUpdate=2017-11-01") {
            let session = URLSession.shared
            
            session.dataTask(with: FirstUrl) { (data, response, err) in
                guard let jsonData = data else {
                    return }
                do{
                    var judgelast1 = [String]()
                    var judgelast2 = [String]()
                    var islast = true
                    
                    let decoder = JSONDecoder()
                    let reportList = try decoder.decode(technicalReports.self, from: jsonData)
                    getdata = reportList.campus_artworks
                    //----save the json list to CoreData
                    //----if it's the first time open the application(or core data is empty)
                    print(artfile.count)
                    if artfile.count < 1{
                        info = reportList.campus_artworks
                        for a in getdata{
                            let artf = Artfile(context: CoreDataManager.context)
                            artf.artist = a.artist
                            artf.fileName = a.fileName
                            artf.id = a.id
                            artf.information = a.Information
                            artf.lastModified = a.lastModified
                            artf.lat = a.lat
                            artf.long = a.long
                            artf.location = a.location
                            artf.locationNotes = a.locationNotes
                            artf.yearOfWork = a.yearOfWork
                            artf.title = a.title
                            CoreDataManager.saveContext()
                            artfile.append(artf)
                            judgelast1.append(a.lastModified!)
                        }
                        self.functions()
                    }
                        
                    //judge if the fiale is the newest.(check the lastmodified data)
                    else{
                        for b in getdata{
                            judgelast2.append(b.lastModified!)
                        }
                        if judgelast1 == judgelast2{
                            print("All is well")
                        }else{
                            print("data changed")
                            islast = false
                        }
                    }

                    
                    DispatchQueue.main.async {
                    }
                    
                } catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
                }.resume()
        }
    }
    
    //----fetch data from core data and save them to "info"(type: [ArtWork])
    func readData(){
        if artfile.count > 0{
            for b in artfile{
                var data = ArtWork()
                data.artist = b.artist
                data.fileName = b.fileName
                data.id = b.id
                data.Information = b.information
                data.lastModified = b.lastModified
                data.lat = b.lat
                data.long = b.long
                data.location = b.location
                data.locationNotes = b.locationNotes
                data.yearOfWork = b.yearOfWork
                data.title = b.title
                info.append(data)
            }
        }
        self.functions()
    }
    
    //----Functions of:
    //----1.sort artworks by distance
    //----2.save the information into dictionary(for table cells and map annotations to load data)
    //----3.method of creating annotations on the map
    func functions(){
        //------------------------------------
        //method of sort artworks by distance
        //------------------------------------
        var distance = [Double]()
        var ListtoSort = [String : Double]()
        var latlist : [String] = []
        var longlist : [String] = []
        var selectinfo = [String]()
        //----save the artworks' infomation into string "selectinfo" according to locationNotes, duplicate elements will be rejected
        for useinfo in info{
            if !selectinfo.contains(useinfo.locationNotes!){
                selectinfo.append(useinfo.locationNotes!)
                latlist.append(useinfo.lat!)
                longlist.append(useinfo.long!)
            }
        }
        //----calcutlate the distance from the artwork to the user
        for i in 0..<selectinfo.count{
            let a = Double(latlist[i])
            let b = Double(longlist[i])
            let ArtworkCoor = CLLocation(latitude: a!, longitude: b!)
            distance.append(ArtworkCoor.distance(from: self.mylocation))
        }
        //----sort the artworks by distanse we've already calculated (from near to far), and save to string "headSection"
        for i in 0..<distance.count{
            ListtoSort[selectinfo[i]] = distance[i]
        }
        let result = ListtoSort.sorted {(str1, str2) -> Bool in
            return str1.1 < str2.1
        }
        for i in 0..<result.count{
            self.headSection.append(result[i].key)
        }
        
        //----------------------------------------------
        //method of save the information into dictionary
        //----------------------------------------------
        for ab in info{
            //----First dict: for the table in basic view
            let akey = String(ab.locationNotes!)
            if var aContents = self.dict[akey]{
                aContents.append(ab)
                self.dict[akey] = aContents
            }else{
                self.dict[akey] = [ab]
            }
            //----Second dict: for the table in sub-view
            let bkey = String(ab.location!)
            if var aContents = self.dict2[bkey]{
                aContents.append(ab)
                self.dict2[bkey] = aContents
            }else{
                self.dict2[bkey] = [ab]
            }
            //-----------------------------------------
            //method of creating annotations on the map
            //-----------------------------------------
            let title = ab.location
            if let lat = ab.lat, let latitude = Double(lat){
                if let long = ab.long, let longitude = Double(long){
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let annotation = myPin(pinTitle: title!, pinSubtitle: "", location: coordinate)
                    self.mymap.addAnnotation(annotation)
                }
            }
        }
        self.mymap.delegate = self
        self.mytable.reloadData()
        self.SubViewTable.reloadData()
    }
    
    //---------------------------------
    //----Set the format of annotations
    //---------------------------------
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let AnnoView = MKAnnotationView(annotation: annotation, reuseIdentifier: "selectpin")
        //----Use the picture "pin" saved in Asserts.xcassets as appearance of annotation
        AnnoView.image = UIImage(named:"pin")
        //----tap on the annotation will show call out
        AnnoView.canShowCallout = true
        //----An information button will show in rightside of call out
        AnnoView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return AnnoView
    }
    
    //----Tap on the call out, a second table view will appear on the map
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        DetailSubView.isHidden = false
    }
    
    //----If annotation is selected, send information(title name) to second table view
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selected = [((view.annotation?.title)!)!]
        self.SubViewTable.reloadData()
    }
    
    //----If the anootation is not selected any more, hide the second table view
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        DetailSubView.isHidden = true
    }
    
    //----Set the number of sections in two tables
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == mytable {
            if searching == true{
                //----Return searched information
                return search.count
            }else{
                //----Return all information
                return self.headSection.count
            }
        }else{
            //----Return second table view information
            return self.selected.count
        }
    }
    
    //----Set the title for header in section in two tables
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == mytable {
            if searching == true{
                //----Return searched information
                return search[section]
            }else{
                //----Return all information
                return headSection[section]
            }
        }else{
            //----Return second table view information
            return selected[section]
        }
    }
    
    //----Set the number of rows in section in two tables
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mytable {
            if searching == true{
                //----Show searched information
                let akey = search[section]
                if let aContents = dict[akey]{
                    return aContents.count
                }
                return 0
            }else{
                //----Show all information
                let akey = headSection[section]
                if let aContents = dict[akey]{
                    return aContents.count
                }
                return 0
            }
        }else{
            //----Show second table view information
            let bkey = selected[section]
            if let aContents = dict2[bkey]{
                return aContents.count
            }
            return 0
        }
    }
    
    //----Set the contents of cells in two tables
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mytable {
            if searching == true{
                //----Show searched information
                let identifier = "myCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
                
                let akey = search[indexPath.section]
                if let aContent = dict[akey]{
                    cell?.textLabel?.text = aContent[indexPath.row].title
                    cell?.detailTextLabel?.text = aContent[indexPath.row].artist
                }
                return cell!
            }else{
                //----Show all information
                let identifier = "myCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
                
                let akey = headSection[indexPath.section]
                if let aContent = dict[akey]{
                    cell?.textLabel?.text = aContent[indexPath.row].title
                    cell?.detailTextLabel?.text = aContent[indexPath.row].artist
                }
                return cell!
            }
        }else{
            //----Show second table view information
            let identifier = "detailcell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            
            let akey = selected[indexPath.section]
            if let aContent = dict2[akey]{
                cell?.textLabel?.text = aContent[indexPath.row].title
                cell?.detailTextLabel?.text = aContent[indexPath.row].artist
            }
            return cell!
        }
    }
    
    //----Set the layout of headerview in second table
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if tableView == SubViewTable{
            guard let header = view as? UITableViewHeaderFooterView else { return }
            header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
            header.textLabel?.lineBreakMode=NSLineBreakMode.byTruncatingMiddle
        }
    }
    
    //----If the cell is selected, pass the ditail information to second page use segue "passdetial"
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == mytable {
            if searching == true{
                //----If one of searched cells is selected, pass the ditail information to second page use segue "passdetial"
                self.mytable.deselectRow(at: indexPath, animated: true)
                let akey = search[indexPath.section]
                if let aContent = dict[akey]{
                    let passdata = aContent[indexPath.row]
                    self.performSegue(withIdentifier: "passdetail", sender: passdata)
                }
            }else{
                //----If one of all cells is selected, pass the ditail information to second page use segue "passdetial"
                self.mytable.deselectRow(at: indexPath, animated: true)
                let akey = headSection[indexPath.section]
                if let aContent = dict[akey]{
                    let passdata = aContent[indexPath.row]
                    self.performSegue(withIdentifier: "passdetail", sender: passdata)
                }
            }
            
            }else{
            //----If one of cells in second table is selected, pass the ditail information to second page use segue "passdetial"
                self.mytable.deselectRow(at: indexPath, animated: true)
                let akey = selected[indexPath.section]
                if let aContent = dict2[akey]{
                    let passdata = aContent[indexPath.row]
                    self.performSegue(withIdentifier: "passdetail", sender: passdata)
                }
            }
    }
    
    //----If user typed in search bar, check if headsection contains input contents.
    //----If contains, return the smaller headsection to arrange the main table.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if mysearchbar.text == nil || mysearchbar.text == ""{
            searching = false
            self.mytable.reloadData()
        }
        else{
            searching = true
            search = headSection.filter({$0.lowercased().contains(searchText.lowercased())})
            print(headSection)
            print(search)
            self.mytable.reloadData()
        }
    }
    
    //----Function for pass informations to second page.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "passdetail"{
            let controller = segue.destination as! Detail
            controller.jdata = sender as? ArtWork
        }
    }
    
    //----Set the format of subview which contains the second table.
    func FormatOfSubView(){
        DetailSubView.layer.shadowColor = UIColor.black.cgColor
        DetailSubView.layer.shadowOpacity = 0.6
        DetailSubView.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        DetailSubView.layer.shadowRadius = 5
    }
    
    //----Fetch infomation from core data
    func FetchInfo(){
        let fetchRequest: NSFetchRequest<Artfile> = Artfile.fetchRequest()
        do{
            let artfiles = try CoreDataManager.context.fetch(fetchRequest)
            artfile = artfiles
        }catch{}
    }
    
    //----Set the layout of close button in the head of second table
    func closeButton(){
        close.setImage(UIImage(named: "close"), for: .normal)
        close.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
    }
    
    //----Set the function of close button in the head of second table(close the second table)
    @objc func buttonClick(_ btn: UIButton) {
        DetailSubView.isHidden = true
    }
}

