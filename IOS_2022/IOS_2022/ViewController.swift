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
    var models = [MedTermin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    @IBAction func didTapAdd(){
        // show add
    }
    
    @IBAction func didTapNotification(){
        // show notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                //schedule notification
                self.scheduleNotification()
            }
            else if let error = error {
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

struct MedTermin{
    let title: String
    let date: Date
    let identifier: String
}
