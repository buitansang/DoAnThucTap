//
//  StatisticalViewController.swift
//  ADMIN_ECOMMERCE
//
//  Created by Sang Hi Bùi on 14/08/2022.
//

import UIKit
import Charts

class StatisticalViewController: UIViewController {

    let labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Statistics of the number of USERS by current year."
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return  label
    }()
    
    let titleView: UILabel = {
        let label = UILabel()
        label.text = "Statistical"
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textAlignment = .center
        return  label
    }()
    
    let segmentedControl = UISegmentedControl(items: ["User", "Order", "Product", "Payment"])
    let stackView = UIStackView()
    
    let viewOfBarCharUser = UIView()
    let viewOfBarCharProDuct = UIView()
    let viewOfBarCharOrder = UIView()
    let viewOfBarCharPayment = UIView()
    
    
    let barChartUser = BarChartView()
    let barChartOrder = BarChartView()
    let barChartProduct = BarChartView()
    let barChartPayment = BarChartView()
    
    var listValueUser: [Float]?
    var listValueOrder: [Float]?
    var listValueProduct: [Float]?
    var listValuePayment: [Float]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetView()
        statisticalForUser()
        viewOfBarCharUser.isHidden = false
        setupTitleView()
        setupSegment()
        setupStackView()
        setupSubTitle()
        createChart()
        
    }
    
    private func setupSubTitle() {
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.numberOfLines = 0
        view.addSubview(labelTitle)
    }
    
    private func setupTitleView() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView)
    }
    
    private func setupStackView() {
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
    }
    
    private func setupSegment() {
        segmentedControl.backgroundColor = .white
        segmentedControl.selectedSegmentTintColor = .systemGreen
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
    }

    
    private func createChart() {
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            titleView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            titleView.heightAnchor.constraint(equalToConstant: 30),
            segmentedControl.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
            stackView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 0),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50),
            labelTitle.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -200),
            labelTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            labelTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        ])
        
        //Create View BarCharProDuct
        stackView.addArrangedSubview(viewOfBarCharUser)
        stackView.addArrangedSubview(viewOfBarCharProDuct)
        stackView.addArrangedSubview(viewOfBarCharOrder)
        stackView.addArrangedSubview(viewOfBarCharPayment)
        
        barChartOrder.frame =  CGRect(x: 0, y: 0, width: viewOfBarCharOrder.frame.size.width, height: viewOfBarCharOrder.frame.size.width)
        barChartOrder.translatesAutoresizingMaskIntoConstraints = false
        
        barChartProduct.frame = CGRect(x: 0, y: 0, width: viewOfBarCharProDuct.frame.size.width, height: viewOfBarCharProDuct.frame.size.width)
        barChartProduct.translatesAutoresizingMaskIntoConstraints = false
        
        barChartUser.frame = CGRect(x: 0, y: 0, width: viewOfBarCharUser.frame.size.width, height: viewOfBarCharUser.frame.size.width)
        barChartUser.translatesAutoresizingMaskIntoConstraints = false
        
        barChartPayment.frame = CGRect(x: 0, y: 0, width: viewOfBarCharPayment.frame.size.width, height: viewOfBarCharPayment.frame.size.width)
        barChartPayment.translatesAutoresizingMaskIntoConstraints = false
        
    }
    private func createBarchartPayment() {
        // Configure the axis
        let xAxis = barChartPayment.xAxis
        xAxis.labelPosition = .bottom
        xAxis.setLabelCount(12, force: false)
        xAxis.valueFormatter = self
        
        let rightAxis = barChartPayment.rightAxis
        
        // Configure legend
        let legend = barChartPayment.legend
        
        
        // Supply data
        var entries = [BarChartDataEntry]()
        
        for x in 0..<12 {
            entries.append(
                BarChartDataEntry(
                    x: Double(x),
                    y: Double(Int(listValuePayment?[x] ?? 0) ?? 0)
                )
            )
        }
        
        let set = BarChartDataSet(entries: entries, label: "Month")
        set.colors = [
            NSUIColor(cgColor: UIColor.systemRed.cgColor),
            NSUIColor(cgColor: UIColor.systemBlue.cgColor),
            NSUIColor(cgColor: UIColor.systemGray.cgColor),
            NSUIColor(cgColor: UIColor.systemGray5.cgColor),
            NSUIColor(cgColor: UIColor.systemPink.cgColor),
            NSUIColor(cgColor: UIColor.systemBrown.cgColor),
            NSUIColor(cgColor: UIColor.systemTeal.cgColor),
            NSUIColor(cgColor: UIColor.systemGreen.cgColor),
            NSUIColor(cgColor: UIColor.systemOrange.cgColor),
            NSUIColor(cgColor: UIColor.systemPurple.cgColor),
            NSUIColor(cgColor: UIColor.systemYellow.cgColor),
            NSUIColor(cgColor: UIColor.systemIndigo.cgColor),
        ]
        let data = BarChartData(dataSet: set)
        
        barChartPayment.data = data
        viewOfBarCharPayment.addSubview(barChartPayment)
        
        NSLayoutConstraint.activate([
            barChartPayment.centerXAnchor.constraint(equalTo: viewOfBarCharPayment.centerXAnchor),
            barChartPayment.centerYAnchor.constraint(equalTo: viewOfBarCharPayment.centerYAnchor,constant: -100),
            barChartPayment.widthAnchor.constraint(equalTo: viewOfBarCharPayment.widthAnchor),
            barChartPayment.heightAnchor.constraint(equalTo: viewOfBarCharPayment.widthAnchor)
            
        ])
    }
    
    private func createBarchartUser() {
        // Configure the axis
        let xAxis = barChartUser.xAxis
        xAxis.labelPosition = .bottom
        xAxis.setLabelCount(12, force: false)
        xAxis.valueFormatter = self
        
        let rightAxis = barChartUser.rightAxis
        
        // Configure legend
        let legend = barChartUser.legend
        
        
        // Supply data
        var entries = [BarChartDataEntry]()
        
        for x in 0..<12 {
            entries.append(
                BarChartDataEntry(
                    x: Double(x),
                    y: Double(listValueUser?[x] ?? 0)
                )
            )
        }
        
        let set = BarChartDataSet(entries: entries, label: "Month")
        set.colors = [
            NSUIColor(cgColor: UIColor.systemRed.cgColor),
            NSUIColor(cgColor: UIColor.systemBlue.cgColor),
            NSUIColor(cgColor: UIColor.systemGray.cgColor),
            NSUIColor(cgColor: UIColor.systemGray5.cgColor),
            NSUIColor(cgColor: UIColor.systemPink.cgColor),
            NSUIColor(cgColor: UIColor.systemBrown.cgColor),
            NSUIColor(cgColor: UIColor.systemTeal.cgColor),
            NSUIColor(cgColor: UIColor.systemGreen.cgColor),
            NSUIColor(cgColor: UIColor.systemOrange.cgColor),
            NSUIColor(cgColor: UIColor.systemPurple.cgColor),
            NSUIColor(cgColor: UIColor.systemYellow.cgColor),
            NSUIColor(cgColor: UIColor.systemIndigo.cgColor),
        ]
        let data = BarChartData(dataSet: set)
        
        barChartUser.data = data
        viewOfBarCharUser.addSubview(barChartUser)
        
        NSLayoutConstraint.activate([
            barChartUser.centerXAnchor.constraint(equalTo: viewOfBarCharUser.centerXAnchor),
            barChartUser.centerYAnchor.constraint(equalTo: viewOfBarCharUser.centerYAnchor,constant: -100),
            barChartUser.widthAnchor.constraint(equalTo: viewOfBarCharUser.widthAnchor),
            barChartUser.heightAnchor.constraint(equalTo: viewOfBarCharUser.widthAnchor)
            
        ])
    }
    
    private func createBarchartOrder() {
        
        // Configure the axis
        let xAxis = barChartOrder.xAxis
        xAxis.labelPosition = .bottom
        xAxis.setLabelCount(12, force: false)
        xAxis.valueFormatter = self
        
        let rightAxis = barChartOrder.rightAxis
        
        // Configure legend
        let legend = barChartOrder.legend
        
        
        // Supply data
        var entries = [BarChartDataEntry]()
        
        for x in 0..<12 {
            entries.append(
                BarChartDataEntry(
                    x: Double(x),
                    y: Double(listValueOrder?[x] ?? 0)
                )
            )
        }
        
        let set = BarChartDataSet(entries: entries, label: "Month")
        set.colors = [
            NSUIColor(cgColor: UIColor.systemRed.cgColor),
            NSUIColor(cgColor: UIColor.systemBlue.cgColor),
            NSUIColor(cgColor: UIColor.systemGray.cgColor),
            NSUIColor(cgColor: UIColor.systemGray5.cgColor),
            NSUIColor(cgColor: UIColor.systemPink.cgColor),
            NSUIColor(cgColor: UIColor.systemBrown.cgColor),
            NSUIColor(cgColor: UIColor.systemTeal.cgColor),
            NSUIColor(cgColor: UIColor.systemGreen.cgColor),
            NSUIColor(cgColor: UIColor.systemOrange.cgColor),
            NSUIColor(cgColor: UIColor.systemPurple.cgColor),
            NSUIColor(cgColor: UIColor.systemYellow.cgColor),
            NSUIColor(cgColor: UIColor.systemIndigo.cgColor),
        ]
        let data = BarChartData(dataSet: set)
        
        barChartOrder.data = data
        viewOfBarCharOrder.addSubview(barChartOrder)
        
        NSLayoutConstraint.activate([
            barChartOrder.centerXAnchor.constraint(equalTo: viewOfBarCharOrder.centerXAnchor),
            barChartOrder.centerYAnchor.constraint(equalTo: viewOfBarCharOrder.centerYAnchor,constant: -100),
            barChartOrder.widthAnchor.constraint(equalTo: viewOfBarCharOrder.widthAnchor),
            barChartOrder.heightAnchor.constraint(equalTo: viewOfBarCharOrder.widthAnchor)
            
        ])
        
    }
    
    private func createBarchartProduct() {
        // Configure the axis
        let xAxis = barChartProduct.xAxis
        xAxis.labelPosition = .bottom
        xAxis.setLabelCount(12, force: false)
        xAxis.valueFormatter = self
        
        let rightAxis = barChartProduct.rightAxis
        
        // Configure legend
        let legend = barChartProduct.legend
        
        
        // Supply data
        var entries = [BarChartDataEntry]()
        
        for x in 0..<12 {
            entries.append(
                BarChartDataEntry(
                    x: Double(x),
                    y: Double(listValueProduct?[x] ?? 0)
                )
            )
        }
        
        let set = BarChartDataSet(entries: entries, label: "Month")
        set.colors = [
            NSUIColor(cgColor: UIColor.systemRed.cgColor),
            NSUIColor(cgColor: UIColor.systemBlue.cgColor),
            NSUIColor(cgColor: UIColor.systemGray.cgColor),
            NSUIColor(cgColor: UIColor.systemGray5.cgColor),
            NSUIColor(cgColor: UIColor.systemPink.cgColor),
            NSUIColor(cgColor: UIColor.systemBrown.cgColor),
            NSUIColor(cgColor: UIColor.systemTeal.cgColor),
            NSUIColor(cgColor: UIColor.systemGreen.cgColor),
            NSUIColor(cgColor: UIColor.systemOrange.cgColor),
            NSUIColor(cgColor: UIColor.systemPurple.cgColor),
            NSUIColor(cgColor: UIColor.systemYellow.cgColor),
            NSUIColor(cgColor: UIColor.systemIndigo.cgColor),
        ]
        let data = BarChartData(dataSet: set)
        
        barChartProduct.data = data
        viewOfBarCharProDuct.addSubview(barChartProduct)
        
        NSLayoutConstraint.activate([
            barChartProduct.centerXAnchor.constraint(equalTo: viewOfBarCharProDuct.centerXAnchor),
            barChartProduct.centerYAnchor.constraint(equalTo: viewOfBarCharProDuct.centerYAnchor,constant: -100),
            barChartProduct.widthAnchor.constraint(equalTo: viewOfBarCharProDuct.widthAnchor),
            barChartProduct.heightAnchor.constraint(equalTo: viewOfBarCharProDuct.widthAnchor)
            
        ])
    }
    
    private func resetView() {
        viewOfBarCharUser.isHidden = true
        viewOfBarCharProDuct.isHidden = true
        viewOfBarCharOrder.isHidden = true
        viewOfBarCharPayment.isHidden = true
    }
    
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            labelTitle.text = "Statistics of the number of USERS by current year."
            resetView()
            statisticalForUser()
            viewOfBarCharUser.isHidden = false
        case 1:
            labelTitle.text = "Statistics of the number of ORDERS by current year."
            resetView()
            statisticalForOrder()
            viewOfBarCharOrder.isHidden = false
        case 2:
            labelTitle.text = "Statistics of the number of PRODUCTS by current year."
            resetView()
            statisticalProduct()
            viewOfBarCharProDuct.isHidden = false
        case 3:
            labelTitle.text = "Statistics of PAYMENT by current year."
            resetView()
            statisticalPayment()
            viewOfBarCharPayment.isHidden = false
        default:
            break
        }
    }

}

extension StatisticalViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
        return months[Int(value)]
    }
}

extension StatisticalViewController {
    private func statisticalForUser() {
        APIService.statisticalUser { res, error in
            guard let res = res else {
                return
            }
            DispatchQueue.main.async {
                self.listValueUser = res.data?.datasets?.first?.data
                self.createBarchartUser()
            }
        }
    }
    
    private func statisticalForOrder() {
        APIService.statisticalOrder { res, error in
            guard let res = res else {
                return
            }
            DispatchQueue.main.async {
                self.listValueOrder = res.data?.datasets?.first?.data
                self.createBarchartOrder()
            }
        }
    }
    
    private func statisticalProduct() {
        APIService.statisticalProduct { res, error in
            guard let res = res else {
                return
            }
            DispatchQueue.main.async {
                self.listValueProduct = res.data?.datasets?.first?.data
                self.createBarchartProduct()
            }
        }
    }
    
    private func statisticalPayment() {
        APIService.statisticalPayment { res, error in
            guard let res = res else {
                return
            }
            DispatchQueue.main.async {
                self.listValuePayment = res.data?.datasets?.first?.data
                self.createBarchartPayment()
            }
        }
    }
    
}

