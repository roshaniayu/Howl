//
//  SessionFinishedViewController.swift
//  Howl
//
//  Created by Roshani Ayu Pranasti on 03/05/21.
//

import UIKit

class SessionFinishedViewController: UIViewController {

    @IBOutlet weak var durationLabel: UILabel!
    
    var durationTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        durationLabel.text = durationTime
    }
    
    @IBAction func closeSessionFinished(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
