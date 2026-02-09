//
//  CalendarRootView.swift
//  Room8App
//

import SwiftUI

struct CalendarRootView: View {
    @StateObject private var choreViewModel = ChoreScheduleViewModel()
    @State private var showingAddChore = false
    @State private var selectedDate = Date()
    @State private var selectedView = 0 // 0 = Calendar, 1 = Timeline

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Calendar")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(Theme.navy)
                    Spacer()
                    Button {
                        showingAddChore = true
                    } label: {
                        Circle()
                            .fill(Theme.sage)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, Theme.pad)
                .padding(.top, 16)
                .padding(.bottom, 12)

                // Segmented Control
                Picker("View", selection: $selectedView) {
                    Label("Calendar", systemImage: "calendar").tag(0)
                    Label("Timeline", systemImage: "list.bullet").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, Theme.pad)
                .padding(.bottom, 12)

                // Content based on selection
                if selectedView == 0 {
                    calendarView
                } else {
                    timelineView
                }
            }
        }
        #if os(iOS)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddChore) {
            AddChoreView(viewModel: choreViewModel, isPresented: $showingAddChore)
        }
    }

    // MARK: - Calendar View
    private var calendarView: some View {
        VStack(spacing: 0) {
            // Calendar picker
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding(.horizontal, Theme.pad)
                .tint(Theme.sage)

            // Chores for selected date
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(dateHeader)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Theme.navy)
                        .padding(.horizontal, Theme.pad)
                        .padding(.top, 16)

                    if filteredChores.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 50))
                                .foregroundColor(.gray.opacity(0.3))
                            Text("No chores for this day")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.gray.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        ForEach(filteredChores) { chore in
                            ChoreCardView(chore: chore, viewModel: choreViewModel)
                                .padding(.horizontal, Theme.pad)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Timeline View
    private var timelineView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Today section
                TimelineDateSection(
                    title: "Today",
                    chores: todayChores,
                    viewModel: choreViewModel
                )

                // Upcoming days
                ForEach(upcomingDates, id: \.self) { date in
                    TimelineDateSection(
                        title: formatDateForTimeline(date),
                        chores: choresFor(date: date),
                        viewModel: choreViewModel
                    )
                }
            }
            .padding(.vertical, 16)
        }
    }

    private var dateHeader: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: selectedDate)
    }

    private var filteredChores: [Chore] {
        choreViewModel.chores.filter { chore in
            shouldShowChore(chore, on: selectedDate)
        }
    }

    private func shouldShowChore(_ chore: Chore, on date: Date) -> Bool {
        // Check if it's the original scheduled date
        if Calendar.current.isDate(chore.scheduledDate, inSameDayAs: date) {
            return true
        }

        // For recurring chores, check if the date is a valid recurrence
        guard let frequencyDays = chore.frequency.days else {
            // asNeeded doesn't recur, only shows on scheduled date
            return false
        }

        // Calculate days between scheduled date and selected date
        let calendar = Calendar.current
        let scheduledStart = calendar.startOfDay(for: chore.scheduledDate)
        let selectedStart = calendar.startOfDay(for: date)

        guard let daysDifference = calendar.dateComponents([.day], from: scheduledStart, to: selectedStart).day else {
            return false
        }

        // Only show on future dates (not past dates)
        if daysDifference < 0 {
            return false
        }

        // Check if the date falls on a recurrence interval
        return daysDifference % frequencyDays == 0
    }

    private var todayChores: [Chore] {
        choreViewModel.chores.filter { chore in
            shouldShowChore(chore, on: Date())
        }
    }

    private var upcomingDates: [Date] {
        // Generate next 7 days
        (1...7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: Date()) }
    }

    private func choresFor(date: Date) -> [Chore] {
        choreViewModel.chores.filter { chore in
            shouldShowChore(chore, on: date)
        }
    }

    private func formatDateForTimeline(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: - Timeline Date Section
struct TimelineDateSection: View {
    let title: String
    let chores: [Chore]
    @ObservedObject var viewModel: ChoreScheduleViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date badge
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Theme.sage)
                .cornerRadius(8)
                .padding(.horizontal, Theme.pad)

            // Chores for this date
            if chores.isEmpty {
                Text("No chores scheduled")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black.opacity(0.4))
                    .padding(.horizontal, Theme.pad)
                    .padding(.vertical, 8)
            } else {
                ForEach(chores) { chore in
                    ChoreCardView(chore: chore, viewModel: viewModel)
                        .padding(.horizontal, Theme.pad)
                }
            }
        }
    }
}

// MARK: - Chore Card View
struct ChoreCardView: View {
    let chore: Chore
    @ObservedObject var viewModel: ChoreScheduleViewModel

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(priorityColor.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: priorityIcon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(priorityColor)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(chore.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)

                HStack(spacing: 8) {
                    Text(chore.frequency.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black.opacity(0.5))

                    Text("•")
                        .font(.system(size: 12))
                        .foregroundColor(.black.opacity(0.3))

                    Text(chore.priority.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black.opacity(0.5))
                }
            }

            Spacer()

            Button {
                viewModel.toggleChoreCompletion(chore)
            } label: {
                Image(systemName: chore.isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.system(size: 28))
                    .foregroundColor(chore.isCompleted ? Theme.sage : Theme.sage.opacity(0.5))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(Theme.white)
        .cornerRadius(Theme.cornerL)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    private var priorityColor: Color {
        switch chore.priority {
        case .urgent: return Color.red
        case .high: return Theme.terracotta
        case .medium: return Theme.sage
        case .low: return Theme.sand
        }
    }

    private var priorityIcon: String {
        switch chore.priority {
        case .urgent: return "exclamationmark.triangle.fill"
        case .high: return "exclamationmark.circle.fill"
        case .medium: return "circle.fill"
        case .low: return "circle"
        }
    }
}
