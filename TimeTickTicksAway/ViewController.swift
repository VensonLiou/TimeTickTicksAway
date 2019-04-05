//
//  ViewController.swift
//  TimeTickTicksAway
//
//  Created by 劉玟慶 on 2019/4/4.
//  Copyright © 2019 劉玟慶. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var currentSpeedLabel: UILabel!
    @IBOutlet weak var currentTimePointLabel: UILabel!
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var timePointSlider: UISlider!
    @IBOutlet weak var reverseSwitch: UISwitch!
    @IBOutlet weak var loopSwitch: UISwitch!
    @IBOutlet weak var replay: UIButton!
    
    private var autoplayState = true
    private var loopState = true
    private var reverseState = false
    private var speed: Float = 1.0
    private var year:Int = 2003
    private var month:Int = 1
    private var defalutPlayIntervel = 0.25 // default time interval = 0.25 sec
    private var imgList = [String]() // empty String array for storing image names
    private let dateFormatter = DateFormatter()
    private var timer: Timer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "yyyy/MM/dd"
        for year in 0...15 // append image name to imgList
        {
            for month in 1...12
            {
                imgList.append(String(year) + "yo" + String(month))
            }
        }
        // initial autoplay is on, start autoplay
        timer=Timer.scheduledTimer(withTimeInterval: defalutPlayIntervel / Double(speed), repeats: true){(timer) in self.displayNextImage()}
    }

    @IBAction func autoplaySwitch(_ sender: UISwitch)
    {
        if sender.isOn
        {
            timer?.invalidate()
            timer=Timer.scheduledTimer(withTimeInterval: defalutPlayIntervel / Double(speed), repeats: true){(timer) in self.displayNextImage()}
            speedSlider.isEnabled = true
            reverseSwitch.isEnabled = true
            loopSwitch.isEnabled = true
            autoplayState = true
            
        }
        else
        {
            timer?.invalidate()
            speedSlider.isEnabled = false
            reverseSwitch.isEnabled = false
            loopSwitch.isEnabled = false
            autoplayState = false
        }
    }
    @IBAction func LoopSwitch(_ sender: UISwitch)
    {
        if sender.isOn
        {
            loopState = true
        }
        else
        {
            loopState = false
        }
    }
    @IBAction func reverseSwitch(_ sender: UISwitch)
    {
        if sender.isOn
        {
            reverseState = true
        }
        else
        {
            reverseState = false
        }
    }
    @IBAction func replayButton(_ sender: UIButton)
    {
        if autoplayState
        {
            if reverseState
            {
                year = 2018
                month = 12
                updateAllDate(year: year, month: month, day: 31)
            }
            else
            {
                year = 2003
                month = 1
                updateAllDate(year: year, month: month, day: 1)
            }
        }
        else
        {
            year = 2003
            month = 1
            updateAllDate(year: year, month: month, day: 1)
        }
    }
    @IBAction func changeValueDateSlider(_ sender: UISlider)
    {
        year = Int(timePointSlider.value)
        month = 1 + ((Int(timePointSlider.value * 1000)) % 1000) / 84
        updateAllDate(year: year, month: month, day: Int.random(in: 1...28))
    }
    @IBAction func changeValueSpeedSlider(_ sender: UISlider)
    {
        speed = pow(2,speedSlider.value)
        currentSpeedLabel.text = String(format: "%.2fx", speed)
        timer?.invalidate()
        timer=Timer.scheduledTimer(withTimeInterval: defalutPlayIntervel / Double(speed), repeats: true){(timer) in self.displayNextImage()}
    }
    @IBAction func changeValueDatePicker(_ sender: UIDatePicker)
    {
        let dateString = dateFormatter.string(from: datePickerOutlet.date)
        year = Int(String(dateString.prefix(4)))!
        month = Int(String(dateString.prefix(7).suffix(2)))!
        updateAllDate(year: year, month: month, day: Int(String(dateString.suffix(2)))!)
    }
    
    func updateAllDate(year: Int, month: Int, day: Int)
    {
        currentTimePointLabel.text = String(format:"%d.%.2d", year, month)
        timePointSlider.value = Float(year) + Float(month-1) * 0.08333 + Float(day - 1) * 0.002688
        datePickerOutlet.date = dateFormatter.date(from: String(format:"%d/%.2d/%.2d", year, month, day))!
        pictureView.image=UIImage(named: dateToImageName(year,month))
    }
    
    func dateToImageName(_ year: Int, _ month: Int) -> String
    {
        return imgList[(year - 2003) * 12 + month - 1]
    }
    
    func displayNextImage()
    {
        if reverseState
        {
            if month > 1
            {
                month -= 1
            }
            else if year > 2003
            {
                month = 12
                year -= 1
            }
            else if loopState
            {
                month = 12
                year = 2018
            }
            else
            {
                return // don't update return directly
            }
        }
        else
        {
            if month < 12
            {
                month += 1
            }
            else if year < 2018
            {
                month = 1
                year += 1
            }
            else if loopState
            {
                month = 1
                year = 2003
            }
            else
            {
                return // don't update return directly
            }
        }
        updateAllDate(year: year, month: month, day: Int.random(in: 1...28))
    }
}

