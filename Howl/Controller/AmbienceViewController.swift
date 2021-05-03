//
//  AmbienceViewController.swift
//  Howl
//
//  Created by Roshani Ayu Pranasti on 03/05/21.
//

import UIKit

class AmbienceViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var characterImage: UIImageView!
    
    var ambiences: [Song] = []
    var selectedAmbience: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustBackground()
    }
    
    func adjustBackground() {
        let ambience = selectedAmbience[0]
        backgroundImage.image = UIImage(named: ambience.background!)
        characterImage.image = UIImage(named: ambience.character!)
        
        if ambience.title == "Merry Go Round of Life" {
            backgroundImage.frame = CGRect(x: -1, y: 589, width: 392, height: 528)
            characterImage.frame = CGRect(x: -1, y: 617, width: 392, height: 518)
        } else if ambience.title == "Path of the Wind" {
            backgroundImage.frame = CGRect(x: -1, y: 470, width: 392, height: 528)
            characterImage.frame = CGRect(x: -1, y: 570, width: 392, height: 518)
        } else if ambience.title == "The Name of Life" {
            backgroundImage.frame = CGRect(x: -1, y: 530, width: 392, height: 528)
            characterImage.frame = CGRect(x: -1, y: 565, width: 392, height: 518)
        }
    }

    @IBAction func closeSetAmbience(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension AmbienceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ambiences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ambienceCell", for: indexPath) as! AmbienceTableViewCell
        let ambience = ambiences[indexPath.row]
        cell.titleLabel.text = ambience.title
        tableView.separatorColor = UIColor(red: 0.68, green: 0.69, blue: 0.65, alpha: 1.0)
        tableView.tableFooterView = UIView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let ambience = ambiences[indexPath.row]
        if selectedAmbience[0].title == ambience.title {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0 ... ambiences.count-1 {
            if i == indexPath.row {
                ambiences[indexPath.row].selected = true
            } else {
                ambiences[i].selected = false
            }
        }
        
        let ambience = ambiences[indexPath.row]
        selectedAmbience[0] = ambience
        
        adjustBackground()
    }
}
