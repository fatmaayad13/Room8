//
//  LoginView.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false

    @State private var goToSignUp = false

    enum Field { case email, password }
    @FocusState private var focused: Field?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer().frame(height: 70)

                    Image("room8_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)

                    Spacer().frame(height: 18)

                    Text("Welcome back!")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Theme.navy)

                    Spacer().frame(height: 26)

                    loginCard
                        .frame(maxWidth: 340)
                        .padding(.horizontal, 20)

                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $goToSignUp) {
                SignUpView()
                    .environmentObject(auth)
            }
        }
    }

    private var loginCard: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .submitLabel(.next)
                .focused($focused, equals: .email)
                .onSubmit { focused = .password }
                .padding(.horizontal, 18)
                .frame(height: 58)
                .background(Color.white)
                .cornerRadius(18)

            HStack {
                Group {
                    if showPassword {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                }
                .submitLabel(.go)
                .focused($focused, equals: .password)
                .onSubmit {
                    Task { await auth.login(email: email, password: password) }
                }

                Button { showPassword.toggle() } label: {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.black.opacity(0.55))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 18)
            .frame(height: 58)
            .background(Color.white)
            .cornerRadius(18)

            HStack {
                Spacer()
                Button("Forgot password?") {}
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black.opacity(0.45))
                    .buttonStyle(.plain)
            }

            OrDivider()

            HStack(spacing: 22) {
                IconOnlySocialButton(assetName: "facebook_logo") { }
                    .frame(width: 66, height: 66)

                IconOnlySocialButton(assetName: "google_logo") { }
                    .frame(width: 66, height: 66)

                IconOnlySystemButton(systemName: "apple.logo") { }
                    .frame(width: 66, height: 66)
            }

            HStack(spacing: 6) {
                Text("Don’t have an account?")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.black.opacity(0.55))

                Button("Sign up") { goToSignUp = true }
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.black)
                    .buttonStyle(.plain)
            }
            .padding(.top, 6)
        }
        .padding(22)
        .background(Theme.sand.opacity(0.45))
        .cornerRadius(26)
    }
}
