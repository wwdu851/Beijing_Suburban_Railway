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
        if displayTable.isEmpty == true{
            return 1
        }else{
            return displayTable.count
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if displayTable.isEmpty == false{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
            cell.backgroundColor = colorArray[(indexPath.row % 2)]
            cell.startPlace.text = NSLocalizedString(self.startPlace, comment: "qidian")
            cell.endPlace.text = NSLocalizedString(self.destinationPlace, comment: "zhongdian")
            cell.priceLabel.text = ScheduleInit.calculatePrice(from: self.startPlace, to: self.destinationPlace)
            var timeStart = "00:00"
            var timeEnd = "00:00"
            var startHr = 0
            var startMin = 0
            var endHr = 0
            var endMin = 0
            let stopsForRow = displayTable[indexPath.row].hasStops?.allObjects as! [Stop]
            for eachStop in stopsForRow{
                if eachStop.stopsAt!.stationName! == self.startPlace{
                    timeStart = "\(String(eachStop.hour)):\(timeLikeDigit(number: Int(eachStop.minute)))"
                    startHr = Int(eachStop.hour)
                    startMin = Int(eachStop.minute)
                    
                }else{
                    if eachStop.stopsAt!.stationName! == self.destinationPlace{
                        timeEnd = "\(String(eachStop.hour)):\(timeLikeDigit(number: Int(eachStop.minute)))"
                        endHr = Int(eachStop.hour)
                        endMin = Int(eachStop.minute)
                    }
                }
            }
            cell.startTime.text = timeStart
            cell.endTime.text = timeEnd
            cell.rideDuration.text = getDuration(startTimeHour: startHr, startTimeMinute: startMin, endTimeHour: endHr, endTimeMinute: endMin)

            return cell
        }else{
            let emptyCell = tableView.dequeueReusableCell(withIdentifier: "NoResultCell", for: indexPath)
             return emptyCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.navigationItem.title = NSLocalizedString("Schedule", comment: "Train Schedule")
        todayButtonDark()

        displayTable = ScheduleInit.allTrainAfterTime(hour: 0, minute: 0, onLine: "S2", weekDay: isWeekday(), atStation: startPlace, direction: trainDirection, headTo: destinationPlace)
        print(displayTable.isEmpty)
    }
    
    func refreshTrainData(day:Int){
        displayTable = ScheduleInit.allTrainAfterTime(hour: 0, minute: 0, onLine: "S2", weekDay: day, atStation: startPlace, direction: trainDirection, headTo: destinationPlace)
        self.tableView.reloadData()
    }
    
    func timeLikeDigit(number:Int) -> String{
        if number < 10{
            return "0\(String(number))"
        }else{
            return String(number)
        }
    }
    
    func getDuration(startTimeHour:Int,startTimeMinute:Int,endTimeHour:Int,endTimeMinute:Int) -> String{
        let startTotal:Int = startTimeHour * 60 + startTimeMinute
        let endTotal:Int = endTimeHour * 60 + endTimeMinute
        let durationTotal:Int = endTotal - startTotal
        let durationHour:Int = durationTotal / 60
        let durationMinute:Int = durationTotal % 60
        let hourText = NSLocalizedString("hr", comment: "hour")
        let minuteText = NSLocalizedString("min", comment: "minute")
        var returnString = ""
        
        if durationHour == 0{
            returnString = String(durationMinute) + " " + minuteText
        }else{
            returnString = String(durationHour) + " " + hourText + " " + String(durationMinute) + " " + minuteText
        }
        
        return returnString
    }
    
    func isWeekday() -> Int{
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.weekday, from: date)
        let returnValue = component
        return returnValue
    }
    
    func weekDaySelectionCheckWeekday(weekday:Int) -> Bool{
        var returnValue = false
        switch weekday {
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
        sender.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        let weekDayOutlet = [weekday_outlet_2,weekday_outlet_3,weekday_outlet_4,weekday_outlet_5,weekday_outlet_6,weekday_outlet_7]
        for each in weekDayOutlet{
            each?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        refreshTrainData(day: 1)
    }
    
    @IBAction func weekday_button_2(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        let weekDayOutlet = [weekday_outlet_1,weekday_outlet_3,weekday_outlet_4,weekday_outlet_5,weekday_outlet_6,weekday_outlet_7]
        for each in weekDayOutlet{
            each?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        refreshTrainData(day: 2)

    }
    
    @IBAction func weekday_button_3(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        let weekDayOutlet = [weekday_outlet_1,weekday_outlet_2,weekday_outlet_4,weekday_outlet_5,weekday_outlet_6,weekday_outlet_7]
        for each in weekDayOutlet{
            each?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        refreshTrainData(day: 3)
    }
    
    @IBAction func weekday_button_4(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        let weekDayOutlet = [weekday_outlet_1,weekday_outlet_2,weekday_outlet_3,weekday_outlet_5,weekday_outlet_6,weekday_outlet_7]
        for each in weekDayOutlet{
            each?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        refreshTrainData(day: 4)
    }
    
    @IBAction func weekday_buton_5(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        let weekDayOutlet = [weekday_outlet_1,weekday_outlet_2,weekday_outlet_3,weekday_outlet_4,weekday_outlet_6,weekday_outlet_7]
        for each in weekDayOutlet{
            each?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        refreshTrainData(day: 5)
    }
    
    @IBAction func weekday_button_6(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        let weekDayOutlet = [weekday_outlet_1,weekday_outlet_3,weekday_outlet_4,weekday_outlet_5,weekday_outlet_2,weekday_outlet_7]
        for each in weekDayOutlet{
            each?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        refreshTrainData(day: 6)
    }
    
    @IBAction func weekday_buton_7(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        let weekDayOutlet = [weekday_outlet_1,weekday_outlet_3,weekday_outlet_4,weekday_outlet_5,weekday_outlet_6,weekday_outlet_2]
        for each in weekDayOutlet{
            each?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        refreshTrainData(day: 7)
    }
    
    
    func todayButtonDark(){
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.weekday, from: date)
        print("today is \(component)")
        switch component {
        case 1:
            weekday_outlet_1.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        case 2:
            weekday_outlet_2.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        case 3:
            weekday_outlet_3.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        case 4:
            weekday_outlet_4.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        case 5:
            weekday_outlet_5.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        case 6:
            weekday_outlet_6.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        case 7:
            weekday_outlet_7.backgroundColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        default:
            break
        }
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

