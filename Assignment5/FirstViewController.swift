//
//  FirstViewController.swift
//  Assignment5
//
//  Created by Hitesh Bhatia on 11/1/17.
//  Copyright © 2017 Hitesh Bhatia. All rights reserved.
//

import UIKit
var globalLat = [Double]()
var globalLon = [Double]()
var globalCountry = [String]()
var globalYear = [Int]()
var globalName = [String]()

class FirstViewController: UIViewController, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var dataTableView: UITableView!
    var fetchedUser = [User]()
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var countryPicker: UIPickerView!
    var filteredCountry : String = ""
    var filteredYear : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //parseData()
        getFilterData(url: URL(string: "https://bismarck.sdsu.edu/hometown/users")!)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @IBAction func searchButton(_ sender: Any) {
        var filterURL : String = ""
        if filteredCountry != "" && filteredYear != 0 {
            filterURL = "https://bismarck.sdsu.edu/hometown/users?year=\(filteredYear)&country=\(filteredCountry)"
        }else if filteredCountry != "" {
            filterURL = "https://bismarck.sdsu.edu/hometown/users?country=\(filteredCountry)"
        }else if filteredYear != 0{
            filterURL = "https://bismarck.sdsu.edu/hometown/users?year=\(filteredYear)"
        }else{
            filterURL = "https://bismarck.sdsu.edu/hometown/users"
        }
        getFilterData(url: URL(string: filterURL)!)
        OperationQueue.main.addOperation {
            self.dataTableView.reloadData()
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return fetchedUser.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        self.dataTableView.rowHeight = 100
        let cell = dataTableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let indexConstant = fetchedUser[indexPath.row]
        
        cell.nickNameLabel.text = "Nick Name: " + indexConstant.nickName
        cell.cityLabel.text = "City: " + indexConstant.city
        cell.stateLabel.text = "State: " + indexConstant.state
        cell.countryLabel.text = "Country: " + indexConstant.country
        cell.yearLabel.text = "Year: " + String(indexConstant.year)
        return cell
    }
    
    func getFilterData(url : URL){
        fetchedUser = []
        globalLat = []
        globalLon = []
        let session = URLSession.shared
        session.dataTask(with: url){ (data, response, error) in
            if let response = response{
                print(response)
            }
            if let data = data{
                do{
                    let fetchedAllData = try JSONSerialization.jsonObject(with: data , options: [])

                    globalYear.append(0)
                    globalCountry.append("ALL")
                    guard let fetchedFilteredData = fetchedAllData as? [Any] else {return}
                    for eachUser in fetchedFilteredData{
                        let user = eachUser as! [String : Any]
                        let city = user["city"] as! String
                        let country = user["country"] as! String
                        globalCountry.append(country)
                        let nickName = user["nickname"] as! String
                        globalName.append(nickName)
                        let lat = user["latitude"] as! Double
                        globalLat.append(lat)
                        let lon = user["longitude"] as! Double
                        globalLon.append(lon)
                        let state = user["state"] as! String
                        let year = user["year"] as! Int
                        globalYear.append(year)

                        self.fetchedUser.append(User(nickName: nickName, city: city, country: country, lat: lat, lon: lon, state: state, year: year))
                    }
                    if self.countryPicker != nil {
                        DispatchQueue.main.async{
                            self.dataTableView.reloadData()
                            self.countryPicker.delegate = self
                            self.countryPicker.dataSource = self
                            self.yearPicker.delegate = self
                            self.yearPicker.dataSource = self
                        }
                    }
                }catch{
                    print("Error")
                }
            }
        }.resume()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPicker{
            globalCountry.distinct()
            return globalCountry.count
        }else{
            globalYear.distinct()
            return globalYear.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == countryPicker{
            globalCountry.distinct()
            return globalCountry[row]
        }else{
            globalYear.distinct()
            globalYear.sort()
            return String(globalYear[row])
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPicker{
            filteredCountry = globalCountry[row]
        }else{
            filteredYear = globalYear[row]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class User{
    
    //var id : Int
    var nickName : String
    var city : String
    var country : String
    var lat : Double
    var lon : Double
    var state : String
    var year : Int
    
    init(nickName : String, city : String, country : String, lat : Double, lon : Double, state : String, year : Int){
        self.city = city
        self.country = country
        self.nickName = nickName
        self.lat = lat
        self.lon = lon
        self.state = state
        self.year = year
    }
}

extension Array where Element : Equatable{
    mutating func distinct(){
        var uniqueElements : [Element] = []
        
        for elem in self{
            if !uniqueElements.contains(elem){
                uniqueElements.append(elem)
            }
        }
        self = uniqueElements
    }
}

