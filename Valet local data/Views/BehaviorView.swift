//
//  BehaviorView.swift
//  Valet local data
//
//  Created by Анастасия Степаносова on 26.12.2023.
//

import SwiftUI

struct BehaviorView: View {
    @State private var selectedBehavior = "Outside"
  //  @State private var selectedBehavior = "Inside"

    // Outside Behaviors - Leash Walking
    @State private var leashWalkingPulling: Double = 5
    @State private var leashWalkingPullingComment: String = ""
    @State private var leashWalkingChewing: Double = 5
    @State private var leashWalkingChewingComment: String = ""

    // Outside Behaviors - Reactivity
    @State private var reactivityStrangers: Double = 5
    @State private var reactivityStrangersComment: String = ""
    @State private var reactivityCarsBikes: Double = 5
    @State private var reactivityCarsBikesComment: String = ""
    // ... Continue with 'Dogs', 'Cats', 'Noises'

    // Outside Behaviors - Recall
    @State private var recallRating: Double = 5
    @State private var recallComment: String = ""

    // Outside Behaviors - Eating Shit
    @State private var eatingShitRating: Double = 5
    @State private var eatingShitComment: String = ""
    // Inside Behaviors - Home Alone
        @State private var homeAloneChewing: Double = 5
        @State private var homeAloneChewingComment: String = ""
        @State private var homeAlonePoopingPeeing: Double = 5
        @State private var homeAlonePoopingPeeingComment: String = ""

        // Inside Behaviors - Reaction to Vacuum
        @State private var vacuumReaction: Double = 5
        @State private var vacuumReactionComment: String = ""

        // Inside Behaviors - Noises Outside
        @State private var outsideNoisesBarking: Double = 5
        @State private var outsideNoisesBarkingComment: String = ""
        @State private var outsideNoisesHiding: Double = 5
        @State private var outsideNoisesHidingComment: String = ""

        // Inside Behaviors - Greeting Guests
        @State private var greetingGuestsOverexcited: Double = 5
        @State private var greetingGuestsOverexcitedComment: String = ""
        @State private var greetingGuestsAggressive: Double = 5
        @State private var greetingGuestsAggressiveComment: String = ""

        // Inside Behaviors - Stealing Items/Food
        @State private var stealingItems: Double = 5
        @State private var stealingItemsComment: String = ""
        @State private var stealingFood: Double = 5
        @State private var stealingFoodComment: String = ""


    var body: some View {
        NavigationView {
            Form {
                Picker("Behavior Type", selection: $selectedBehavior) {
                    Text("Outside").tag("Outside")
                    Text("Inside").tag("Inside")
                }
                .pickerStyle(SegmentedPickerStyle())

                if selectedBehavior == "Outside" {
                    outsideBehaviorSection()
                }
                if selectedBehavior == "Inside" {
                                    insideBehaviorSection()
                                }
                Button("Save Results") {
                                    saveResults()
                                }
                
                NavigationLink("View Saved Results", destination: SavedResultsView())
                
            }
            .navigationBarTitle("Dog Behavior")
        }
    }

