//
//  Prompt.swift
//  MoneyTracker
//
//  Created by 老人 on 04/08/2022.
//

import SwiftUI

struct Prompt: View {
    @State var i: Int = 0
    @Binding var isShow: Bool
    @State var scale: CGFloat = 1
    var isButton: Bool
    var promptImage: PromptImage
    var title: String
    var message: String?
    
    var offset: CGFloat {
        isShow ? -UIScreen.main.bounds.midY + 100 : -UIScreen.main.bounds.midY - (50)
    }
    
    func toggle() {
        scale = 0

        withAnimation(.slow()) {
            self.i = 0
            self.isShow = true
            scale = 1
        }
    }
    
    func dismiss() {
        withAnimation(.slow()) {
            self.i = 0
            self.isShow = false
        }
    }
    
    var body: some View {
        TimelineView(.animation) { context in
            let second = Calendar.current.component(.second, from: .now)
            
            ZStack {
                if true {
                    RoundedRectangle(cornerRadius: 100)
                        .frame(width: 200, height: 60)
                        .foregroundStyle(.ultraThinMaterial)
                        .colorScheme(.dark)
                        .overlay {
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(lineWidth: 1)
                                .foregroundStyle(.tertiary)
                            
                            PromptItem(scale: $scale, isButton: isButton, promptImage: promptImage, title: title, message: message)
                        }
                        .shadow(color: .black.opacity(0.1), radius: 10, y: 10)
                        .offset(y: offset)
                        
                        .onChange(of: second) { second in
                            i+=1
                            if i>=5 {
                                dismiss()
                            }
                        }
                        .onChange(of: isShow) { _ in
                            if isShow {
                                toggle()
                            }
                        }
                        .animation(.slow(), value: isShow)
                        
                }
            }
        }
    }
}

struct Prompt_Previews: PreviewProvider {
    static var previews: some View {
        Prompt(isShow: .constant(true), isButton: false, promptImage: .alert, title: "Title")
    }
}

struct PromptItem: View {
    @Binding var scale: CGFloat
    var isButton: Bool
    var promptImage: PromptImage
    var title: String
    var message: String?
    var body: some View {
        HStack {
            Image(systemName: promptImage.rawValue)
                .imageScale(.large)
                .scaleEffect(scale)
                 
            VStack(alignment: .leading) {
                Text(title).font(.title3)
                if let message = message {
                    Text(message)
                        .font(.caption)
                        .lineLimit(1)
                        .opacity(0.7)
                }
            }
            
            if isButton {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
        
        .colorScheme(.dark)
    }
}

enum PromptImage: String {
case success = "checkmark.circle.fill"
case alert = "exclamationmark.triangle.fill"
    case deleted = "trash.fill"
    case favorited = "star.fill"
    case unFavorited = "star.slash.fill"
    case add = "plus"
}
