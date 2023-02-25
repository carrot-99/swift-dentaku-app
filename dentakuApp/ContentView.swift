//
//  ContentView.swift
//  dentakuApp
//
//  Created by USER on 2023/02/25.
//

import SwiftUI

enum CalculateState {
    case initial, addition, substraction, division, multiplication, sum
}

struct ContentView: View {
    // 状態観察@State
    @State var selectedItem: String = "0"
    @State var calculatedNumber: Double = 0
    @State var calculateState: CalculateState = .initial
    
    private let calculateItems: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    

    
    
    var body: some View {
        
        ZStack{
            
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack{
                    Spacer()
                    Text(selectedItem == "0" ? checkDecimal(number: calculatedNumber) : selectedItem)
                        .font(.system(size: 100, weight: .light))
                        .foregroundColor(Color.white)
                        .padding()
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                }
                
                VStack {
                    ForEach(calculateItems, id: \.self) { items in
                        NumberView(selectedItem: $selectedItem,
                                   calculatedNumber: $calculatedNumber,
                                   calculateState: $calculateState,
                                   items: items)
                    }
                }
            }
            .padding(.bottom, 40)
        }
    }
    private func checkDecimal(number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1).isLess(than: .ulpOfOne) {
            return String(Int(number))
        } else {
            return String(number)
        }
    }
}

struct NumberView: View {
    // 上のビューと紐付け
    @Binding var selectedItem: String
    @Binding var calculatedNumber: Double
    @Binding var calculateState: CalculateState
    
    var items: [String]
    
    private let buttonWidth: CGFloat = (UIScreen.main.bounds.width - 50) / 4
    private let numbers: [String] = ["1", "2", "3","4", "5", "6","7", "8", "9", "0", "."]
    private let symbols: [String] = ["÷", "x", "-", "+", "="]
    
    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                Button {
                    handleButtonInfo(item: item)
                } label: {
                    Text(item)
                        .font(.system(size: 30, weight: .regular))
                        .frame(minWidth: 0, maxWidth: .infinity,
                               minHeight: 0, maxHeight: .infinity)
                }
                .foregroundColor(numbers.contains(item) || symbols.contains(item) ?  .white : .black)
                .background(handleButtonColor(item: item))
                .frame(width: item == "0" ? buttonWidth * 2 + 10 : buttonWidth)
                .cornerRadius(buttonWidth)
            }
            .frame(height: buttonWidth)
        }
    }
    // ボタンの色を設定
    private func handleButtonColor(item: String) -> Color {
        if numbers.contains(item) {
            return Color(white: 0.2, opacity: 1)
        } else if symbols.contains(item) {
            return Color.orange
        } else {
            return Color(white: 0.8, opacity: 1)
        }
    }
    // ボタンタップ時の処理を作成
    private func handleButtonInfo(item: String){
        
        // 数字が入力された時
        if numbers.contains(item) {
            if item == "." && (selectedItem.contains(".") || selectedItem.contains("0")) {
                return
            }
            
            if selectedItem.count >= 10 {
                return
            }
            
            if selectedItem == "0" {
                selectedItem = item
                return
            }
            
            selectedItem += item
        } else if item == "AC" {
            selectedItem = "0"
            calculatedNumber = 0
            calculateState = .initial
        }
        
        guard let selectedNumber = Double(selectedItem) else { return }
        // 計算記号が入力された時
        if item == "+" {
            setCalculateState(state: .addition, selectedNumber: selectedNumber)
        } else if item == "-" {
            setCalculateState(state: .substraction, selectedNumber: selectedNumber)
        } else if item == "x" {
            setCalculateState(state: .multiplication, selectedNumber: selectedNumber)
        } else if item == "÷" {
            setCalculateState(state: .division, selectedNumber: selectedNumber)
        } else if item == "=" {
            selectedItem = "0"
            calculate(selectedNumber: selectedNumber)
            calculateState = .sum
        }
    }
    
    private func setCalculateState(state: CalculateState, selectedNumber: Double) {
        if selectedItem == "0" {
            calculateState = state
            return
        }
        selectedItem = "0"
        calculateState = state
        calculate(selectedNumber: selectedNumber)
    }
    
    private func calculate(selectedNumber: Double ) {
        
        if calculatedNumber == 0 {
            calculatedNumber = selectedNumber
            return
        }
        
        switch calculateState {
        case .addition:
            calculatedNumber = calculatedNumber + selectedNumber
        case .substraction:
            calculatedNumber = calculatedNumber - selectedNumber
        case .division:
            calculatedNumber = calculatedNumber / selectedNumber
        case .multiplication:
            calculatedNumber = calculatedNumber * selectedNumber
        default:
            break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
