//
//  ThirdViewController.swift
//  Assignment5
//
//  Created by Hitesh Bhatia on 11/4/17.
//  Copyright © 2017 Hitesh Bhatia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
var nickName : String?
var pwd : String?
var city : String?
var year : String?
var country : String?
var state : String?
var lat : String?
var lon : String?
var fetchedCountry = [String]()
var fetchedState = [String]()
var selectedCountry : String = ""
var test : String = ""

class ThirdViewController: FirstViewController {

    @IBOutlet weak var thirdCountryPicker: UIPickerView!
    @IBOutlet weak var thirdStatePicker: UIPickerView!
    static var fourthLat : Double = 0.0
    static var fourthLon : Double = 0.0
    
    @IBOutlet weak var nickNameText: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var latText: UITextField!
    @IBOutlet weak var lonText: UITextField!
    @IBOutlet weak var getLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCountryList()
        // Do any additional setup after loading the view.
        
        submitButton.isEnabled = false
        countryText.isHidden = true
        stateText.isHidden = true
        nickNameText.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        pwdTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        cityText.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        yearText.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
         countryText.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
         stateText.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let name = nickNameText.text, !name.isEmpty,
            let pwd = pwdTextField.text, !pwd.isEmpty,
            let city = cityText.text, !city.isEmpty,
            let year = yearText.text, !year.isEmpty
            else {
                submitButton.isEnabled = false
                return
        }
        submitButton.isEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == thirdCountryPicker{
            return fetchedCountry.count
        }else{
            return fetchedState.count
        }
        
    }
    
    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == thirdCountryPicker{
            countryText.text = fetchedCountry[row]
            return fetchedCountry[row]
        }else{
            stateText.text = fetchedState[row]
            return fetchedState[row]
        }
        
    }
    
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == thirdCountryPicker{
        selectedCountry = fetchedCountry[row]
        countryText.text = fetchedCountry[row]
            getStateList()
        }else{
            stateText.text = fetchedState[row]
        }
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertYesNo(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.getCityLatLon()
            })
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func validateForm(year : String, country : String, state : String, nickName : String, pwd : String, lat : Double, lon : Double) -> Bool{
        
        if globalName.description.uppercased().contains(nickName.uppercased()){
            alert(message: "NickName already taken", title: "NickName Error")
            return false
        }
        
        if pwd.count < 3 {
            alert(message: "Password should be greater than 3 characters", title: "Password Error")
            return false
        }
        
        if Int(year)! < 1970 || Int(year)! > 2017{
            alert(message: "Year should be between 1970 & 2017", title: "Year Error")
            return false
        }
        if country == "" || state == ""{
            alert(message: "Please select Country & State", title: "Location Error")
            return false
        }
        
        if(lat < -90.0 || lat > 90.0){
            alert(message: "Please keep Latitude values between -90.0 & 90.0", title: "Location Error")
            return false
        }
        if(lon < -180.0 || lon > 180.0){
            alert(message: "Please keep Longitude values between -180.0 & 180.0", title: "Location Error")
            return false
        }
        
        return true
    }

    func getCountryList(){
        fetchedCountry = []
            let url = "https://bismarck.sdsu.edu/hometown/countries"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print("Error")
            }else{
                do{
                    let fetchedData = try JSONSerialization.jsonObject(with: data! , options: .mutableLeaves) as! NSArray
                    
                    for eachCountry in fetchedData{
                        
                        let country = eachCountry as! String

                        fetchedCountry.append(country)
                    }
                    if self.thirdCountryPicker != nil{
                        self.thirdCountryPicker.delegate = self
                        self.thirdCountryPicker.dataSource = self
                    }
                }catch{
                    print("Error")
                }
            }
        }
        task.resume()
    }
    
    func getStateList(){
        fetchedState = []
        let url = "https://bismarck.sdsu.edu/hometown/states?country=\(selectedCountry)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print("Error")
            }else{
                do{
                    let fetchedData = try JSONSerialization.jsonObject(with: data! , options: .mutableLeaves) as! NSArray
                    
                    for eachState in fetchedData{
                        
                        let state = eachState as! String
                        
                        fetchedState.append(state)
                    }
                    if self.thirdStatePicker != nil{
                        self.thirdStatePicker.delegate = self
                        self.thirdStatePicker.dataSource = self
                    }
                }catch{
                    print("Error")
                }
            }
        }
        task.resume()
    }
    
    func getCityLatLon(){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city!) {
            placemarks, error in
            let placemark = placemarks?.first
            let latitude = placemark!.location!.coordinate.latitude
            let longitude = placemark!.location!.coordinate.longitude
            lat = String(latitude)
            lon = String(longitude)
            self.latText.text = String(latitude)
            self.lonText.text = String(longitude)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lat = ThirdViewController.fourthLat != 0.0 ? String(ThirdViewController.fourthLat) : "0.0"
        lon = ThirdViewController.fourthLon != 0.0 ? String(ThirdViewController.fourthLon) : "0.0"
        nickNameText.text = nickName
        pwdTextField.text = pwd
        cityText.text = city
        yearText.text = year != "" ? year : "0"
        countryText.text = country
        stateText.text = state
        latText.text = lat != "" ? lat : "0.0"
        lonText.text = lon != "" ? lon : "0.0"
        
    }
    
    @IBAction func onSubmitClicked(_ sender: Any) {
        
        nickName = nickNameText.text!
        pwd = pwdTextField.text!
        city = cityText.text!
        year = yearText.text!
        country = countryText.text!
        state = stateText.text!
        lat = latText.text!
        lon = lonText.text!
        
        let dispatchQueue = DispatchQueue(label: "com.prit.TestGCD.DispatchQueue", attributes: DispatchQueue.Attributes.concurrent)
        
        let semaphore = DispatchSemaphore(value: 1)
        
        dispatchQueue.async {
            self.getCityLatLon()
            semaphore.signal()
        }
        
        dispatchQueue.async {
            Thread.sleep(forTimeInterval: 1)
            self.postData()
            semaphore.signal()
        }
    }
    
    func postData(){
        let parameters = ["nickname":nickName! ,"password":pwd! , "city":city! ,"longitude": Double(lon!)! ,"state":state!,"year":Int(year!)! ,"latitude":Double(lat!)!,"country":country!] as [String : Any]
        
        guard let url = URL(string : "https://bismarck.sdsu.edu/hometown/adduser") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else  {return}
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data, response, error) in
            if let response = response{
                print(response)
            }
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    DispatchQueue.main.async {
                        self.nickNameText.text = ""
                        self.pwdTextField.text = ""
                        self.countryText.text = ""
                        self.stateText.text = ""
                        self.cityText.text = ""
                        self.yearText.text = "0"
                        self.latText.text = "0.0"
                        self.lonText.text = "0.0"
                        self.submitButton.isEnabled = false
                        self.alert(message: "Data Uploaded Sucessfully", title: "Success Message")
                    }
                }catch{
                    DispatchQueue.main.async {
                        self.nickNameText.text = ""
                        self.pwdTextField.text = ""
                        self.countryText.text = ""
                        self.stateText.text = ""
                        self.cityText.text = ""
                        self.yearText.text = "0"
                        self.latText.text = "0.0"
                        self.lonText.text = "0.0"
                        self.submitButton.isEnabled = false
                        self.alert(message: String(describing: error), title: "Some Error")
                    }
                    print(error)
                }
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let fourthMapView : ForthViewController = segue.destination as! ForthViewController
        
        fourthMapView.thirdLat = latText.text != "" ? latText.text! : "0.0"
        fourthMapView.thirdLon = lonText.text != "" ? lonText.text! : "0.0"
        fourthMapView.country = countryText.text!
        fourthMapView.city = cityText.text!
        fourthMapView.state = stateText.text!
    }
    
    @IBAction func getLocationButton(_ sender: Any) {
        nickName = nickNameText.text!
        pwd = pwdTextField.text!
        city = cityText.text!
        year = yearText.text!
        country = countryText.text!
        state = stateText.text!
        lat = latText.text!
        lon = lonText.text!
        performSegue(withIdentifier: "mapIdentifier", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
