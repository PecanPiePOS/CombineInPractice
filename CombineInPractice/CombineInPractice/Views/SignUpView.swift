//
//  SignUpView.swift
//  CombineInPractice
//
//  Created by KYUBO A. SHIM on 12/10/23.
//

import SwiftData
import SwiftUI

struct SignUpView: View {
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @State private var idText: String = ""
    @State private var passwordText: String = ""
    
    var body: some View {
        NavigationStack {
            GeometryReader(content: { geometry in
                VStack {
                    Spacer()
                        .frame(height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    HStack {
                        Text("Id")
                            .padding(.leading ,30)
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                
                    TextField("Hello", text: $idText, prompt: Text("Put Id here."), axis: .vertical)
                        .frame(minHeight: 60)
                        .padding(.leading, 15)
                        .clearButtonOn(text: $idText)
                        .overlay(RoundedRectangle(cornerRadius: 25, style: .continuous).stroke(.black, lineWidth: 2.0))
                        .padding(.horizontal, 15)
                    
                    Spacer()
                        .frame(height: 25)
                    
                    HStack {
                        Text("Password")
                            .padding(.leading ,30)
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                
                    SecureField("Put Password here.", text: $passwordText)
                        .frame(minHeight: 60)
                        .padding(.leading, 15)
                        .overlay(RoundedRectangle(cornerRadius: 25, style: .continuous).stroke(.black, lineWidth: 2.0))
                        .padding(.horizontal, 15)
                    
                    Button("Color Scheme 바꾸기") {
                        isDarkMode.toggle()
                    }
                    .padding()
                    
                    Spacer()
                }
                .preferredColorScheme(isDarkMode ? .dark: .light)
            })
            .navigationTitle("SignUp")
            .preferredColorScheme(isDarkMode ? .dark: .light)
        }
    }
}

#Preview {
    SignUpView()
}


struct TextFieldExample: View {
    @State private var title: String = ""
    @State private var category: String = ""
    @State private var type: String = ""
    
    var body: some View {
        VStack {
            Text("DevTechie Courses")
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text("Enter new course title")
                    .font(.title3)
                TextField("Course title", text: $title)
                    .padding(5)
                    .overlay( RoundedRectangle(cornerRadius: 20) .stroke(Color.orange) )
                TextField("Course category", text: $category)
                    .padding(5)
                    .overlay( RoundedRectangle(cornerRadius: 20) .stroke(Color.teal) )
                TextField("Course type", text: $type) .padding(5) .overlay( RoundedRectangle(cornerRadius: 20) .stroke(Color.pink) ) }.padding(.top, 20)
        }
        .padding()
    }
}
