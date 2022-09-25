//
//  baseVC.swift
//  FirestoreDemo
//
//  Created by othman shahrouri on 2/17/22.
//
import Charts
import Firebase
class Patient {
    static let sharedInstance = Patient()
    var doctorID: String!
    let db = Firestore.firestore()

    
    var userName: String!
    var diabetesType: String!
    var height: String!
    var weight: String!
    var birthdate: String!
    var docID: String!
    var nationalID: String!
    
    
    
    
    
    
    var weeksCount:Int!
    var beforeReadings = [String]()
    var beforeTimes = [String]()
    var deltaBeforeTimes = [String]() //stores timeInterval of each reading to be plotted on chart
    var afterReadings = [String]()
    var afterTimes = [String]()
    var deltaAfterTimes = [String]() //stores timeInterval of each reading to be plotted on chart
    
    
    public func setupChart(chart:LineChartView,beforeColor:UIColor,afterColor:UIColor,axisColor:UIColor,labelColor:UIColor) {
        let leftAxis = chart.leftAxis
        leftAxis.axisMinimum = -10
        leftAxis.axisMaximum = 100
        leftAxis.granularity = 20
        leftAxis.labelTextColor = labelColor
        leftAxis.drawAxisLineEnabled = false
        leftAxis.axisLineWidth = 1.5
        leftAxis.drawGridLinesEnabled = true
        leftAxis.gridColor = UIColor(red: 91/255, green: 122/255, blue: 128/255, alpha: 0.08)
        leftAxis.gridLineWidth = 1.5
        
        let rightAxis = chart.rightAxis
        rightAxis.enabled = false
        
        let xAxis = chart.xAxis
        xAxis.valueFormatter = DateValueFormatter()
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 7
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = labelColor

        xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        xAxis.axisLineColor = axisColor
        xAxis.axisLineWidth = 1.5
        //xAxis.setLabelCount(7, force: false)
        chart.xAxisRenderer = XAxisWeekRenderer(viewPortHandler: chart.viewPortHandler, xAxis: chart.xAxis, transformer: chart.getTransformer(forAxis: chart.leftAxis.axisDependency))
        xAxis.setLabelCount(7, force: true)
        chart.xAxis.forceLabelsEnabled = true
        chart.xAxis.granularityEnabled = true
        
        
        xAxis.valueFormatter = CustomChartFormatter()
        
        
        
        chart.setVisibleXRange(minXRange: 0.0, maxXRange: 7)
        chart.data?.setDrawValues(true)
        //chart.legend.xOffset = (chart.window?.frame.width)! * 0.42
        chart.legend.form = .circle
        chart.extraTopOffset = 20
       
        chart.legend.horizontalAlignment = .center
        chart.legend.verticalAlignment = .top
        chart.extraBottomOffset = 50
    }
    
    
    public func setupChartData(chart:LineChartView,beforeReadings:[String],deltaBeforeTimes:[String],afterReadings:[String],deltaAfterTimes:[String],beforeColor:UIColor,afterColor:UIColor,axisColor:UIColor) {
        var lineChartEntry1: [ChartDataEntry] = []//before eatting
        var lineChartEntry2: [ChartDataEntry] = [] //after eatting
        
        let forY: [String] = beforeReadings
        let forX: [String] = deltaBeforeTimes
        
//        let forY2 = [100,100,25,15,12,55,65]
//        let forX2 = [0.5,0.7,2,3,4,5,6]
//
        let forY2 = afterReadings
        let forX2 = deltaAfterTimes
        
        
       // let forY  = [100,100,25,15,12,55,65]
        //let forX = [0.5,0.7,2,3,4,5,6]
      
        let data = LineChartData()
        
     
    
        
        
        print("count of y \(forY.count)")
        print("count of x \(forX.count)")
        
//
        
        //print("hereee from chart \(Patient.sharedInstance.beforeReadings)")
        
        for i in 0..<forY.count { //before eatting
            if Double(forY[i]) != 0 {
                let dataEntry = ChartDataEntry(x: Double(forX[i])!, y: Double(forY[i])!)
                lineChartEntry1.append(dataEntry)
            }
            
        }
        
        for i in 0..<forY2.count {//after eatting
            if Double(forY2[i]) != 0 {
                let dataEntry = ChartDataEntry(x: Double(forX2[i])!, y: Double(forY2[i])!)
                lineChartEntry2.append(dataEntry)
            }
            
        }
        
        let dataSet = LineChartDataSet(entries: lineChartEntry1, label: "قبل الأكل")
        
        let dataSet2 = LineChartDataSet(entries: lineChartEntry2, label: "بعد الأكل")
        
        data.addDataSet(dataSet)
        data.addDataSet(dataSet2)
        //before eating line design
        dataSet.setColor(beforeColor)
        dataSet.fillColor = .white
        dataSet.circleColors = [beforeColor]
        dataSet.circleRadius = 6
        dataSet.lineWidth = 3
        
        
        dataSet2.setColor(afterColor)
        dataSet2.fillColor = .white
        dataSet2.circleColors = [afterColor]
        dataSet2.circleRadius = 6
        dataSet2.lineWidth = 3
        
        
        chart.data = data
        
        //chart.legend.horizontalAlignment = .center
    }
    
    
   
    
}

