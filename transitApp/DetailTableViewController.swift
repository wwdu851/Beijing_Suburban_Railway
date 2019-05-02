//
//  DetailTableViewController.swift
//  transitApp
//
//  Created by William Du on 2017/8/4.
//  Copyright © 2017年 William Du. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var trainNumber = 203
    var start = "Huangtudian"
    var destination = "Yanqing"
    var startTime = 0
    var destinationTime = 0

    var stationList = [Stop]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.title = NSLocalizedString("Train Number: S", comment: "TRAIN NUMBER") + String(trainNumber) + NSLocalizedString(" ", comment: "CI")
        let tempStation = ScheduleInit.trainInfoWithNumber(trainNumber: trainNumber, from: start, to: destination)
        for eachStation in tempStation{
            if eachStation.stopsAt!.stationName == start{
                startTime = Int((eachStation.hour * 60) + (eachStation.minute))
            }
            
            if eachStation.stopsAt!.stationName == destination{
                destinationTime = Int((eachStation.hour * 60) + (eachStation.minute))
            }
        }

        for index in 0...(tempStation.count - 1){
            if ((tempStation[index].hour * 60) + (tempStation[index].minute)) >= startTime && ((tempStation[index].hour * 60) + (tempStation[index].minute)) <= destinationTime{
                stationList.append(tempStation[index])
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stationList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailCell
        cell.timePlace.text = "\(NSLocalizedString(self.stationList[indexPath.row].stopsAt!.stationName!, comment: "列车信息")) \(String(self.stationList[indexPath.row].hour)):\(timeLikeDigit(number: Int(self.stationList[indexPath.row].minute)))"
        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func timeLikeDigit(number:Int) -> String{
        if number < 10{
            return "0\(String(number))"
        }else{
            return String(number)
        }
    }

}
