//
//  ViewController.swift
//  IOS_2022
//
//  Created by Ardit on 26.10.22.
//

import UserNotifications
import UIKit

class ViewController: UIViewController {

    @IBOutlet var table: UITableView!
    var models = [MedAppointment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    @IBAction func didTapAdd(){
        // show add
        guard let vc = storyboard?.instantiateViewController(identifier: "Add") as? AddViewController else{
            return
        }
        
        vc.title = "New Appointment"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {title, doc, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MedAppointment(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.table.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "ID", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in  if (error != nil) {
                    print("Something went wrog")
                }})
                
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapNotification(){
        // show notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                //schedule notification
                self.scheduleNotification()
            }
            else if (error != nil) {
                print("error occurred")
            }
        })
    }
    
    func scheduleNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Termini i caktuar"
        content.sound = .default
        content.body = "Termini i caktuar per diten e sotme. MOS HARRONI KENI TERMIN SOT!!!!"
        
        let targetDate = Date().addingTimeInterval(15)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "ID", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in  if (error != nil) {
            print("Something went wrog")
        }})
    }

}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: IndexPath(), animated: true)
    }
}

extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath())
        cell.textLabel?.text = models[IndexPath().row].title
        
        return cell
    }
}

struct MedAppointment{
    let title: String
    let date: Date
    let identifier: String
}
