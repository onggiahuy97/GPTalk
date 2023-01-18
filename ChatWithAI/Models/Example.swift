//
//  Example.swift
//  ChatWithAI
//
//  Created by Huy Ong on 1/13/23.
//

import Foundation


struct Example: Identifiable {
    var id: String { title }
    let title: String
    let systemImage: String
    let prompt: String
    let reponse: String
    var description: String = ""
}

extension Example {
    static let list: [Example] = {
        [
            notesToSummary,
            ideaGeneration,
            essayOutline,
            createStudyNotes,
            restaurantReview,
            interviewQuestions,
            grammarCorrection,
            summarizeAText,
            englishToOtherLanguage,
            movieToEmoji,
            detectSentiment,
            adFromProduct,
            productNameGenerator,
            friendChat
        ]
    }()
}

extension Example {
    static let grammarCorrection = Example(
        title: "Grammar Correction",
        systemImage: "graduationcap",
        prompt: "Correct this standard English:\n\nShe no went to the market.",
        reponse: "She did not go to the market",
        description: "Corrects sentences into standard English."
    )
    
    static let summarizeAText = Example(
        title: "Summarize for a 2nd grader",
        systemImage: "forward",
        prompt: "Summarize this for a second-grade student:\n\nJupiter is the fifth planet from the Sun and the largest in the Solar System. It is a gas giant with a mass one-thousandth that of the Sun, but two-and-a-half times that of all the other planets in the Solar System combined. Jupiter is one of the brightest objects visible to the naked eye in the night sky, and has been known to ancient civilizations since before recorded history. It is named after the Roman god Jupiter.[19] When viewed from Earth, Jupiter can be bright enough for its reflected light to cast visible shadows,[20] and is on average the third-brightest natural object in the night sky after the Moon and Venus.",
        reponse: "Jupiter is the fifth planet from the Sun and is very big and bright. It can be seen with our eyes in the night sky and it has been known since ancient times. Its name comes from the Roman god Jupiter. It is usually the third brightest object in the night sky after the Moon and Venus.",
        description: "Translates difficult text into simpler concepts."
    )
    
    static let englishToOtherLanguage = Example(
        title: "English to other languages",
        systemImage: "globe",
        prompt: "Translate this into 1. French, 2. Spanish and 3. Japanese: \n\nWhat rooms do you have available?\n\n1.",
        reponse: "Quels sont les chambres que vous avez disponibles?\n2. ¿Qué habitaciones tienes disponibles?\n3. どの部屋が利用可能ですか？",
    description: "Translates English text into French, Spanish and Japanese."
    )
    
    static let movieToEmoji = Example(
        title: "Movie to Emoji",
        systemImage: "face.smiling",
        prompt: "Convert movie titles into emoji.\n\nBack to the Future: 👨👴🚗🕒\nBatman: 🤵🦇\nTransformers:\n🚗🤖Star Wars:",
        reponse: "⭐️⚔",
        description: "Convert movie titles into emoji."
    )
    
    static let detectSentiment = Example(
           title: "Detect Sentiment",
           systemImage: "number",
           prompt: "Classify the sentiment in these tweets:\n1. \"I can't stand homework\"\n2. \"This sucks. I'm bored 😠\"\n3. \"I can't wait for Halloween!!!\"\n4. \"My cat is adorable ❤️❤️\"\n5. \"I hate chocolate\"\nTweet sentiment ratings:",
           reponse: "1. Negative\n2. Negative\n3. Positive\n4. Positive\n5. Negative",
           description: "This is an advanced prompt for detecting sentiment. It allows you to provide it with a list of status updates and then provide a sentiment for each one."
       )
    
        static let adFromProduct = Example(
            title: "Ad from product description",
            systemImage: "speaker",
            prompt: "Write a creative ad for the following product to run on Facebook aimed at parents:\n\nProduct: Learning Room is a virtual environment to help students from kindergarten to high school excel in school.",
            reponse: "Are you looking for a way to give your child a head start in school? Look no further than Learning Room! Our virtual environment is designed to help students from kindergarten to high school excel in their studies. Our unique platform offers personalized learning plans, interactive activities, and real-time feedback to ensure your child is getting the most out of their education. Give your child the best chance to succeed in school with Learning Room!",
            description: "Turn a product description into ad copy."
        )
    
        static let productNameGenerator = Example(
            title: "Product name generator",
            systemImage: "lightbulb",
            prompt: "Product description: A home milkshake maker\nSeed words: fast, healthy, compact.\nProduct names: HomeShaker, Fit Shaker, QuickShake, Shake Maker\n\nProduct description: A pair of shoes that can fit any foot size.\nSeed words: adaptable, fit, omni-fit.",
            reponse: "Product names: AdaptFit, OmniSecure, Fit-All, AdaptShoes.",
            description: "Create product names from examples words. Influenced by a community prompt."
        )
    
