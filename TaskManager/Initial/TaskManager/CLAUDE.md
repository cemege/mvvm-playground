# TaskManager Interview Project - Claude's Notes

## Project Overview
This is a TaskManager iOS app created as a sample study case for live coding interviews. The app intentionally contains code smells, anti-patterns, and missing features that candidates should identify and refactor.

## Architecture Issues Implemented (Intentional Code Smells)
- **Massive View Controller**: All logic crammed into ViewController
- **Poor MVVM Implementation**: Tight coupling between View and ViewModel
- **No Separation of Concerns**: Business logic mixed with UI logic
- **Poor Naming Conventions**: Variables and methods with unclear names
- **Magic Numbers**: Hardcoded values throughout the code
- **No Data Persistence**: Tasks stored in memory only
- **No Input Validation**: No validation for task creation/editing
- **Poor Error Handling**: Minimal or no error handling
- **Accessibility Issues**: Missing accessibility labels and identifiers
- **Code Duplication**: Repeated logic in multiple places

## Missing Features (Interview Tasks)
1. **Task Editing**: Currently can only add/delete, no editing functionality
2. **Data Persistence**: Tasks lost on app restart
3. **Task Categories**: No way to categorize tasks
4. **Due Dates**: No date management for tasks
5. **Task Priority**: No priority levels
6. **Search/Filter**: No way to search or filter tasks
7. **Input Validation**: No validation for empty or invalid inputs
8. **Error Handling**: No proper error states or user feedback
9. **Unit Tests**: No test coverage
10. **Accessibility**: Poor accessibility support

## Expected Refactoring Areas
1. **MVVM Separation**: Proper ViewModel implementation
2. **Data Layer**: Add Repository pattern for data management
3. **Dependency Injection**: Remove tight coupling
4. **Protocol-Oriented Design**: Use protocols for testability
5. **Proper Error Handling**: Implement comprehensive error handling
6. **Code Organization**: Split into logical components
7. **Constants Management**: Replace magic numbers with constants
8. **Memory Management**: Proper retain cycle handling
9. **Networking Layer**: If adding remote persistence
10. **UI/UX Improvements**: Better user experience and accessibility

## File Structure Created
- `TaskManager/TaskItem.swift` - Poor model implementation with bad naming conventions
- `TaskManager/TaskViewModel.swift` - Tightly coupled ViewModel with UIKit dependencies
- `TaskManager/ViewController.swift` - Massive view controller with all logic (260+ lines)
- UI elements created programmatically with poor naming and accessibility
- `CLAUDE.md` - This documentation file for project notes and memory

## Interview Evaluation Points
- Can the candidate identify the architectural problems?
- Do they know MVVM best practices?
- Can they implement proper separation of concerns?
- Do they write testable code?
- Can they identify and fix performance issues?
- Do they consider accessibility and user experience?
- How do they handle error states?
- Do they follow Swift coding conventions?

## Build Commands
- Build: Cmd+B in Xcode
- Run: Cmd+R in Xcode
- Test: Cmd+U in Xcode

## Notes for Future Development
- Current implementation is intentionally poor for interview purposes
- All hint comments have been removed to ensure authentic discovery process
- Candidates should refactor, not rewrite from scratch
- Focus on incremental improvements with explanation of decisions
- Should maintain existing functionality while improving architecture
- Code smells must be discovered through code analysis, not comments