    private func saveResults() {
        var behaviorData: [String: Any] = [:]
        
        behaviorData ["LeashWalkingPulling"] = leashWalkingPulling
        behaviorData  ["LeashWalkingPullingComment"] = leashWalkingPullingComment
        behaviorData ["LeashWalkingChewing"] = leashWalkingChewing
        behaviorData  ["LeashWalkingChewingComment"] = leashWalkingChewingComment
        behaviorData  ["ReactivityStrangers"] = reactivityStrangers
        behaviorData  ["ReactivityStrangersComment"] = reactivityStrangersComment
        behaviorData  ["ReactivityCarsBikes"] = reactivityCarsBikes
        behaviorData  [ "ReactivityCarsBikesComment"] =  reactivityCarsBikesComment
            // ... Continue with all other outside behavior states
        behaviorData   ["HomeAloneChewing"] = homeAloneChewing
        behaviorData  ["HomeAloneChewingComment"] =  homeAloneChewingComment
        behaviorData  ["HomeAlonePoopingPeeing"] = homeAlonePoopingPeeing
        behaviorData  [ "HomeAlonePoopingPeeingComment"] =  homeAlonePoopingPeeingComment
        behaviorData  [ "VacuumReaction"] = vacuumReaction
        behaviorData  [ "VacuumReactionComment"] =  vacuumReactionComment
        behaviorData  [ "OutsideNoisesBarking"] =  outsideNoisesBarking
        behaviorData   ["OutsideNoisesBarkingComment"] = outsideNoisesBarkingComment
        behaviorData   ["OutsideNoisesHiding"] = outsideNoisesHiding
        behaviorData   ["OutsideNoisesHidingComment"] = outsideNoisesHidingComment
        behaviorData   ["GreetingGuestsOverexcited"] = greetingGuestsOverexcited
        behaviorData   ["GreetingGuestsOverexcitedComment"] = greetingGuestsOverexcitedComment
        behaviorData   ["GreetingGuestsAggressive"] = greetingGuestsAggressive
        behaviorData ["GreetingGuestsAggressiveComment"] = greetingGuestsAggressiveComment
        behaviorData ["StealingItems"] = stealingItems
        behaviorData  ["StealingItemsComment"] = stealingItemsComment
        behaviorData  ["StealingFood"] = stealingFood
        behaviorData  ["StealingFoodComment"] = stealingFoodComment
            // ... Add additional behaviors as needed
        

        UserDefaults.standard.set(behaviorData, forKey: "DogBehaviorData")
        print("Results saved to UserDefaults.")
    }
    
    private func outsideBehaviorSection() -> some View {
        Section(header: Text("Outside Behavior")) {
            behaviorSlider(label: "Leash Walking - Pulling", rating: $leashWalkingPulling, comment: $leashWalkingPullingComment)
            behaviorSlider(label: "Leash Walking - Chewing", rating: $leashWalkingChewing, comment: $leashWalkingChewingComment)
            behaviorSlider(label: "Reactivity - Strangers", rating: $reactivityStrangers, comment: $reactivityStrangersComment)
            behaviorSlider(label: "Reactivity - Cars/Bikes", rating: $reactivityCarsBikes, comment: $reactivityCarsBikesComment)
            // ... Continue with sliders for 'Dogs', 'Cats', 'Noises'
            behaviorSlider(label: "Recall", rating: $recallRating, comment: $recallComment)
            behaviorSlider(label: "Eating Shit", rating: $eatingShitRating, comment: $eatingShitComment)
        }
    }
    
    private func insideBehaviorSection() -> some View {
            Section(header: Text("Inside Behavior")) {
                behaviorSlider(label: "Home Alone - Chewing", rating: $homeAloneChewing, comment: $homeAloneChewingComment)
                behaviorSlider(label: "Home Alone - Pooping/Peeing", rating: $homeAlonePoopingPeeing, comment: $homeAlonePoopingPeeingComment)
                behaviorSlider(label: "Reaction to Vacuum", rating: $vacuumReaction, comment: $vacuumReactionComment)
                behaviorSlider(label: "Noises Outside - Barking", rating: $outsideNoisesBarking, comment: $outsideNoisesBarkingComment)
                behaviorSlider(label: "Noises Outside - Hiding/Shivering", rating: $outsideNoisesHiding, comment: $outsideNoisesHidingComment)
                behaviorSlider(label: "Greeting Guests - Overexcited", rating: $greetingGuestsOverexcited, comment: $greetingGuestsOverexcitedComment)
                behaviorSlider(label: "Greeting Guests - Aggressive", rating: $greetingGuestsAggressive, comment: $greetingGuestsAggressiveComment)
                behaviorSlider(label: "Stealing Items", rating: $stealingItems, comment: $stealingItemsComment)
                behaviorSlider(label: "Stealing Food", rating: $stealingFood, comment: $stealingFoodComment)
            }
        }

    private func behaviorSlider(label: String, rating: Binding<Double>, comment: Binding<String>) -> some View {
        VStack {
            Text("\(label): \(Int(rating.wrappedValue))")
            Slider(value: rating, in: 1...10, step: 1)
            TextField("Comment", text: comment)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

struct BehaviorView_Previews: PreviewProvider {
    static var previews: some View {
        BehaviorView()
    }
}
