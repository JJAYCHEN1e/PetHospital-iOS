//
//  WorkflowStepsView.swift
//  PetHospital-iOS
//
//  Created by jjaychen on 2021/4/7.
//

import SwiftUI
import AVKit
import Kingfisher

class WorkflowStepsViewModel: ObservableObject {
    @Published var workflowSteps: [WorkflowStep] = []
}

struct WorkflowStepsView: View {
    
    var workflowID: Int
    
    @ObservedObject private var viewModel = WorkflowStepsViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                Text("术前消毒流程")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("共 \(viewModel.workflowSteps.count) 个步骤")
                    .font(.headline)
                ForEach(viewModel.workflowSteps) { step in
                    VStack {
                        if let picture = step.picture {
                            KFImage(URL(string: picture)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "\(viewModel.workflowSteps.firstIndex(of: step)! + 1).circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.blue)
                                Text(step.name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            Text("文字描述")
                                .font(.headline)
                            Text(step.description)
                                .frame(maxHeight: .infinity)
                            Text("操作视频")
                                .font(.headline)
                            if let video = step.video {
                                VideoPlayer(player: AVPlayer(url: URL(string: video)!))
                                    .aspectRatio(16 / 9, contentMode: .fill)
                            } else {
                                Text("本步骤暂无操作演示视频。")
                            }
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        Color(Asset.dynamicSecondaryBackground.color)
                    )
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 1, y: 1)
                }
            }
            .padding()
        }
        .onAppear {
            let parameter = ["processId": workflowID]
            
            NetworkManager.shared.fetch(endPoint: .workflowSteps, method: .POST, parameters: parameter) { (result: ResultEntity<[WorkflowStep]>?) in
                if let result = result {
                    if result.code == .success, let workflowSteps = result.data {
                        self.viewModel.workflowSteps = workflowSteps
                    } else {
                        print(result)
                    }
                }
            }
        }
    }
}

struct WorkflowStepsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkflowStepsView(workflowID: 1)
    }
}