        static let friendChat = Example(
            title: "Friend Chat",
            systemImage: "ellipsis.bubble",
            prompt: "You: What have you been up to?\nFriend: Watching old movies.\nYou: Did you watch anything interesting?\nFriend:",
            reponse: "Yeah, I watched an old classic called Casablanca. It was really good!",
            description: "Emulate a text message conversation."
        )
    
        static let notesToSummary = Example(
            title: "Notes to summary",
            systemImage: "square.and.pencil",
            prompt: "Convert my short hand into a first-hand account of the meeting:\n\nTom: Profits up 50%\nJane: New servers are online\nKjel: Need more time to fix software\nJane: Happy to help\nParkman: Beta testing almost done",
            reponse: "At the meeting, Tom reported that profits had increased by 50%. Jane then mentioned that the new servers were online. Kjel mentioned that they needed more time to fix the software, and Jane offered to help. Finally, Parkman reported that the beta testing was almost done.",
            description: "Turn meeting notes into a summary."
        )
    
        static let ideaGeneration = Example(
            title: "Generate Idea",
            systemImage: "lightbulb.led.wide",
            prompt: "Brainstorm some ideas combining VR and fitness:",
            reponse: "1. Virtual reality-based fitness classes\n2. Home workout programs using virtual reality technology\n3. Interactive video game-style workouts with a virtual trainer\n4. Virtual running races against other players in VR worlds\n5. Immersive yoga and Pilates sessions set in exotic locations\n6. Sports simulations involving simulated physical activity within the VR world\n7. Group fitness challenges that involve competing against opponents in a virtual environment\n8. Adaptive exercise programs tailored to individual’s goals or health conditions",
            description: "Create ideas for fitness and virtual reality games."
        )
    
        static let essayOutline = Example(
            title: "Essay Outline",
            systemImage: "doc.text",
            prompt: "Create an outline for an essay about Nikola Tesla and his contributions to technology:",
            reponse: "I. Introduction\nA. Who was Nikola Tesla?\nB. Overview of his contributions to technology\n\nII. Early Life and Education\nA. Where and when Tesla was born\nB. His education and early career\n\nIII. Tesla's Contributions to Technology\nA. Alternating Current\nB. Radio and Remote Control\nC. Robotics\nD. X-Rays\n\nIV. Tesla's Later Years\nA. His later inventions\nB. His death and legacy\n\nV. Conclusion\nA. Summary of Tesla's life and accomplishments\nB. Impact of Tesla's work on modern technology",
            description: "Generate an outline for a research topic."
        )
    
    static let createStudyNotes = Example(
        title: "Create study notes",
        systemImage: "rectangle.stack",
        prompt: "What are 5 key points I should know when studying Ancient Rome?",
        reponse: "1. Understand the Roman Republic and its political and social structures.\n2. Learn about the major events and people of the Roman Empire, including the Pax Romana.\n3. Familiarize yourself with Roman culture and society, including language, art, architecture, literature, law, and religion.\n4. Study the Roman military, its tactics and organization, and its effects on the empire.\n5. Examine the decline of the Roman Empire, its eventual fall, and its legacy.",
        description: "Provide a topic and get study notes."
    )
    
        static let restaurantReview = Example(
            title: "Restaurant reivew creator",
            systemImage: "newspaper",
            prompt: "Write a restaurant review based on these notes:\n\nName: The Blue Wharf\nLobster great, noisy, service polite, prices good.\n\nReview:",
            reponse: "I recently visited The Blue Wharf and had a wonderful experience. The lobster was excellent and the prices were very good. The only downside was the noise level, but the polite service more than made up for it. Highly recommend!",
            description: "Turn a few words into a restaurant review."
        )
    
        static let interviewQuestions = Example(
            title: "Interview Questions",
            systemImage: "bag",
            prompt: "Create a list of 8 questions for my interview with a science fiction author:",
            reponse: "1. What inspired you to write science fiction?\n2. What themes do you typically explore in your work?\n3. How has the genre of science fiction evolved over time?\n4. What do you think sets your work apart from other science fiction authors?\n5. What advice would you give to aspiring science fiction authors?\n6. What are some of the most challenging aspects of writing science fiction?\n7. How has your writing process changed over the years?\n8. What do you think is the most important thing for readers to take away from your work?",
            description: "Create interview questions."
        )
}
