//
//  ViewController.swift
//  IOS_2022
//
//  Created by Albina on 26.10.22.
//

import UserNotifications
import UIKit

class ViewController: UIViewController {

    //ADD Outlet for table
    @IBOutlet var table: UITableView!
    //Create an array - model hold MedAppointment and start off empty
    var models = [MedAppointment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set delegate and set data source
        table.delegate = self
        table.dataSource = self
    }
    
    //Action show add
    @IBAction func didTapAdd(){
        //Show AddViewController file
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else{
            return
        }
        
        //Add title
        vc.title = "New Appointment"
        vc.navigationItem.largeTitleDisplayMode = .never
        //If recall, takes title, body and date
        vc.completion = {title, body, date in
            //Dismiss add controller
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                //Create new struck MedAppointment, takes title, date and identifier( tag title as identifier)
                let new = MedAppointment(title: title, date: date, identifier: "id_\(title)")
                //Add new variable to Models
                //Add new Appointment
                self.models.append(new)
                self.table.reloadData()
                
                //Send to user which is request a notification be added a notification itself
                let content = UNMutableNotificationContent()
                //Content parameter
                content.title = title
                content.sound = .default
                content.body = body
                
                // Current date
                let targetDate = date
                //Date to send notification
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                //Create a request
                let request = UNNotificationRequest(identifier: "ID", content: content, trigger: trigger)
                //Schedule the actual notification
                UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in  if (error != nil) {
                    print("Something went wrong")
                }})
                
            }
        }
        //Present the actual controller
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //Action show notification
    @IBAction func didTapNotification(){
        //Request the premission for implement
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                //Schedule notification
                self.scheduleNotification()
            }
            else if (error != nil) {
                print("error occurred")
            }
        })
    }
    
    //Schedule a notification
    func scheduleNotification(){
        //Send to user which is request a notification be added a notification itself
        let content = UNMutableNotificationContent()
        //Content parameter
        content.title = "Termini i caktuar"
        content.sound = .default
        content.body = "Termini i caktuar per diten e sotme. MOS HARRONI KENI TERMIN SOT!!!!"
        
        // Current date
        let targetDate = Date().addingTimeInterval(15)
        //Date to send notification
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        
        //Create a request
        let request = UNNotificationRequest(identifier: "ID", content: content, trigger: trigger)
        //Schedule the actual notification
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in  if (error != nil) {
            print("Something went wrog")
        }})
    }

}

//Implement basic table view functions
extension ViewController: UITableViewDelegate{
    //Select row, select one with an animation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: IndexPath(), animated: true)
    }
}

extension ViewController: UITableViewDataSource{
    //Number of sections which is gonna be one
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //Number of rows which is gonna be the number of models
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    //Cell for row at index path a DequeueReusableCell a cell on the table view with a given identifier "cell"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath())
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        //Formatte text
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM YYYY"
                cell.detailTextLabel?.text = formatter.string(from: date)

                cell.textLabel?.font = UIFont(name: "Times New Roman", size: 25)
                cell.detailTextLabel?.font = UIFont(name: "Times New Roman", size: 20)
        return cell
    }
}

//Hold MedAppointment objects, create a struct with title, date and indentifier
struct MedAppointment{
    let title: String
    let date: Date
    let identifier: String
}
