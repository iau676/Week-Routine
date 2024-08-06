//
//  NotificationManager.swift
//  Week Routine
//
//  Created by ibrahim uysal on 13.06.2023.
//

import UIKit

struct NotificationManager {
        
    static var shared = NotificationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
        
    func askNotificationPermission(){
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (permissionGranted, error) in
            UDM.version12.set(true)
            if(!permissionGranted){
                print("Permission Denied")
            }
        }
    }
    
    func getColorEmoji(_ colorName: String) -> String {
        switch colorName {
        case ColorName.red:    return "🔴 "
        case ColorName.orange: return "🟠 "
        case ColorName.yellow: return "🟡 "
        case ColorName.green:  return "🟢 "
        case ColorName.blue:   return "🔵 "
        case ColorName.purple: return "🟣 "
        default:               return ""
        }
    }
    
    func getNotificationSound(soundInt: Int) -> UNNotificationSound? {
        switch soundInt {
        case 0:
            return UNNotificationSound.default
        case 6:
            return nil
        default:
            return UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sounds[soundInt]).m4a"))
        }
    }
    
    func addNotification(title: String, dayInt: Int, hour: Int, minute: Int, color: String, soundInt: Int, id: String) {
        DispatchQueue.main.async{
            let emoji = getColorEmoji(color)
            let title = "\(emoji)\(title)"
            let message = ""
            var date = DateComponents()

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = message
            content.sound = getNotificationSound(soundInt: soundInt)
            
            switch dayInt {
                case 7:
                    date = DateComponents(hour: hour, minute: minute)
                    addNotificationCenter(date: date, content: content, id: id)
                break
                case 8:
                    for i in 2...6 {
                        date = DateComponents(hour: hour, minute: minute, weekday: i)
                        addNotificationCenter(date: date, content: content, id: "\(id)wr\(i)")
                    }
                break
                case 9:
                    date = DateComponents(hour: hour, minute: minute, weekday: 7)
                    addNotificationCenter(date: date, content: content, id: "\(id)wr7")
                    date = DateComponents(hour: hour, minute: minute, weekday: 1)
                    addNotificationCenter(date: date, content: content, id: "\(id)wr1")
                break
                default:
                    let weekday = (dayInt+2 > 7) ? 1 : dayInt+2
                    date = DateComponents(hour: hour, minute: minute, weekday: weekday)
                    addNotificationCenter(date: date, content: content, id: id)
                break
            }
        }
    }
    
    func addNotificationCenter(date: DateComponents, content: UNMutableNotificationContent, id: String){
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let id = id
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                    
        self.notificationCenter.add(request) { (error) in
            if(error != nil){
                print("Error " + error.debugDescription)
                return
            }
        }
    }
    
    func removeNotification(id: String) {
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func updateRoutineNotification(routine: Routine) {
        if routine.isNotify {
            guard let title = routine.title else{return}
            guard let uuid = routine.uuid else{return}
            
            removeNotification(id: uuid)
            addNotification(title: title, dayInt: Int(routine.day),
                            hour: Int(routine.hour), minute: Int(routine.minute),
                            color: routine.color ?? "", soundInt: Int(routine.soundInt),
                            id: uuid)
        }
    }
    
    func deleteNotification(routine: Routine) {
        guard let uuid = routine.uuid else { return }
        let dayInt = routine.day
        switch dayInt {
            case 8:
            removeNotification(id: "\(uuid)wr2")
            removeNotification(id: "\(uuid)wr3")
            removeNotification(id: "\(uuid)wr4")
            removeNotification(id: "\(uuid)wr5")
            removeNotification(id: "\(uuid)wr6")
            case 9:
            removeNotification(id: "\(uuid)wr7")
            removeNotification(id: "\(uuid)wr1")
            default:
            removeNotification(id: uuid)
        }
    }
}
