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
        setupPieChart([1])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPieChart([1])
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        pieChartView.delegate = self
        backgroundColor = .clear
        StyleHelper.commonLayer(layer: distributionView.layer)
    }
    

    func setupPieChart(_ values: [Double]) {
        // Init data
        let defaultValues = [0.0, 0.0, 0.0]
        var chartValues = Array(values.prefix(3)) + defaultValues.suffix(max(0, 3 - values.count))
        
        let daraEntries: [PieChartDataEntry] = [
            PieChartDataEntry(value: chartValues[0], label: "Printing"),
            PieChartDataEntry(value: chartValues[1], label: "Copies"),
            PieChartDataEntry(value: chartValues[2], label: "Scan"),
        ]
        
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
        
        
        let dataSet = PieChartDataSet(entries: daraEntries, label: "")
        let isEmptyDataEntries = values.count == 1
        dataSet.colors = isEmptyDataEntries ?
        [UIColor(named: "greyG400") ?? .clear] :
        [UIColor(named: "primary600") ?? .clear, UIColor(named: "primary400") ?? .clear, UIColor(named: "sencondary500") ?? .clear]

        // Additional customization options for the pie chart
        dataSet.drawValuesEnabled = false // Hide values within the chart
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
        pieChartView.usePercentValuesEnabled = false
        pieChartView.drawHoleEnabled = true
        pieChartView.holeRadiusPercent = 0.7
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        // Create an entry size that includes spacing for the icon and label
        let entrySize: CGFloat = 24 // You can adjust the entry size as needed
        
        // Set the custom legend view as a custom legend for the pie chart
        pieChartView.legend.enabled = false // Disable default legend
        
        for (index, entry) in daraEntries.enumerated() {
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
