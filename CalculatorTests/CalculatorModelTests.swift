//
//  CalculatorModelTests.swift
//  Calculator
//
//  Created by Sergei Kultenko on 31/08/2017.
//  Copyright © 2017 Sergey Kultenko. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorModelTests: XCTestCase {
    var model:CalculatorModel?
    
    override func setUp() {
        super.setUp()
        
        model = CalculatorModel()
    }
    
    override func tearDown() {
        model = nil

        super.tearDown()
    }

    //    a. touching 7 + would show “7 + ...” (with 7 still in the display)
    func testExpressionA() {
        //Given
        model?.setOperand(operand: 7.0)
        model?.performOperation(operationString: "+")
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 7.0)
            XCTAssertEqual(result!.description, "7 +")
            XCTAssertTrue(result!.isPending)
        }
    }
    
    //    b. 7 + 9 would show “7 + ...” (9 in the display)
    func testExpressionB() {
        //Given
        model?.setOperand(operand: 7.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 9.0)
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 9.0)
            XCTAssertEqual(result!.description, "7 +")
            XCTAssertTrue(result!.isPending)
        }
    }

    //    c. 7 + 9 = would show “7 + 9 =” (16 in the display)
    func testExpressionC() {
        //Given
        model?.setOperand(operand: 7.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 9.0)
        model?.performOperation(operationString: "=")
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 16.0)
            XCTAssertEqual(result!.description, "7 + 9")
            XCTAssertFalse(result!.isPending)
        }
    }

    //    d. 7 + 9 = √ would show “√(7 + 9) =” (4 in the display)
    func testExpressionD() {
        //Given
        model?.setOperand(operand: 7.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 9.0)
        model?.performOperation(operationString: "=")
        model?.performOperation(operationString: "√")
        
        
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 4.0)
            XCTAssertEqual(result!.description, "√(7 + 9)")
            XCTAssertFalse(result!.isPending)
        }
    }

    //    e. 7 + 9 = √ + 2 = would show “√(7 + 9) + 2 =” (6 in the display)
    func testExpressionE() {
        //Given
        model?.setOperand(operand: 7.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 9.0)
        model?.performOperation(operationString: "=")
        model?.performOperation(operationString: "√")
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 2.0)
        model?.performOperation(operationString: "=")
        
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 6.0)
            XCTAssertEqual(result!.description, "√(7 + 9) + 2")
            XCTAssertFalse(result!.isPending)
        }
    }

    //    f. 7 + 9 √ would show “7 + √(9) ...” (3 in the display)
    func testExpressionF() {
        //Given
        model?.setOperand(operand: 7.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 9.0)
        model?.performOperation(operationString: "√")
        
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 3.0)
            XCTAssertEqual(result!.description, "7 + √(9)")
            XCTAssertTrue(result!.isPending)
        }
    }

    //    g. 7 + 9 √ = would show “7 + √(9) =“ (10 in the display)
    func testExpressionG() {
        //Given
        model?.setOperand(operand: 7.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 9.0)
        model?.performOperation(operationString: "√")
        model?.performOperation(operationString: "=")
        
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 10.0)
            XCTAssertEqual(result!.description, "7 + √(9)")
            XCTAssertFalse(result!.isPending)
        }
    }

    //    h. 7 + 9 = + 6 = + 3 = would show “7 + 9 + 6 + 3 =” (25 in the display)
    func testExpressionH() {
        //Given
        model?.setOperand(operand: 7.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 9.0)
        model?.performOperation(operationString: "=")
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 6.0)
        model?.performOperation(operationString: "=")
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 3.0)
        model?.performOperation(operationString: "=")
        
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 25.0)
            XCTAssertEqual(result!.description, "7 + 9 + 6 + 3")
            XCTAssertFalse(result!.isPending)
        }
    }

    //    i. 7 + 9 = √ 6 + 3 = would show “6 + 3 =” (9 in the display)
    func testExpressionI() {
        //Given
        model?.setOperand(operand: 7.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 9.0)
        model?.performOperation(operationString: "=")
        model?.performOperation(operationString: "√")
        model?.setOperand(operand: 6.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 3.0)
        model?.performOperation(operationString: "=")
        
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 9.0)
            XCTAssertEqual(result!.description, "6 + 3")
            XCTAssertFalse(result!.isPending)
        }
    }

    //    j. 5 + 6 = 7 3 would show “5 + 6 =” (73 in the display)
    func testExpressionJ() {
        //Given
        model?.setOperand(operand: 5.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 6.0)
        model?.performOperation(operationString: "=")
        model?.setOperand(operand: 73.0)
        
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 73.0)
            XCTAssertEqual(result!.description, "")
            XCTAssertFalse(result!.isPending)
        }
    }
    
    func compareDoubles(expression1: Double, expression2: Double, accuracy: Double) -> Bool {
        return abs(abs(expression1) - abs(expression2)) <= accuracy
    }
    
    //    k. 4 × π = would show “4 × π =“ (12.5663706143592 in the display)
    func testExpressionK() {
        //Given
        model?.setOperand(operand: 4.0)
        model?.performOperation(operationString: "×")
        model?.performOperation(operationString: "π")
        model?.performOperation(operationString: "=")
        
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertTrue(compareDoubles(expression1: result!.result ?? 0,
                                         expression2: 12.5663706143592, accuracy: 0.0000000000001))
            XCTAssertEqual(result!.description, "4 × π")
            XCTAssertFalse(result!.isPending)
        }
    }

    func testExpressionWithoutEqualOperation() {
        //Given
        model?.setOperand(operand: 7.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 9.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 6.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 3.0)
        model?.performOperation(operationString: "=")
        
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 25.0)
            XCTAssertEqual(result!.description, "7 + 9 + 6 + 3")
            XCTAssertFalse(result!.isPending)
        }
    }
    
    //9 + M = √ ⇒ description is √(9+M), display is 3 because M is not set (thus 0.0).
    func testExpressionWithVariable() {
        //Given
        model?.setOperand(operand: 9.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(variable: "M")
        model?.performOperation(operationString: "=")
        model?.performOperation(operationString: "√")
        
        //When
        let result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 3.0)
            XCTAssertEqual(result!.description, "√(9 + M)")
            XCTAssertFalse(result!.isPending)
        }
    }
    
    func testExpressionWithVariableValue() {
        //Given
        model?.setOperand(operand: 9.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(variable: "M")
        model?.performOperation(operationString: "=")
        model?.performOperation(operationString: "√")
        
        let variables = ["M" : 7.0]
        
        //When
        let result = model?.evaluate(using: variables)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 4.0)
            XCTAssertEqual(result!.description, "√(9 + M)")
            XCTAssertFalse(result!.isPending)
        }
    }
    
    func testUndoOperation() {
        //Given
        model?.setOperand(operand: 7.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 9.0)
        model?.performOperation(operationString: "=")
        model?.performOperation(operationString: "√")
        model?.setOperand(operand: 6.0)
        model?.performOperation(operationString: "+")
        model?.setOperand(operand: 3.0)
        model?.performOperation(operationString: "=")
        
        //When
        model?.undo()
        var result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 3.0)
            XCTAssertEqual(result!.description, "6 +")
            XCTAssertTrue(result!.isPending)
        }

        //When
        model?.undo()
        result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 6.0)
            XCTAssertEqual(result!.description, "6 +")
            XCTAssertTrue(result!.isPending)
        }
        
        //When
        model?.undo()
        result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 6.0)
            XCTAssertEqual(result!.description, "")
            XCTAssertFalse(result!.isPending)
        }

        //When
        model?.undo()
        result = model?.evaluate(using: nil)
        
        //Then
        if result != nil {
            XCTAssertEqual(result!.result ?? 0, 4.0)
            XCTAssertEqual(result!.description, "√(7 + 9)")
            XCTAssertFalse(result!.isPending)
        }
        
        
    }

}
