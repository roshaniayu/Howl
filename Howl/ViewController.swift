//
//  ViewController.swift
//  Howl
//
//  Created by Roshani Ayu Pranasti on 29/04/21.
//

import AVFoundation
import CoreData
import UIKit

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var timerPicker: UIPickerView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countdownView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    let userDefaultsValue = UserDefaults.standard.getValueLoad()
    let pickerWidth: CGFloat = 62
    let pickerHeight: CGFloat = 80
    var rotationAngle: CGFloat!
    var times: [Time] = []
    var songs: [Song] = []
    var selectedTime: Int = 299
    var selectedSong: [Song] = []
    var timer: Timer?
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        // timerPicker modification
        rotationAngle = -90 * (.pi/180)
        timerPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        timerPicker.frame = CGRect(x: 64, y: 300, width: 260, height: pickerWidth)
        self.view.addSubview(timerPicker)
        
        // timerView modification
        timerView.layer.cornerRadius = 22
        
        generateTime()
        loadSongsData()
    }
    
    func generateTime() {
        times.append(Time(timeType: .fiveMins, timeName: "5 mins", timeDuration: 299))
        times.append(Time(timeType: .tenMins, timeName: "10 mins", timeDuration: 599))
        times.append(Time(timeType: .fifteenMins, timeName: "15 mins", timeDuration: 899))
        times.append(Time(timeType: .thirtyMins, timeName: "30 mins", timeDuration: 1799))
        times.append(Time(timeType: .fortyfiveMins, timeName: "45 mins", timeDuration: 2699))
        times.append(Time(timeType: .oneHour, timeName: "1 hour", timeDuration: 3599))
    }
    
    func getCoreDataContainer() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveItem(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Error saving content: \(error)")
        }
    }
    
    func fetchItem(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Song>) {
        do {
            selectedSong = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    func adjustBackground() {
        let song = selectedSong[0]
        backgroundImage.image = UIImage(named: song.background!)
        characterImage.image = UIImage(named: song.character!)
        
        if song.title == "Path of the Wind" {
            backgroundImage.frame = CGRect(x: -1, y: 370, width: 392, height: 528)
            characterImage.frame = CGRect(x: -1, y: 480, width: 392, height: 518)
        } else if song.title == "The Name of Life" {
            backgroundImage.frame = CGRect(x: -1, y: 410, width: 392, height: 528)
            characterImage.frame = CGRect(x: -1, y: 445, width: 392, height: 518)
        }
        
        playButton.layer.zPosition = 1
        historyButton.layer.zPosition = 1
        setButton.layer.zPosition = 1
    }
    
    func insertItem(audio: String, background: String, character: String, selected: Bool, title: String) {
        let context = getCoreDataContainer()
        let newSong = Song(context: context)
        newSong.audio = audio
        newSong.background = background
        newSong.character = character
        newSong.selected = selected
        newSong.title = title
        
        songs.append(newSong)
        saveItem(context: context)
    }
    
    func loadAmbience() {
        let context = getCoreDataContainer()
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        let selectedSong = NSPredicate(format: "selected == %d", true)
        
        fetchRequest.predicate = selectedSong
        fetchItem(context: context, fetchRequest: fetchRequest)
        adjustBackground()
    }
    
    func loadSongsData() {
        if userDefaultsValue == nil {
            insertItem(audio: "merry_go_round_of_life", background: "mountain", character: "howl_and_sophie", selected: true, title: "Merry Go Round of Life")
            insertItem(audio: "kaze_no_toori_michi", background: "rain", character: "totoro", selected: false, title: "Path of the Wind")
            insertItem(audio: "inochi_no_namae", background: "clouds", character: "spirited_away", selected: false, title: "The Name of Life")
            
            UserDefaults.standard.setValueLoad(value: true)
        }
        
        loadAmbience()
    }
    
    func configureInterface() {
        headerLabel.text = "Have a great sleep"
        descriptionLabel.text = "Once upon a time th..e.... a.. zzzzzzzzz..."
        descriptionLabel.frame = CGRect(x: 97, y: 223, width: 197, height: 48)
        descriptionLabel.numberOfLines = 2
        timerPicker.isHidden = true
        timerView.isHidden = true
        historyButton.isHidden = true
        setButton.isHidden = true
        playButton.setImage(UIImage(named: "icon_stop"), for: .normal)
        countdownView.layer.cornerRadius = 19
        countdownView.isHidden = false
        countdownLabel.text = formatTimer(selectedTime)
    }
    
    func formatTimer(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds/60) % 60
        
        return String(format: "-%02d:%02d", minutes, seconds)
    }
    
    @objc func updateTimer() {
        countdownLabel.text = formatTimer(selectedTime)
        
        if selectedTime != 0 {
            selectedTime -= 1
        } else {
            if let timer = timer {
                timer.invalidate()
                self.timer = nil
            }
            if let player = player {
                player.stop()
                self.player = nil
            }
        }
    }
    
    func configureTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func configureSong() {
        let song = selectedSong[0]
        let urlString = Bundle.main.path(forResource: song.audio, ofType: "m4a")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            guard let urlString = urlString else {
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            guard let player = player else {
                return
            }
            
            player.delegate = self
            player.play()
        } catch {
            print("Error playing the song: \(error)")
        }
    }
    
    @IBAction func playSong(_ sender: UIButton) {
        configureInterface()
        configureTimer()
        configureSong()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if selectedTime != 0 && flag == true {
            player.play()
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight)
        label.textAlignment = .center
        label.font = UIFont(name: "NunitoSans-Regular.ttf", size: 17)
        label.textColor = UIColor(red: 0.82, green: 0.82, blue: 0.80, alpha: 1.0)
        label.text = times[row].name
        view.addSubview(label)
        
        rotationAngle = 90 * (.pi/180)
        view.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedRow = times[row]
        selectedTime = selectedRow.duration!
    }
}
