//
//  Canvas.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/28/21.
//

import UIKit

class Canvas: UIView {
    
    init(withStrokeColor strokeColor: UIColor) {
        self.strokeColor = strokeColor
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearScreen() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    func undoStroke() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    func setStrokeColor(_ color: UIColor) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setStrokeColor(color.cgColor)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setLineWidth(5)
        context.setLineCap(.round)
        context.setStrokeColor(strokeColor.cgColor)
        
        for line in lines {
            for (i,p) in line.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
        }
        context.strokePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let line:[CGPoint] = []
        lines.append(line)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self), var line = lines.popLast() else {
            return
        }
        line.append(point)
        lines.append(line)
        setNeedsDisplay()
    }
    
    private var lines:[[CGPoint]] = []
    private let strokeColor: UIColor
}
