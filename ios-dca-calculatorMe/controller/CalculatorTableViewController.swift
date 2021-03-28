//
//  CalculatorTableViewController.swift
//  ios-dca-calculatorMe
//
//  Created by Иван Кочетков on 28.03.2021.
//

import UIKit

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField: UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var currencyLabel: [UILabel]!
    @IBOutlet weak var investmentAmountCurencyLabel: UILabel!
    
    var asset: Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews ()
        setupTextFields()
    }
    
    private func setupViews(){
        symbolLabel.text = asset?.searchResult.symbol
        nameLabel.text = asset?.searchResult.name
        investmentAmountCurencyLabel.text = asset?.searchResult.currency
        currencyLabel.forEach { (label) in
            label.text = asset?.searchResult.currency.addBrackets()
        }
    }
    
    private func setupTextFields() {
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDollarCostAveragingTextField.addDoneButton()
        initialDateOfInvestmentTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDateSelection",
           let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController,
           let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted {
            dateSelectionTableViewController.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
            dateSelectionTableViewController.didSelectDate = { [weak self] index in                self?.handleDateSelectin(at: index)
            }
        }
    }
    private func handleDateSelectin (at index: Int){
        if let monthInfos = asset?.timeSeriesMonthlyAdjusted.getMonthInfos(){
            let monthInfo = monthInfos[index]
            let dateString = monthInfo.date.MMYYFormat
            initialInvestmentAmountTextField.text = dateString
        }
        
    }
    
}

extension CalculatorTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == initialDateOfInvestmentTextField {
            performSegue(withIdentifier: "showDateSelection", sender: asset?.timeSeriesMonthlyAdjusted)
        }
        return false
    }
}
