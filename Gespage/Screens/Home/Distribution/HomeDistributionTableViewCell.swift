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
        setupPieChart([0.0, 0.0, 0.0])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPieChart([0.0, 0.0, 0.0])
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        pieChartView.delegate = self
        backgroundColor = .clear
        StyleHelper.commonLayer(layer: distributionView.layer)
    }
    

    func setupPieChart(_ values: [Double]) {
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
        
        let dataEntries: [PieChartDataEntry] = [
            PieChartDataEntry(value: values[0], label: "Printing"),
            PieChartDataEntry(value: values[1], label: "Copies"),
            PieChartDataEntry(value: values[2], label: "Scan")
        ]
        
        var chartColors: [UIColor] = []
        var legendColors: [UIColor] = [UIColor(named: "primary600") ?? .clear, UIColor(named: "primary400") ?? .clear, UIColor(named: "sencondary500") ?? .clear]

        if values == [0.0, 0.0, 0.0] {
            // Assign a small non-zero value for chart display
            let smallNonZeroValue = 0.0001
            chartColors = [UIColor(named: "greyG400") ?? .clear, UIColor(named: "greyG400") ?? .clear, UIColor(named: "greyG400") ?? .clear]
            dataEntries.forEach { $0.y = smallNonZeroValue }
        } else {
            chartColors = [UIColor(named: "primary600") ?? .clear, UIColor(named: "primary400") ?? .clear, UIColor(named: "sencondary500") ?? .clear]
        }
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = chartColors
        dataSet.drawValuesEnabled = false // Hide values within the chart
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.backgroundColor = UIColor.clear
        pieChartView.isUserInteractionEnabled = false
        pieChartView.chartDescription.enabled = false
        pieChartView.usePercentValuesEnabled = false
        pieChartView.drawHoleEnabled = true
        pieChartView.holeRadiusPercent = 0.7
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        let entrySize: CGFloat = 24
        
        pieChartView.legend.enabled = false
        
        for (index, entry) in dataEntries.enumerated() {
            let chartColor = dataSet.color(atIndex: index)
            let legendColor = legendColors[index]
            
            let legendView = UIView()
            legendView.backgroundColor = UIColor.clear
            legendView.translatesAutoresizingMaskIntoConstraints = false
            pieChartView.addSubview(legendView)
            
            legendView.trailingAnchor.constraint(equalTo: pieChartView.trailingAnchor, constant: 52).isActive = true
            legendView.topAnchor.constraint(equalTo: pieChartView.topAnchor, constant: CGFloat(index) * entrySize).isActive = true
            legendView.widthAnchor.constraint(equalToConstant: entrySize).isActive = true
            legendView.heightAnchor.constraint(equalToConstant: entrySize).isActive = true
            
            let legendColorView = UIView()
            legendColorView.backgroundColor = legendColor
            legendColorView.translatesAutoresizingMaskIntoConstraints = false
            legendView.addSubview(legendColorView)
            
            legendColorView.topAnchor.constraint(equalTo: legendView.centerYAnchor, constant: 24).isActive = true
            legendColorView.leadingAnchor.constraint(equalTo: legendView.leadingAnchor).isActive = true
            legendColorView.centerYAnchor.constraint(equalTo: legendView.centerYAnchor).isActive = true
            legendColorView.widthAnchor.constraint(equalToConstant: entrySize * 0.5).isActive = true
            legendColorView.heightAnchor.constraint(equalToConstant: entrySize * 0.5).isActive = true
            legendColorView.layer.cornerRadius = entrySize * 0.25
            
            let legendLabel = UILabel()
            legendLabel.text = entry.label
            legendLabel.textColor = UIColor(named: "Grey100")
            legendLabel.font = UIFont.systemFont(ofSize: 14)
            legendLabel.translatesAutoresizingMaskIntoConstraints = false
            legendView.addSubview(legendLabel)
            
            legendLabel.leadingAnchor.constraint(equalTo: legendColorView.trailingAnchor, constant: 6).isActive = true
            legendLabel.centerYAnchor.constraint(equalTo: legendView.centerYAnchor, constant: 30).isActive = true
        }
    }
}
