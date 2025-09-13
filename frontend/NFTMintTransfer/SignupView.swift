//
//  SignupView.swift
//  NFTMintTransfer
//
//  Created by 이민석 on 9/8/25.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var vm = SignupViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("회원가입")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("이메일").font(.caption).foregroundStyle(.secondary)
                    TextField("이메일을 입력하세요", text: $vm.email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("닉네임").font(.caption).foregroundStyle(.secondary)
                    TextField("2자 이상 10자 이하", text: $vm.nickname)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("비밀번호").font(.caption).foregroundStyle(.secondary)
                    SecureField("8자 이상", text: $vm.password)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("비밀번호 확인").font(.caption).foregroundStyle(.secondary)
                    SecureField("비밀번호를 다시 입력하세요", text: $vm.confirmPassword)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("프로필 이미지 (선택사항)").font(.caption).foregroundStyle(.secondary)
                    
                    HStack {
                        if let image = vm.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Button("이미지 선택") {
                                showingImagePicker = true
                            }
                            .foregroundColor(.blue)
                            
                            if vm.selectedImage != nil {
                                Button("이미지 제거") {
                                    vm.selectedImage = nil
                                }
                                .foregroundColor(.red)
                                .font(.caption)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                Button(action: {
                    Task {
                        await vm.signup()
                    }
                }) {
                    HStack {
                        if vm.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                        Text(vm.isLoading ? "가입 중..." : "회원가입")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(vm.isFormValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .disabled(!vm.isFormValid || vm.isLoading)
                
                if let error = vm.error {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $vm.selectedImage)
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    SignupView()
}
