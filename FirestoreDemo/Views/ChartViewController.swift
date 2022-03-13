//
//  ChartViewController.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 2/24/22.
//

import UIKit
import Charts
class ChartViewController: UIViewController {

    
    @IBOutlet weak var chart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        }
    
   
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupChart()
        setupChartData()
        
        print("hey")
     }
    
    private func setupChart() {
        let leftAxis = chart.leftAxis
        leftAxis.axisMinimum = -10
        leftAxis.axisMaximum = 100
        leftAxis.granularity = 20
        leftAxis.drawGridLinesEnabled = false
        
        let rightAxis = chart.rightAxis
        rightAxis.enabled = false
        
        let xAxis = chart.xAxis
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 13
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        //xAxis.setLabelCount(7, force: false)
        chart.xAxisRenderer = XAxisWeekRenderer(viewPortHandler: chart.viewPortHandler, xAxis: chart.xAxis, transformer: chart.getTransformer(forAxis: chart.leftAxis.axisDependency))
        xAxis.setLabelCount(7, force: true)
        chart.xAxis.forceLabelsEnabled = true
        chart.xAxis.granularityEnabled = true
        xAxis.valueFormatter = CustomChartFormatter()
        
        chart.setVisibleXRange(minXRange: 0.0, maxXRange: 6.0)
        
        
    }
    
    private func setupChartData() {
        var dataEntries: [ChartDataEntry] = []
        
        let forY: [Double] = [50,60,70,80]
        let forX: [String] = Patient.sharedInstance.beforeTimes


        
        
        
        
        //string to date
        let now = forX[0]
        print(now)
        let formatter = DateFormatter()
//        let arabDate = formattedDateFromString(dateString: now, withFormat: "eeee-hh:mm:ss a")
//      print(arabDate)
//        formatter.timeStyle = .short
//        formatter.dateStyle = .short
        formatter.dateFormat = "dd/M/y hh:mm:ss a"
//        let date3 = formatter.string(from: now)
        
        
        
        let date44 = Date()
        
        let newFormatter = DateFormatter()
        newFormatter.dateStyle = .short

        newFormatter.timeStyle = .short
        //use ar for arabic numbers
        newFormatter.locale = NSLocale(localeIdentifier: "ar_DZ") as Locale
       
        //newFormatter.dateFormat = "eeee - hh:mm:ss a dd/M/y"
        newFormatter.dateFormat = "eeee - hh:mm:ss a dd/M/y"
        newFormatter.amSymbol = "صباحا"
        newFormatter.pmSymbol = "مساءا"
        print(newFormatter.string(from: date44))
      
       
        
    
        
        
        
        //print(date3)
        
        
        //string to date
        let string = "30 October 2019"
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "d MMM y"
        //print(formatter4.date(from: string) ?? "Unknown date")
        
        //date to seconds
        let date = NSDate()
        let unixtime = date.timeIntervalSince1970
//
        
        print("hereee from chart \(Patient.sharedInstance.beforeReadings)")
        for i in 0..<forY.count {
            if Double(forY[i]) != 0 {
                let dataEntry = ChartDataEntry(x: Double(i+1), y: forY[i])
                dataEntries.append(dataEntry)
            }
            
        }
        let dataSet = LineChartDataSet(entries: dataEntries, label: "")
        let data = LineChartData(dataSet: dataSet)
        chart.data = data
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"

        if let date = inputFormatter.date(from: dateString) {

            let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = format

            return outputFormatter.string(from: date)
        }

        return nil
    }
}





