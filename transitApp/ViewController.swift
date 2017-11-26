//
//  ViewController.swift
//  transitApp
//
//  Created by William Du on 2017/7/25.
//  Copyright © 2017年 William Du. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var weekDay = 0
    var startPlace = "Huangtudian"
    var destinationPlace = "Yanqing"
    var northBound = true
    var firstTouch = true
    let stationArray = ["Huangtudian","Nankou","Badaling","Yanqing","Kangzhuang","Shacheng"]
    var buttonList = [UIButton]()
    
    
    @IBOutlet weak var htdBtn: UIButton!
    @IBOutlet weak var nkBtn: UIButton!
    @IBOutlet weak var bdlBtn: UIButton!
    @IBOutlet weak var yqBtn: UIButton!
    @IBOutlet weak var kzBtn: UIButton!
    @IBOutlet weak var scBtn: UIButton!
    
    var firstBtnLocation:CGPoint?
    var secondBtnLocation:CGPoint?
    var thirdBtnLocation:CGPoint?
    var fourthBtnLocation:CGPoint?
    var fifthBtnLocation:CGPoint?
    
    
    var timeTable = [train(huangtudianStopTime:"6:30", nankouStopTime: "6:56", badalingStopTime: "7:40", yanqingStopTime: "7:55", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 201, northBound: true, runsOnWeekday: true)
        ,train(huangtudianStopTime:"8:11", nankouStopTime: "8:39", badalingStopTime: "9:20", yanqingStopTime: "na", kangzhuangStopTime: "9:40",shachengStopTime:"10:16", trainNumber: 287, northBound: true, runsOnWeekday: false)
        ,train(huangtudianStopTime:"8:40", nankouStopTime: "9:06", badalingStopTime: "9:50", yanqingStopTime: "10:05", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 205, northBound: true, runsOnWeekday: true)
        ,train(huangtudianStopTime:"11:06", nankouStopTime: "11:32", badalingStopTime: "12:16", yanqingStopTime: "12:31", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 209, northBound: true, runsOnWeekday: true)
        ,train(huangtudianStopTime:"12:52", nankouStopTime: "13:20", badalingStopTime: "14:04", yanqingStopTime: "14:19", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 211, northBound: true, runsOnWeekday: true)
        ,train(huangtudianStopTime:"13:20", nankouStopTime: "na", badalingStopTime: "14:28", yanqingStopTime: "14:43", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 213, northBound: true, runsOnWeekday: false)
        ,train(huangtudianStopTime:"15:34", nankouStopTime: "16:02", badalingStopTime: "16:46", yanqingStopTime: "17:01", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 217, northBound: true, runsOnWeekday: true)
        ,train(huangtudianStopTime:"17:21", nankouStopTime: "17:49", badalingStopTime: "18:33", yanqingStopTime: "18:48", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 219, northBound: true, runsOnWeekday: true)
        ,train(huangtudianStopTime:"17:50", nankouStopTime: "18:16", badalingStopTime: "19:00", yanqingStopTime: "19:15", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 221, northBound: true, runsOnWeekday: false)
        ,train(huangtudianStopTime:"19:19", nankouStopTime: "19:45", badalingStopTime: "na", yanqingStopTime: "20:39", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 225, northBound: true, runsOnWeekday: true)
        ,train(huangtudianStopTime:"21:09", nankouStopTime: "21:48", badalingStopTime: "22:32", yanqingStopTime: "22:47", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 227, northBound: true, runsOnWeekday: true)
        ,train(huangtudianStopTime:"22:02", nankouStopTime: "22:30", badalingStopTime: "na", yanqingStopTime: "23:24", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 229, northBound: true, runsOnWeekday: false)
        ,train(huangtudianStopTime:"7:33", nankouStopTime: "7:05", badalingStopTime: "na", yanqingStopTime: "6:10", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 202, northBound: false, runsOnWeekday: false)
        ,train(huangtudianStopTime:"7:56", nankouStopTime: "7:28", badalingStopTime: "na", yanqingStopTime: "6:33", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 204, northBound: false, runsOnWeekday: true)
        ,train(huangtudianStopTime:"9:39", nankouStopTime: "9:11", badalingStopTime: "8:27", yanqingStopTime: "8:11", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 208, northBound: false, runsOnWeekday: true)
        ,train(huangtudianStopTime:"12:03", nankouStopTime: "11:35", badalingStopTime: "10:51", yanqingStopTime: "10:35", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 210, northBound: false, runsOnWeekday: true)
        ,train(huangtudianStopTime:"12:32", nankouStopTime: "12:04", badalingStopTime: "11:18", yanqingStopTime: "na", kangzhuangStopTime: "11:04",shachengStopTime:"10:31", trainNumber: 288, northBound: false, runsOnWeekday: false)
        ,train(huangtudianStopTime:"14:53", nankouStopTime: "14:25", badalingStopTime: "13:40", yanqingStopTime: "13:20", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 216, northBound: false, runsOnWeekday: true)
        ,train(huangtudianStopTime:"16:31", nankouStopTime: "16:03", badalingStopTime: "15:08", yanqingStopTime: "14:45", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 218, northBound: false, runsOnWeekday: true)
        ,train(huangtudianStopTime:"17:04", nankouStopTime: "16:36", badalingStopTime: "15:52", yanqingStopTime: "15:30", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 220, northBound: false, runsOnWeekday: false)
        ,train(huangtudianStopTime:"18:45", nankouStopTime: "18:17", badalingStopTime: "17:33", yanqingStopTime: "17:17", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 224, northBound: false, runsOnWeekday: true)
        ,train(huangtudianStopTime:"20:47", nankouStopTime: "20:19", badalingStopTime: "19:34", yanqingStopTime: "19:18", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 226, northBound: false, runsOnWeekday: true)
        ,train(huangtudianStopTime:"21:43", nankouStopTime: "21:15", badalingStopTime: "20:27", yanqingStopTime: "20:03", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 228, northBound: false, runsOnWeekday: false)
        ,train(huangtudianStopTime:"22:46", nankouStopTime: "22:03", badalingStopTime: "21:19", yanqingStopTime: "21:04", kangzhuangStopTime: "na",shachengStopTime:"na", trainNumber: 232, northBound: false, runsOnWeekday: true)
    ]
    
    
    var displayTable = [train]()
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayTable.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.startPlace.text = self.startPlace
        switch(startPlace){
            case "Huangtudian":
                cell.startTime.text = displayTable[indexPath.row].huangtudianStopTime
            case "Nankou":
                cell.startTime.text = displayTable[indexPath.row].nankouStopTime
            case "Badaling":
                cell.startTime.text = displayTable[indexPath.row].badalingStopTime
            case "Yanqing":
                cell.startTime.text = displayTable[indexPath.row].yanqingStopTime
            case "Kangzhuang":
                cell.startTime.text = displayTable[indexPath.row].kangzhuangStopTime
            case "Shacheng":
                cell.startTime.text = displayTable[indexPath.row].shachengStopTime
            default:
                break
            }
        cell.endPlace.text = self.destinationPlace
        switch(destinationPlace){
            case "Huangtudian":
                cell.endTime.text = displayTable[indexPath.row].huangtudianStopTime
            case "Nankou":
                cell.endTime.text = displayTable[indexPath.row].nankouStopTime
            case "Badaling":
                cell.endTime.text = displayTable[indexPath.row].badalingStopTime
            case "Yanqing":
                cell.endTime.text = displayTable[indexPath.row].yanqingStopTime
            case "Kangzhuang":
                cell.endTime.text = displayTable[indexPath.row].kangzhuangStopTime
            case "Shacheng":
                cell.endTime.text = displayTable[indexPath.row].shachengStopTime
            default:
                break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    let initialLoc = CLLocation(latitude: 40.070324, longitude: 116.362532)
    let regionRadius:CLLocationDistance = 1000
    let huangtudianStationCoodrinate = CLLocationCoordinate2D(latitude: 116.369918, longitude: 40.076255)
    let nankouStationCoordinate = CLLocationCoordinate2D(latitude: 116.135548, longitude: 40.24564)
    let badalingStationCoordinate = CLLocationCoordinate2D(latitude: 116.008134, longitude: 40.365971)
    let yanqingStationCoordinate = CLLocationCoordinate2D(latitude: 115.990909, longitude: 40.441915)
    let shachengStationCoordinate = CLLocationCoordinate2D(latitude: 115.522519, longitude: 40.403056)
    
    
    @IBOutlet weak var transitMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue):#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        
        
        self.weekDay = self.getDate()
        switch weekDay {
        case 3...5:
            for trains in timeTable{
                if trains.runsOnWeekday == true{
                    displayTable.append(trains)
                }
            }
        case 1,2,6,7:
            displayTable = timeTable
        default:
            break
        }
        
        buttonList = [htdBtn,nkBtn,bdlBtn,yqBtn,scBtn]
        self.updateDisplayTable(strt: startPlace, dest: destinationPlace, northBound: true)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        transitMapView.centerCoordinate = CLLocationCoordinate2D(latitude: 39.1, longitude: 116.2)
        transitMapView.showsScale = true
        transitMapView.showsPointsOfInterest = true
        transitMapView.showsUserLocation = true
        self.centerMapOnLoc(location: initialLoc)
        
    }
    
    func getDate() -> Int{
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.weekday, from: date)
        
        return component
    }
    
    func northBoundCheck(start:String,end:String) -> Bool{
        var startPos = 0
        var endPos = 0
        var retValue = true
        
        for index in 0...5{
            if stationArray[index] == start{
                startPos = index
            }
        }
        
        for index in 0...5{
            if stationArray[index] == end{
                endPos = index
            }
        }
        
        if startPos >= endPos{
            retValue = false
        }
        
        return retValue
    }
    
    func updateDisplayTable(strt:String,dest:String,northBound:Bool){
        var originalArray = [train]()
        var trainArray = [train]()
        var displayArray = [train]()
        
        if northBound == true{
            for trains in timeTable{
                if trains.northBound == true{
                    originalArray.append(trains)
                }
            }
        }else{
            for trains in timeTable{
                if trains.northBound == false{
                    originalArray.append(trains)
                }
            }
        }
        
        for trains in originalArray{
            switch strt{
                case "Huangtudian":
                    if trains.huangtudianStopTime != "na"{
                        trainArray.append(trains)
                    }
                case "Nankou":
                    if trains.nankouStopTime != "na"{
                        trainArray.append(trains)
                    }
                case "Badaling":
                    if trains.badalingStopTime != "na"{
                        trainArray.append(trains)
                    }
                case "Yanqing":
                    if trains.yanqingStopTime != "na"{
                        trainArray.append(trains)
                    }
                case "Kangzhuang":
                    if trains.kangzhuangStopTime != "na"{
                        trainArray.append(trains)
                    }
                case "Shacheng":
                    if trains.shachengStopTime != "na"{
                        trainArray.append(trains)
                    }
            default:
                break
            }
        }
        
        for trainSnd in trainArray{
            switch dest{
            case "Huangtudian":
                if trainSnd.huangtudianStopTime != "na"{
                    displayArray.append(trainSnd)
                }
            case "Nankou":
                if trainSnd.nankouStopTime != "na"{
                    displayArray.append(trainSnd)
                }
            case "Badaling":
                if trainSnd.badalingStopTime != "na"{
                    displayArray.append(trainSnd)
                }
            case "Yanqing":
                if trainSnd.yanqingStopTime != "na"{
                    displayArray.append(trainSnd)
                }
            case "Kangzhuang":
                if trainSnd.kangzhuangStopTime != "na"{
                    displayArray.append(trainSnd)
                }
            case "Shacheng":
                if trainSnd.shachengStopTime != "na"{
                    displayArray.append(trainSnd)
                }
            default:
                break
            }
        }
        displayTable = displayArray
        self.tableView.reloadData()
    }
    
    
    func enableAllBtns(btnArray:[UIButton]){
        let btnArray = [htdBtn,nkBtn,bdlBtn,yqBtn,scBtn]
        for b in btnArray{
            if b?.isEnabled == false{
                b?.isEnabled = true
            }
        }
    }
    
    func eraseAllBtns(btnArray:[UIButton]){
        for index in btnArray{
            index.setTitle("", for: .normal)
        }
    }
    
    func buttonAction(button:UIButton){
        var place = ""

        switch button{
        case htdBtn:
            place = "Huangtudian"
        case nkBtn:
            place = "Nankou"
        case bdlBtn:
            place = "Badaling"
        case yqBtn:
            place = "Yanqing"
        case kzBtn:
            place = "Kangzhuang"
        default:
            place = "na"
        }
        if firstTouch == true{
            eraseAllBtns(btnArray: buttonList)
            startPlace = place
            button.setTitle("From", for: .normal)
            firstTouch = false
            button.isEnabled = false
        }else{
            destinationPlace = place
            button.setTitle("To", for: .normal)
            firstTouch = true
            updateDisplayTable(strt: startPlace, dest: destinationPlace, northBound: northBoundCheck(start: startPlace, end: destinationPlace))
            enableAllBtns(btnArray: buttonList)
        }
    }
    
    
    
    func centerMapOnLoc(location:CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        transitMapView.setRegion(coordinateRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail"{
            let destVC = segue.destination as! DetailTableViewController
            destVC.trainNumber = displayTable[(tableView.indexPathForSelectedRow?.row)!].trainNumber
        }
        
        
     }
    
    

    
    
    @IBAction func htdBtnAction(_ sender: UIButton) {
        buttonAction(button: htdBtn)
        
    }
    
    
    @IBAction func nkBtnAction(_ sender: UIButton) {
        buttonAction(button: nkBtn)
    }
    
    
    @IBAction func bdlBtnAction(_ sender: UIButton) {
        buttonAction(button: bdlBtn)
    }
    
    
    @IBAction func yqBtnAction(_ sender: UIButton) {
        buttonAction(button: yqBtn)
    }
    
    
    @IBAction func kzBtnAction(_ sender: UIButton) {
        buttonAction(button: kzBtn)
    }
    
    @IBAction func scBtnAction(_ sender: UIButton) {
        buttonAction(button: scBtn)
    }
}

