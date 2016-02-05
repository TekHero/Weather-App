//
//  ViewController.swift
//  Weather App - Exercise
//
//  Created by Brian Lim on 1/24/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import Foundation

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mainDegreeLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var todayTitleLbl: UILabel!
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var minTempLbl: UILabel!
    
    var userInput: String?
    var finalInput: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
        view.addGestureRecognizer(tapGesture)
        self.userInputTextField.delegate = self
        
        let darkerView: UIView = UIView()
        darkerView.backgroundColor = UIColor.blackColor()
        darkerView.frame = view.bounds
        darkerView.alpha = 0.4
        bgImgView.addSubview(darkerView)
    }
    
    func loadData() {
        if let input = userInputTextField.text {
            userInput = input
            locationLbl.text = userInput?.capitalizedString
            finalInput = userInput?.stringByReplacingOccurrencesOfString(" ", withString: "&20")
            userInputTextField.text = ""
            userInputTextField.resignFirstResponder()
        }
        
        downloadWeatherInfo()
        todayTitleLbl.hidden = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        loadData()
        return true
        
    }
    
    func downloadWeatherInfo() {
        
        if userInputTextField.text != nil {
        
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(finalInput)&appid=44db6a862fba0b067b1930da0d769e98&units=imperial")!
        Alamofire.request(.GET, url).responseJSON { (response) -> Void in
            let result = response.result
            
            if let json = result.value as? Dictionary<String, AnyObject> {
                
                if let weather = json["weather"] as? [Dictionary<String,AnyObject>] {
                    
                    if let desc = weather[0]["description"] as? String {
                        self.descLbl.text = desc.capitalizedString
                    }
                    
                    if let iconID = weather[0]["id"] as? Int {
                        if iconID >= 200 && iconID <= 233 {
                            self.mainImg.image = UIImage(named: "Thunderstorm")
                            self.bgImgView.image = UIImage(named: "thunderstormbg")
                        }
                        if iconID >= 300 && iconID <= 321 {
                            self.mainImg.image = UIImage(named: "Raining")
                            self.bgImgView.image = UIImage(named: "Rainingbg")
                        }
                        if iconID >= 500 && iconID <= 531 {
                            self.mainImg.image = UIImage(named: "Raining")
                            self.bgImgView.image = UIImage(named: "Rainingbg")
                        }
                        if iconID >= 600 && iconID <= 622 {
                            self.mainImg.image = UIImage(named: "Snowing")
                            self.bgImgView.image = UIImage(named: "Snowingbg")
                        }
                        if iconID >= 701 && iconID <= 781 {
                            self.mainImg.image = UIImage(named: "Haze")
                            self.bgImgView.image = UIImage(named: "Hazebg")
                        }
                        if iconID == 800 {
                            self.mainImg.image = UIImage(named: "Clear-Sky")
                            self.bgImgView.image = UIImage(named: "Clear-Skybg")
                        }
                        if iconID >= 801 && iconID <= 804 {
                            self.mainImg.image = UIImage(named: "Cloudy")
                            self.bgImgView.image = UIImage(named: "Cloudybg")
                        }
                        if iconID >= 900 && iconID <= 906 {
                            self.mainImg.image = UIImage(named: "Tornado")
                            self.bgImgView.image = UIImage(named: "Tornadobg")
                        }
                        if iconID >= 951 && iconID <= 962 {
                            self.mainImg.image = UIImage(named: "Wind")
                            self.bgImgView.image = UIImage(named: "Windybg")
                        }
                    }
                }
                
                if let mainInfo = json["main"] as? Dictionary<String, AnyObject> {
                    
                    if let temp = mainInfo["temp"] as? Double {
                        self.mainDegreeLbl.text = "\(Int(temp))°"
                    }
                    
                    if let humidity = mainInfo["humidity"] as? Int {
                        self.humidityLbl.text = "\(humidity)%"
                    }
                    
                    if let maxTemp = mainInfo["temp_max"] as? Double {
                        self.maxTempLbl.text = "\(Int(maxTemp))°"
                    }
                    
                    if let minTemp = mainInfo["temp_min"] as? Double {
                        self.minTempLbl.text = "\(Int(minTemp))°"
                    }
                }
                
                if let wind = json["wind"] as? Dictionary<String, AnyObject> {
                    
                    if let speed = wind["speed"] as? Double {
                        self.windLbl.text = "\(Int(speed)) MPH"
                    }
                }
            }
        }
            
        }
    }
    
    func dismissKeyboard(tapGesture: UITapGestureRecognizer) {
        userInputTextField.endEditing(true)
    }
    
}

