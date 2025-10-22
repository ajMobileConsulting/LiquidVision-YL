#  Core ML Phase 1 Feedback

*Date: Tuesday, October 21, 2025*

Score: **80%** 

Overview:

| Key | Meaning |
| :-: | :-: |
| ❌ | Wrong Approach |
| ⁉️ | Questionable Approach |
| ✅ | Excellent Approach |
| N/A | Decision could differ | 

| Category | Points/Weight|
| :-: | :-: |
| Functionality | 23/30 |
| Code Quality | 15/20 |
| Performance | 12/15 |
| Testing | 10/15 |
| UI/UX Design (Apple HIG Standards) | 10/10 | 
| Documentation | 10/10 |
| Total | 80/100 |


Feedback: 
- Here I see you are using MVVM+C architecture where Coordinator is a compositional protocol to handle starting or showing a particular view.
    - ⁉️ Given that you are handling this. TabView and Coordinator should work together yes but best practice would be to separate this view into a RootView for the tabs and segregate the details to maintain SRP
    - ✅ Functionality is correct but we need to still extract. 
    - ❌ We would not practice building views directly in coordinator
    - ⁉️ Purpose for Scene and View segrgation in this implementation? 

- `ClassificationCoordinator` 
    - ⁉️ has multiple materials should we consider using clean architecture so we can hae a use case? What are all responsibilities of a coordinator
    - ⁉️ Should corrdinator build views? `@ViewBuilder`
    - ⁉️ Let's not use `@MainActor` on entire class. Usually we only have 1 function that needs to be sent to main thread so let's only wrap that function.
    - ⁉️ Why do we need to return AnyView if it will always be SentimentView? please explain (same in AppCoordinator look into using RootView)

     
- `SentimentCoordinator`
    - ⁉️ Why do we need to return AnyView if it will always be SentimentView? please explain (same in AppCoordinator look into using RootView)

- `MobileNetImageClassifier`
    - ✅ Great use of an actor here this is exactly how we would want to handle so we don't have wavering results. 
    - ⁉️ Is there any use case where we would need more the `result.first`
     
- `ClassificationViewModel`
    - ❌ minimize `@Published` variables in your view models we should be able to minimze down to 1.
    - ⁉️ `@MainActor` details mentioned above should also apply here
    
- `SentimentViewModel`
    - ❌ minimize `@Published` variables in your view models we should be able to minimze down to 1.
    - ⁉️ `@MainActor` details mentioned above should also apply here
    


 
# Test Examples
| Result | Image | 
| :----: | ----: |
| ❌ | <picture>  <img src="Test_1.PNG" alt="Flowers" style="width:25%;"> </picture> |
| ❌ | <picture>  <img src="Test_2.PNG" alt="Flowers" style="width:25%;"> </picture> |
| ✅ | <picture>  <img src="Test_3.PNG" alt="Flowers" style="width:25%;"> </picture> |
