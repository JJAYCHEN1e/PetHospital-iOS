//
//  ExamListCard.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/3.
//

import SwiftUI

class ExamListCardViewModel: ObservableObject {
    @Published var title = "考试标题"
    @Published var totalQuestionNumber = 0
    @Published var totalQuestionScore = 0
    @Published var startDateTime = "0000-00-00 00:00"
    @Published var endDateTime = "0000-00-00 00:00"
    @Published var action: () -> () = {}
    @Published var finished = true
    @Published var userScore: Int?
}

struct ExamListCard: View {
    @ObservedObject var viewModel: ExamListCardViewModel
    
    var body: some View {
        Button(action: viewModel.action, label: {
            HStack {
                Text("📄")
                    .font(.largeTitle)
                    .frame(width: 50)
                VStack(alignment: .leading) {
                    Text(viewModel.title)
                        .font(.title).fontWeight(.bold)
                    HStack {
                        Text("共 \(viewModel.totalQuestionNumber) 题 计 \(viewModel.totalQuestionScore) 分")
                            .font(.body)
                        if viewModel.finished {
                            Group {
                                Image(systemName: "checkmark.seal.fill")
                                Text("已完成")
                                    .font(.body)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(Color.blue)
                        }
                    }
                    Spacer()
                    Text("开始时间 \(viewModel.startDateTime)")
                        .font(Font.system(.subheadline, design: .monospaced).weight(.bold))
                    Text("结束时间 \(viewModel.endDateTime)")
                        .font(Font.system(.subheadline, design: .monospaced).weight(.bold))
                }
                .frame(height: 130)
                Spacer()
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .overlay (
                Text("\(viewModel.userScore ?? 0) 分")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .opacity(viewModel.finished && viewModel.userScore != nil ? 1.0 : 0.0)
                , alignment: .topLeading
            )
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .foregroundColor(Color(Asset.dynamicSecondaryBackground.color))
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 1)
            )
            .padding()
        })
    }
}

struct ExamListCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExamListCard(viewModel: ExamListCardViewModel())
                .background(Color.gray)
        }
    }
}
