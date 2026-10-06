# FocusFlow AI

An AI-powered study companion designed to help students build better study habits and make their study time more productive.

## 💡 About the Project

FocusFlow AI is a student-focused productivity application developed during my Flutter development internship.

The application allows students to track their study sessions and subject-wise study activity. The collected data is used as the foundation for personalized insights and machine learning features.

## 🛠️ Tech Stack

### Mobile Application
- Flutter
- Dart
- Provider
- GoRouter
- Sqflite

### Machine Learning
- Python
- Pandas
- NumPy
- Scikit-learn
- Supervised Machine Learning

## 👩‍💻 My Contribution

During my internship, I have contributed to the development of the application, including:

- Built and implemented Flutter UI components and application screens
- Implemented application navigation and user flows
- Used Provider for state management
- Implemented local data storage using Sqflite
- Worked on collecting and organizing subject-wise study-session data
- Currently developing the machine learning component for the application

## 🤖 Machine Learning Component

The first version of the ML component focuses on predicting whether a student is likely to **pass or fail an exam** based on their study-session data for a particular subject.

### Current approach

- Collect subject-wise study-session data from the application
- Prepare and preprocess the collected data
- Use supervised machine learning to learn patterns between study activity and exam outcomes
- Train a binary classification model
- Generate a Pass/Fail prediction for a student

The ML component is currently under development.

## 🏗️ Application Architecture

```text
Flutter Application
       ↓
Provider / Application Logic
       ↓
Sqflite Local Database
       ↓
Student Study-Session Data
       ↓
Data Preparation
       ↓
Machine Learning Model
       ↓
Pass / Fail Prediction
