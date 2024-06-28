//
//  ViewController.swift
//  CalculatorStoryBoardUI
//
//  Created by 김동현 on 6/24/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    
    var currentInput = "0"
    let calculate = Calculate()
    let expressionCleaner = ExpressionCleaner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.text = currentInput
    }
    
    /// numberButton: 숫자 버튼이 눌렸을 때 호출되는 @IBOutlet 함수
    /// - Parameter sender: 눌린 UIButton
    @IBAction func numberButton(_ sender: UIButton) {
        print("Number button IBAction called")
        
        guard let title = sender.titleLabel?.text else {
            print("Failed to get button title")
            return
        }
        
        print("Number button pressed: \(title)")
        
        // 현재 입력값이 "0"이고 새로운 입력값이 "0"이면 아무 변화 없음
        if currentInput == "0" {
            if title == "0" {
                // "0" 상태에서 "0"을 누르면 그대로 유지
                return
            } else {
                currentInput = title
            }
        } else {
            currentInput += title
        }
        
        // 불필요한 0을 제거
        currentInput = expressionCleaner.removeLeadingZeros(from: currentInput)
        
        // 디버깅용 로그 출력
        print("Updated input: \(currentInput)")
        
        // 라벨 업데이트
        numberLabel.text = currentInput
    }
    
    /// allClear: 모든 값을 초기화하는 @IBOutlet 함수
    /// - Parameter sender: 눌린 UIButton
    @IBAction func allClear(_ sender: UIButton) {
        print("AC button pressed")
        currentInput = "0"
        numberLabel.text = currentInput
    }
    
    /// operatorButton: 연산자 버튼이 눌렸을 때 호출되는 @IBOutlet 함수
    /// - Parameter sender: 눌린 UIButton
    @IBAction func operatorButton(_ sender: UIButton) {
        print("Operator button IBAction called")
        
        guard let title = sender.titleLabel?.text else {
            print("Failed to get button title")
            return
        }
        
        print("Operator button pressed: \(title)")
        addOperator(title)
    }
    
    /// resultButton: 결과 버튼이 눌렸을 때 호출되는 @IBAction 함수
    /// - Parameter sender: 눌린 UIButton
    @IBAction func resultButton(_ sender: UIButton) {
        print("Result button pressed")
        let formattedExpression = calculate.formatExpression(currentInput)
        if expressionCleaner.isValidExpression(formattedExpression) {
            print("Formatted expression: \(formattedExpression)")
            if let result = calculate.calculate(expression: formattedExpression) {
                print("Calculation result: \(result)")
                currentInput = String(result)
            } else {
                print("Calculation result is nil")
                // 결과가 nil인 경우에만 경고 메시지를 띄움
                showAlert("Error", "잘못된 수식입니다.")
                currentInput = "0"
            }
        } else {
            print("Invalid expression")
            // 유효하지 않은 수식인 경우 경고 메시지를 띄움
            showAlert("Error", "잘못된 수식입니다.")
            currentInput = "0"
        }
        
        numberLabel.text = currentInput
    }
    
    /// addOperator: 연산자를 추가하는 함수
    /// - Parameter operator: 추가할 연산자 문자열
    private func addOperator(_ operator: String) {
        if let lastCharacter = currentInput.last, "0123456789".contains(lastCharacter) {
            currentInput += `operator`
            numberLabel.text = currentInput
        }
    }
    
    /// showAlert: 경고 메시지를 표시하는 함수
    /// - Parameters:
    ///   - title: 경고 창의 제목
    ///   - message: 경고 창의 메시지
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
