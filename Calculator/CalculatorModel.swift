//
//  CalculatorModel.swift
//  Calculator
//
//  Created by Kultenko Sergey on 18.02.17.
//  Copyright © 2017 Sergey Kultenko. All rights reserved.
//

import Foundation

class CalculatorModel {
    private var operationsStack:[Operation] = []

    private enum Operand {
        case Number(Double)
        case Variable(String)
    }

    func setOperand(operand: Double) {
        operationsStack.append(Operation.Operand("", .Number(operand)))
    }

    func setOperand(variable named:String) {
        operationsStack.append(Operation.Operand("Var", .Variable(named)))
    }

    private enum Operation {
        case Constant(String, Double)
        case OperationWithoutArgument(String, () -> Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Operand(String, Operand)
        case Equals(String)
        case Reset
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant("π", Double.pi),
        "e" : Operation.Constant("e", M_E),
        "√" : Operation.UnaryOperation("√", sqrt),
        "cos" : Operation.UnaryOperation("cos", cos),
        "sin" : Operation.UnaryOperation("sin", sin),
        "+" : Operation.BinaryOperation("+", {$0+$1}),
        "-" : Operation.BinaryOperation("-", {$0-$1}),
        "×" : Operation.BinaryOperation("×", {$0*$1}),
        "÷" : Operation.BinaryOperation("÷", {$0/$1}),
        "±" : Operation.UnaryOperation("±", {-$0}),
        "=" : Operation.Equals("="),
        "0～1" : Operation.OperationWithoutArgument("0～1", {_ in Double(arc4random())/Double(UINT32_MAX)}),
        "C" : Operation.Reset,
    ]
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private func executePendingOperation(pendingOperation: PendingBinaryOperationInfo?,
                                         withOperand operand: Double,
                                         andDescription description: String) -> (result: Double?, isPending: Bool, description: String) {
        var operationDescription = ""
        var resultValue: Double?
        if pendingOperation != nil {
            operationDescription =  description + " " //+ accumulatorDescription
            
            resultValue = pendingOperation!.binaryFunction(pendingOperation!.firstOperand, operand)
        }
        return (resultValue, false, operationDescription)
    }
    
    private func resetCalculator() -> Void {
        operationsStack = []
    }
    
    func performOperation(operationString:String) {
        if let currOperation = operations[operationString] {
            if case .Reset = currOperation {
                resetCalculator()
            } else {
                operationsStack.append(currOperation)
            }
        }
    }
    
    func undo() {
        guard operationsStack.count > 0 else {
            return
        }
        operationsStack.remove(at: operationsStack.count-1)
    }
    
    func evaluate(using variables: Dictionary<String,Double>? = nil) -> (result: Double?, isPending: Bool, description: String) {
        var accumulator = 0.0
        var calculatorDescription = ""
        var accumulatorDescription = ""
        var pendingOperation: PendingBinaryOperationInfo?
        
        for currOperation in operationsStack {
            switch currOperation {
            case .Constant(let description, let value):
                accumulator = value
                accumulatorDescription = description
            case .Operand(_, let operand):
                switch operand {
                case .Number(let number):
                    accumulator = number
                    accumulatorDescription = formatNumber(number)
                    if (pendingOperation == nil) {
                        calculatorDescription = ""
                    }
                case .Variable(let varName):
                    accumulatorDescription = varName
                    if let varValue = variables?[varName] {
                        accumulator = varValue
                    } else {
                        accumulator = 0.0
                    }

                    if (pendingOperation == nil) {
                        calculatorDescription = ""
                    }
                }
            case .UnaryOperation(let description, let function):
                accumulator = function(accumulator)
                if accumulatorDescription.isEmpty {
                    calculatorDescription = description + "(" + calculatorDescription + ")"
                } else {
                    calculatorDescription += " " + description + "(" + accumulatorDescription + ")"
                }
                accumulatorDescription = ""
            case .BinaryOperation(let description, let function):
                if !calculatorDescription.isEmpty && !accumulatorDescription.isEmpty {
                    calculatorDescription += " "
                }
                calculatorDescription += accumulatorDescription
                let operationResult = executePendingOperation(pendingOperation: pendingOperation,
                                                              withOperand: accumulator,
                                                              andDescription: calculatorDescription)
                if operationResult.result != nil {
                    accumulator = operationResult.result ?? 0
                }
                pendingOperation = nil

                pendingOperation = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                calculatorDescription =  calculatorDescription + " " + description
            case .OperationWithoutArgument(let description, let function):
                pendingOperation = nil
                accumulator = function()
                calculatorDescription = description + "(" + accumulatorDescription + ")"
                accumulatorDescription = ""
            case .Equals(_):
                if !accumulatorDescription.isEmpty {
                    calculatorDescription += " " + accumulatorDescription
                    accumulatorDescription = ""
                }

                let operationResult = executePendingOperation(pendingOperation: pendingOperation,
                                                              withOperand: accumulator,
                                                              andDescription: calculatorDescription)
                if operationResult.result != nil {
                    accumulator = operationResult.result ?? 0
                }
                pendingOperation = nil

            case .Reset:
                resetCalculator()
                calculatorDescription = ""
                accumulatorDescription = ""
            }
        }
        return (accumulator, pendingOperation != nil, calculatorDescription)
    }
    
    @available(*, deprecated)
    var result: Double {
        get {
            let evaluateResult = evaluate()
            return evaluateResult.result ?? 0
        }
    }
    
    private func formatNumber(_ number:Double) -> String {
        let formatter=NumberFormatter()
        formatter.maximumFractionDigits = 6
        formatter.minimumIntegerDigits = 1
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
    
    @available(*, deprecated)
    public var displayValue: String  {
        get {
            return formatNumber(result)
        }
    }
    
    @available(*, deprecated)
    public var resultIsPending: Bool {
        get {
            let evaluateResult = evaluate()
            return evaluateResult.isPending
        }
    }
    
    @available(*, deprecated)
    public var description:String {
        get {
            let evaluateResult = evaluate()
            return evaluateResult.description
        }
    }
    
}
