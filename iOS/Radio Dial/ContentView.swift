import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAdd = false
    @State private var showPaywall = false
    @State private var showSettings = false
    @State private var editingItem: Radio?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        Button(action: { editingItem = item }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name).font(Theme.titleFont).foregroundColor(Theme.textPrimary)
                    Text(item.year).font(Theme.bodyFont).foregroundColor(Theme.textMuted)
                    Text(item.status).font(Theme.bodyFont).foregroundColor(Theme.textMuted)
                    Text(item.notes).font(Theme.bodyFont).foregroundColor(Theme.textMuted)
                            }
                            .padding(.vertical, 6)
                        }
                        .accessibilityIdentifier("itemRow_\(item.name)")
                        .listRowBackground(Theme.card)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
            .navigationTitle("Radio Dial")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if store.canAddMore {
                            showAdd = true
                        } else {
                            showPaywall = true
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showAdd) {
                AddRadioView(isPresented: $showAdd)
                    .environmentObject(store)
            }
            .sheet(item: $editingItem) { existing in
                AddRadioView(isPresented: Binding(get: { editingItem != nil }, set: { if !$0 { editingItem = nil } }), editing: existing)
                    .environmentObject(store)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView().environmentObject(purchases)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView().environmentObject(purchases)
            }
        }
        .accentColor(Theme.accent)
    }
}

struct AddRadioView: View {
    @EnvironmentObject var store: Store
    @Binding var isPresented: Bool
    var editing: Radio? = nil

    @State private var draft: Radio = Radio(name: "", year: "", status: "", notes: "")

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $draft.name)
                        .accessibilityIdentifier("field_name")
                    TextField("Year", text: $draft.year)
                    TextField("Status", text: $draft.status)
                    TextField("Notes", text: $draft.notes)
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .navigationTitle(editing == nil ? "Add Radio" : "Edit Radio")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if editing != nil {
                            store.update(draft)
                        } else {
                            store.add(draft)
                        }
                        isPresented = false
                    }
                    .accessibilityIdentifier("saveButton")
                    .disabled(draft.name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let editing { draft = editing }
            }
        }
    }
}
