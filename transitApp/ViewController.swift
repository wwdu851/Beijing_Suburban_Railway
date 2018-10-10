//
//  ViewController.swift
//  transitApp
//
//  Created by William Du on 2017/7/25.
//  Copyright © 2017年 William Du. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var weekDay = 0
    var startPlace = "Huangtudian"
    var destinationPlace = "Yanqing"
    var trainDirection = "North"
    var firstTouch = true
    let stationArray = ["Huangtudian","Nankou","Badaling","Yanqing","Kangzhuang","Shacheng"]
    let colorArray = [#colorLiteral(red: 0.889842689, green: 0.8887065053, blue: 0.9715638757, alpha: 0.2662403682),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
    
    
    @IBOutlet weak var weekday_outlet_1: UIButton!
    
    @IBOutlet weak var weekday_outlet_2: UIButton!
    
    @IBOutlet weak var weekday_outlet_3: UIButton!
    
    @IBOutlet weak var weekday_outlet_4: UIButton!
    
    @IBOutlet weak var weekday_outlet_5: UIButton!
    
    @IBOutlet weak var weekday_outlet_6: UIButton!
    
    @IBOutlet weak var weekday_outlet_7: UIButton!
    
    


    var displayTable = [Train_run]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayTable.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        cell.backgroundColor = colorArray[(indexPath.row % 2)]
        cell.startPlace.text = self.startPlace
        cell.endPlace.text = self.destinationPlace
        var timeStart = "00:00"
        var timeEnd = "00:00"
        let stopsForRow = displayTable[indexPath.row].hasStops?.allObjects as! [Stop]
        for eachStop in stopsForRow{
            if eachStop.stopsAt!.stationName! == self.startPlace{
                timeStart = "\(String(eachStop.hour)):\(timeLikeDigit(number: Int(eachStop.minute)))"
            }else{
                if eachStop.stopsAt!.stationName! == self.destinationPlace{
                    timeEnd = "\(String(eachStop.hour)):\(timeLikeDigit(number: Int(eachStop.minute)))"
                }
            }
        }
        cell.startTime.text = timeStart
        cell.endTime.text = timeEnd

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
    
    
    let locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        
        displayTable = ScheduleInit.allTrainAfterTime(hour: 0, minute: 0, onLine: "S2", weekDay: isWeekday(), atStation: startPlace, direction: trainDirection, headTo: destinationPlace)
    }
    
    func timeLikeDigit(number:Int) -> String{
        if number < 10{
            return "0\(String(number))"
        }else{
            return String(number)
        }
    }
    
    func isWeekday() -> Bool{
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.weekday, from: date)
        var returnValue = false
        switch component {
        case 3...5:
            returnValue = true
        default:
            returnValue = false
        }
        return returnValue
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func weeday_button_1(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    @IBAction func weekday_button_2(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    @IBAction func weekday_button_3(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    @IBAction func weekday_button_4(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    @IBAction func weekday_buton_5(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    @IBAction func weekday_button_6(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    @IBAction func weekday_buton_7(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    
    
    // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let destVC = segue.destination as! DetailTableViewController
            destVC.trainNumber = Int(displayTable[(tableView.indexPathForSelectedRow?.row)!].trainNumber)
            destVC.start = self.startPlace
            destVC.destination = self.destinationPlace
        }
     }
    
}

