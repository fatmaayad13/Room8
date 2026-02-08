//
//  SignUpEmailView.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI

struct SignUpEmailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var phone = ""

    @State private var showPassword = false
    @State private var showConfirm = false

    enum Field { case email, password, confirm, phone }
    @FocusState private var focused: Field?

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.navy)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.top, 8)

                Spacer().frame(height: 30)

                Room8LogoHeader(height: 160)

                Spacer().frame(height: 14)

                Text("Create an account")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Theme.navy)

                Spacer().frame(height: 22)

                card
                    .frame(maxWidth: 340)
                    .padding(.horizontal, 20)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var card: some View {
        VStack(spacing: 14) {
            inputField(title: "Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .submitLabel(.next)
                .focused($focused, equals: .email)
                .onSubmit { focused = .password }

            passwordField(title: "Password", text: $password, isVisible: $showPassword)
                .textContentType(.newPassword)
                .submitLabel(.next)
                .focused($focused, equals: .password)
                .onSubmit { focused = .confirm }

            passwordField(title: "Confirm password", text: $confirmPassword, isVisible: $showConfirm)
                .textContentType(.newPassword)
                .submitLabel(.next)
                .focused($focused, equals: .confirm)
                .onSubmit { focused = .phone }

            inputField(title: "Phone", text: $phone)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .focused($focused, equals: .phone)

            Button {
                Task { await auth.login(email: email, password: password) }
            } label: {
                Text("Sign me up!")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Theme.terracotta.opacity(0.85))
                    .cornerRadius(16)
            }
            .buttonStyle(.plain)
            .padding(.top, 6)
        }
        .padding(22)
        .background(Theme.sand.opacity(0.45))
        .cornerRadius(26)
    }

    private func inputField(title: String, text: Binding<String>) -> some View {
        TextField(title, text: text)
            .padding(.horizontal, 18)
            .frame(height: 54)
            .background(Color.white.opacity(0.95))
            .cornerRadius(18)
            .foregroundColor(.black.opacity(0.85))
    }

    private func passwordField(title: String, text: Binding<String>, isVisible: Binding<Bool>) -> some View {
        HStack {
            Group {
                if isVisible.wrappedValue {
                    TextField(title, text: text)
                } else {
                    SecureField(title, text: text)
                }
            }

            Button { isVisible.wrappedValue.toggle() } label: {
                Image(systemName: isVisible.wrappedValue ? "eye.slash" : "eye")
                    .foregroundColor(.black.opacity(0.55))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 18)
        .frame(height: 54)
        .background(Color.white.opacity(0.95))
        .cornerRadius(18)
        .foregroundColor(.black.opacity(0.85))
    }
}

