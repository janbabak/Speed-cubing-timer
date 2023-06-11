//
//  ChartView.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 08.06.2023.
//

import SwiftUI
import Charts

struct ChartView: View {
    @ObservedObject var viewModel: StatisticsViewModel
    
    var body: some View {
        Chart {
            ForEach(Array(viewModel.notDnfSolves.enumerated()), id: \.element) { idx, solve in
                LineMark(
                    x: .value("Order", idx),
                    y: .value("Time", solve.inSeconds)
                )
                .lineStyle(.init(lineWidth: 3, lineCap: .round))
                .foregroundStyle(Gradient(colors: [.pink, .orange, .yellow]))
                .interpolationMethod(.catmullRom)
                .symbol(Circle())
                    
                // rule mark with annotation
                if let selectedItemIdx = viewModel.selectedItemIdx {
                    RuleMark(x: .value("Order", selectedItemIdx))
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                        .foregroundStyle(.gray)
                        .annotation(position: .top) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(viewModel.notDnfSolves[selectedItemIdx].formattedTime)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color.theme.light.shadow(.drop(color: .gray.opacity(0.05), radius: 2, x: 2, y: 2)))
                            }
                        }
                }
            }
        }
        .chartXScale(domain: 0...(max(viewModel.notDnfSolves.count - 1, 1)))
        .chartYScale(domain: 0...(Int(1.1 * Double(viewModel.worstTime ?? 10))))
        .chartYAxis {
            AxisMarks(values: viewModel.xAxisMarks) { axis in
                AxisValueLabel {
                    Text(TimeFormatters.formatTime(
                        seconds: viewModel.xAxisMarks[axis.index])
                    )
                }
            }
        }
        .chartOverlay { proxy in
            // marker
            GeometryReader { innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                //getting current location
                                let location = value.location
                                if let order: Int = proxy.value(atX: location.x, as: Int.self) {
                                    if order >= 0 && order < viewModel.notDnfSolves.count {
                                        self.viewModel.selectedItemIdx = order
                                    } else {
                                        self.viewModel.selectedItemIdx = nil
                                    }
                                }
                            }
                            .onEnded { value in
                                self.viewModel.selectedItemIdx = nil
                            }
                    )
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(viewModel: .init())
    }
}
