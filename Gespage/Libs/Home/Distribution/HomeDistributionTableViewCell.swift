//
//  HomeDistributionTableViewCell.swift
//  Gespage
//
//  Created by Duy Pham on 01/08/2023.
//

import UIKit
import Charts

class HomeDistributionTableViewCell: UITableViewCell, ChartViewDelegate {
    @IBOutlet weak var distributionView: UIView!
    var pieChartView: PieChartView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupPieChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPieChart()
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        pieChartView.delegate = self
    }
    

    private func setupPieChart() {
        // Create the PieChartView
        pieChartView = PieChartView()
        addSubview(pieChartView)
        
        // Set constraints for the PieChartView (adjust these as needed)
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        pieChartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        pieChartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        pieChartView.topAnchor.constraint(equalTo: topAnchor, constant: 55).isActive = true
        pieChartView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        pieChartView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        // Sample data entries for the Pie Chart
        let dataEntries = [
            PieChartDataEntry(value: 30, label: "Printing"),
            PieChartDataEntry(value: 30, label: "Copies"),
            PieChartDataEntry(value: 30, label: "Scan"),
        ]
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = [UIColor(named: "primary600") ?? .clear, UIColor(named: "primary400") ?? .clear, UIColor(named: "sencondary500") ?? .clear]

        // Additional customization options for the pie chart
        dataSet.drawValuesEnabled = true // Hide values within the chart
        dataSet.drawIconsEnabled = false // Hide icons within the chart
        
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        
        // Hide entry labels on the chart
        pieChartView.drawEntryLabelsEnabled = false
        
        // Add background layer to pieChartView
        pieChartView.backgroundColor = UIColor.clear
        
        // Vô hiệu hóa Touchable với biểu đồ
        pieChartView.isUserInteractionEnabled = false
        
        pieChartView.chartDescription.enabled = false
        pieChartView.usePercentValuesEnabled = true
        pieChartView.drawHoleEnabled = true
        pieChartView.holeRadiusPercent = 0.7
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        // legend
//        let legend = pieChartView.legend
//        legend.enabled = true
//        legend.xEntrySpace = 0
//        legend.xOffset = 52
//        legend.yOffset = 0
//        legend.font = UIFont.systemFont(ofSize: 14)
//        legend.orientation = .vertical
//        legend.horizontalAlignment = .right
//        legend.verticalAlignment = .center
        
        // Create an entry size that includes spacing for the icon and label
        let entrySize: CGFloat = 24 // You can adjust the entry size as needed
        
        // Set the custom legend view as a custom legend for the pie chart
        pieChartView.legend.enabled = false // Disable default legend
        
        for (index, entry) in dataEntries.enumerated() {
            let color = dataSet.color(atIndex: index)
            
            let legendView = UIView()
            legendView.backgroundColor = UIColor.clear
            legendView.translatesAutoresizingMaskIntoConstraints = false
            pieChartView.addSubview(legendView)
            
            // Add constraints for the legend view
            legendView.trailingAnchor.constraint(equalTo: pieChartView.trailingAnchor, constant: 52).isActive = true
            legendView.topAnchor.constraint(equalTo: pieChartView.topAnchor, constant: CGFloat(index) * entrySize).isActive = true
            legendView.widthAnchor.constraint(equalToConstant: entrySize).isActive = true
            legendView.heightAnchor.constraint(equalToConstant: entrySize).isActive = true
            
            let legendColorView = UIView()
            legendColorView.backgroundColor = color
            legendColorView.translatesAutoresizingMaskIntoConstraints = false
            legendView.addSubview(legendColorView)
            
            // Add constraints for the legend color view
            legendColorView.topAnchor.constraint(equalTo: legendView.centerYAnchor, constant: 24).isActive = true
            legendColorView.leadingAnchor.constraint(equalTo: legendView.leadingAnchor).isActive = true
            legendColorView.centerYAnchor.constraint(equalTo: legendView.centerYAnchor).isActive = true
            legendColorView.widthAnchor.constraint(equalToConstant: entrySize * 0.5).isActive = true
            legendColorView.heightAnchor.constraint(equalToConstant: entrySize * 0.5).isActive = true
            legendColorView.layer.cornerRadius = entrySize * 0.25 // Set corner radius for the legend color view
            
            let legendLabel = UILabel()
            legendLabel.text = entry.label
            legendLabel.textColor = UIColor(named: "Grey100")
            legendLabel.font = UIFont.systemFont(ofSize: 14)
            legendLabel.translatesAutoresizingMaskIntoConstraints = false
            legendView.addSubview(legendLabel)
            
            // Add constraints for the legend label
            legendLabel.leadingAnchor.constraint(equalTo: legendColorView.trailingAnchor, constant: 6).isActive = true
            legendLabel.centerYAnchor.constraint(equalTo: legendView.centerYAnchor, constant: 30).isActive = true
        }
    }
}
