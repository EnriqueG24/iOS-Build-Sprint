//
//  ConverencyViewController.swift
//  Converency
//
//  Created by Enrique Gongora on 2/3/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import UIKit

class ConverencyViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    //MARK: - Variables/IBOutlets
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var convertedAmountLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    var myCurrency: [String] = []
    var myValues: [Double] = []
    var activeCurrency = 0.0
    
    @IBAction func convertPressed(_ sender: UIButton) {
        guard let amountText = amountTextField.text, let theAmountText = Double(amountText) else { return }
        if amountTextField.text != "" {
            convertedAmountLabel.text = String(format: "%.2f", theAmountText * activeCurrency)
        }
    }
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrencyData()
        amountTextField.keyboardType = .numberPad
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(ConverencyViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    //MARK: - PickerView Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myCurrency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myCurrency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = myValues[row]
    }
    
    //MARK: - JSON Function
    func fetchCurrencyData(){
        guard let url = URL(string: "https://api.exchangerate-api.com/v4/latest/USD") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do{
                guard let data = data else { return }
                let myJson = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                if let rates = myJson["rates"] as? [String: Double]{
                    for (key, value) in rates{
                        self.myCurrency.append(key)
                        self.myValues.append(value)
                        DispatchQueue.main.async {
                            self.currencyPicker.reloadAllComponents()
                        }
                    }
                }
            }catch{
                print(error)
            }
        }.resume()
    }
}
