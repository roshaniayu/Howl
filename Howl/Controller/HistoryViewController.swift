//
//  HistoryViewController.swift
//  Howl
//
//  Created by Roshani Ayu Pranasti on 26/05/21.
//

import FSCalendar
import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendar()
    }
    
    func setupCalendar() {
        calendar.scope = .week
        calendar.select(calendar.today)
        calendar.customizeCalenderAppearance()
    }
    
//    func formatDate() -> DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy"
//
//        return formatter
//    }
//
//    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        let formatter = formatDate()
//        let string = formatter.string(from: date)
//        print("\(string)")
//    }
}

extension FSCalendar {
    
    func customizeCalenderAppearance() {
        self.appearance.headerTitleFont = UIFont(name: "NunitoSans-Regular", size: 13)
        self.appearance.weekdayFont = UIFont(name: "NunitoSans-Regular", size: 13)
        self.appearance.titleFont = UIFont(name: "NunitoSans-Regular", size: 17)
        
        self.appearance.borderRadius = 0.4
    }
    
}
