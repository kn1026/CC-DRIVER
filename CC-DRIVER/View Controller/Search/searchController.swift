//
//  searchController.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/23/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import GooglePlaces
import GeoFire
import MapKit
import Firebase
import Alamofire

class searchController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    var isDestination = false
    var panHandle = false
    var resultsArray = [String]()
    var bounds = GMSCoordinateBounds()
    var placeList = [searchModel]()
    var RecentlyPlaceList = [searchModel]()
    
    
    var listCampus = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var placesClient = GMSPlacesClient()

    
    var fetcher: GMSAutocompleteFetcher?
    
    
    @IBOutlet weak var destinationSearchBar: ModifiedSearchBar!
    @IBOutlet weak var myLocationSearchBar: ModifiedSearchBar!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchControllers: UISearchController?
   
    
    var tableDataSource: GMSAutocompleteTableDataSource?
    
    @IBOutlet weak var tableBotConstraint: NSLayoutConstraint!
    
    
    var recentlyDict = [String: Any]()
    
    //var resultView: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeID1 = ""
        placeID2 = ""
        
        //checkCampusDistance()
        
        changeSearchBarTxtViewColor()
        
        destinationSearchBar.delegate = self
        myLocationSearchBar.delegate = self
        
    
        
        tableView.delegate = self
        tableView.dataSource = self
        
        destinationSearchBar.becomeFirstResponder()
        isDestination = true
       
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        
        
        
       
        
        // Set up the autocomplete filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        // Create the fetcher.
        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
        
        
        getRecentlySearch()
    }
    
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            tableBotConstraint.constant = keyboardHeight
        }
    }

    @IBAction func back1BtnPressed(_ sender: Any) {
        
        
        placeID1 = ""
        placeID2 = ""
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        
        placeID1 = ""
        placeID2 = ""
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func changeSearchBarTxtViewColor() {
        
        if let txfSearchField = myLocationSearchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.backgroundColor = .clear
            txfSearchField.leftViewMode = UITextFieldViewMode.never

        }
        
        if let txfSearchField = destinationSearchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.borderStyle = .none
            txfSearchField.backgroundColor = .clear
            txfSearchField.leftViewMode = UITextFieldViewMode.never
        }
   
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar == myLocationSearchBar {
            
            if searchBar.text == "My location" {
                
                myLocationSearchBar.text = ""
                
                isDestination = false
            }
            
            
        } else {
            
            if myLocationSearchBar.text == "" {
                
                myLocationSearchBar.text = "My location"
                
                isDestination = true
                
            }
            
            
            
        }
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.placeList.removeAll()
        
        
        
        
        if searchText != "" {
            
            resultsArray.removeAll()
            fetcher?.sourceTextHasChanged(searchText)
            
            
        } else {
            
            self.tableView.reloadData()
            
        }
        
    }

    
    func LookUpInfo1(ID: String, completed: @escaping DownloadComplete) {
        
        placesClient.lookUpPlaceID(ID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(ID)")
                return
            }
            
            pickUpLocation = place.coordinate
            pickUpAddress = place.formattedAddress!
            pickUp_add_Name = place.name
            completed()
            
           
            
            
        })
        
    }
    
    
    func LookUpInfo2(ID: String,completed: @escaping DownloadComplete) {
        
        placesClient.lookUpPlaceID(ID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(ID)")
                return
            }
            
            DestinationLocation = place.coordinate
            destinationAddress = place.formattedAddress!
            placeName = place.name
            
            completed()
            
            
        })
        
    }
    
    
    func getRecentlySearch() {
        
        self.resultsArray.removeAll()
        
        DataService.instance.mainDataBaseRef.child("Recently_search").child(userUID).queryOrdered(byChild: "TimeStamp").queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (RequestRecent) in
            
            
            if RequestRecent.exists() {
                
                if let snap = RequestRecent.children.allObjects as? [DataSnapshot] {
                    
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            let key = RequestRecent.key
                            let searchData = searchModel(postKey: key, searchModel: postDict)
                            self.placeList.insert(searchData, at: 0)
                            
                            
                        }
                        
                        
                        
                    }
                    
                    self.tableView.reloadData()
                    
                }
                
                
                
                
            }
            
            
            
        })
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let place: searchModel
        
        place = placeList[indexPath.row]
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as? searchCell {
            
            
            if indexPath.row > 0 {
                
                let lineFrame = CGRect(x:30, y:0, width: Double(self.view.frame.width) - 62, height: 1)
                let line = UIView(frame: lineFrame)
                line.backgroundColor = UIColor.groupTableViewBackground
                cell.addSubview(line)
                
            }
            
            cell.configureCell(place)
            return cell
        } else {
            return searchCell()
        }
        
    }
    
    
    func checkCampusDistance() {
        
        guard let coordinate = locationManager.location?.coordinate else {
            
            
            self.showErrorAlert("Oops !!!", msg: "Cannot track your location, please turn it on and try again")
            
            return
            
            
        }
        let url = DataService.instance.mainDataBaseRef.child("Campus_Coordinate")
        let geofireRef = url
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let query = geoFire.query(at: loc, withRadius: 20)
        checkCampusRadius(query: query)
    }
    
    func checkCampusRadius(query: GFCircleQuery) {
        
        query.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            
            if let key = key {
                
                self.listCampus.append(key)
                
            }
            
            
        })
        
        query.observeReady {
            
            
            if self.listCampus.isEmpty == true {
                
                self.showErrorAlert("Oops !!!", msg: "You are not near any of our campus")
                
            }
            
            query.removeAllObservers()
        }
    }
    
    
    
    
    func getPlaceID1(location: CLLocationCoordinate2D, completed: @escaping DownloadComplete) {
        
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.latitude),\(location.longitude)&language=en&key=\(googlePlace_key)"
        
        Alamofire.request(url).responseJSON { (response) in
            
            
            switch response.result {
            case .success:
                
                if let result = response.result.value as? [String: Any] {
                    
                    for i in result {
                        
                        if i.key == "results" {
                            
                            
                            if let results = i.value as? [Dictionary<String, AnyObject>] {
                                for x in results {
                                    
                                    placeID1 = x["place_id"] as! String
                                    completed()
                                    break
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            case .failure:
                print("Cannot retrieve infomation")
            }
            
            
        }
        
        
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let place: searchModel
        
        place = placeList[indexPath.row]
        
        if isDestination == true {
            
            //var placeID1 = ""
            placeID2 = place.PlaceID
            if myLocationSearchBar.text == "My location" {
                
                placeID1 = ""
                
            }
            
            if placeID1 != "" {
                
                self.LookUpInfo1(ID: placeID1) {
                    self.LookUpInfo2(ID: placeID2, completed: {
                        
                        self.view.endEditing(true)
                       
                        self.recentlyDict = ["PlaceName": place.PlaceName, "PlaceAddress": place.PlaceAddress, "PlaceID": place.PlaceID, "TimeStamp": ServerValue.timestamp()]
                        DataService.instance.mainDataBaseRef.child("Recently_search").child(userUID).child(place.PlaceID).setValue(self.recentlyDict)
                        NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "GetRide")), object: nil)
                        
                        print(pickUpAddress)
                        self.dismiss(animated: true, completion: nil)
                        
                       
                    })
                }
                
                
                
            } else {
                
                guard let coordinate = locationManager.location?.coordinate else {
                    
                    
                    self.showErrorAlert("Oops !!!", msg: "Cannot track your location, please turn it on and try again")
                    
                    return
                    
                    
                }
                
                self.getPlaceID1(location: coordinate) {
                    
                    self.LookUpInfo1(ID: placeID1) {
                        self.LookUpInfo2(ID: placeID2, completed: {
                            
                            
                            
                            
                            
                            self.view.endEditing(true)
                            
                            self.recentlyDict = ["PlaceName": place.PlaceName, "PlaceAddress": place.PlaceAddress, "PlaceID": place.PlaceID, "TimeStamp": ServerValue.timestamp()]
                            DataService.instance.mainDataBaseRef.child("Recently_search").child(userUID).child(place.PlaceID).setValue(self.recentlyDict)
                            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "GetRide")), object: nil)
                            
                            
                            print(pickUpAddress)
                            self.dismiss(animated: true, completion: nil)
                            
                            
                        })
                    }
                    
                    
                    
                    
                }
                
                
                
                
                
                
            }
            
            
            
        
        } else {
            
            placeID1 = place.PlaceID
            myLocationSearchBar.text = place.PlaceName
            destinationSearchBar.becomeFirstResponder()
            isDestination = true
            
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func swiftLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 170
        
        config.backgroundColor = UIColor.clear
        config.spinnerColor = UIColor.white
        config.titleTextColor = UIColor.white
        
        
        config.spinnerLineWidth = 3.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.7
        
        
        SwiftLoader.setConfig(config: config)
        
        
        SwiftLoader.show(title: "", animated: true)
        
        
        
        
        
        
    }

}

extension searchController: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction?{
                let id = prediction.placeID
                
                
                
                let PlaceInformation: Dictionary<String, AnyObject> = ["PlaceName": prediction.attributedPrimaryText.string as AnyObject, "PlaceAddress": prediction.attributedSecondaryText?.string as AnyObject, "PlaceID": id as AnyObject]

                let PlaceData = searchModel(postKey: id!, searchModel: PlaceInformation)
                self.placeList.append(PlaceData)
                
                
                self.tableView.reloadData()
                
            }
        }
        
       
        
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
}
