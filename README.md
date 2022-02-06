# FEProblem iOS App

This is a sample app developed using UIKit framework and having support of minimum iOS version 13.

While developing I have used Clean Swift Architechture and URL Caching that is listed below. 

- [x] [Clean Swift](https://clean-swift.com/)
     - Clean Swift Architechture satisfies SOLID principles and it decouple class responsibility with well established boundries(More easy to test and suitable for TDD), each class has it's own responsibilities and it can be achieved through sepration of concerns using protocols.
     - In Clean Swift, your project structure is built around scenes and we have a set of components in each scene that will "work" for our controller. Following are the components<br /> 
      * **Models**<br /> 
      * **Router**<br /> 
      * **Worker**<br /> 
      * **Interactor**<br /> 
      * **Presenter**<br /> <br /> 

- [x] Cached option with **URLCache**
     - To reduce the redundant API calls I've used URLCache to store respone for a particular day. Below are the steps to achive that,
          - Step 1: Retrive URL Reponse cached for url request
          - Step 2: Check if URL Reponse cached is of same day
                   - If data is of same day return clouser with cached data
          - Step 3: If response data found then cache those data
          - Step 4: Return local cache data if error occuered OR Data not available

## Minimum Project Requirements 
Project build on Xcode 12.5.1

## Project Structure
<img width="395" alt="Screenshot 2022-02-07 at 12 57 10 AM" src="https://user-images.githubusercontent.com/3881137/152697967-d5e2a2aa-be47-4050-a63c-b1ea7d3ffe25.png">

- **Models** Folder contains DataModel Classes
- **Scenes** Folder contains all the screens files e.g ViewController, Intractor, Presenter, Router and Model claess for each screen
- **Network Manager** Folder Network Service related classes
- **HelperClass** Folder contails Extetions, Custom Reviews and Utility Classes



## App UI Screens
Dashboard 
![Simulator Screen Shot - iPhone 12 - 2022-02-07 at 00 58 51](https://user-images.githubusercontent.com/3881137/152698024-3f1030a5-b5ed-4676-8f0f-d908897cabb8.png)

Missions
![Simulator Screen Shot - iPhone 12 - 2022-02-06 at 22 44 29](https://user-images.githubusercontent.com/3881137/152698058-b2785624-ba2d-40f3-b7ab-b3684a1bde14.png)

Option Selection
![Simulator Screen Shot - iPhone 12 - 2022-02-06 at 22 44 37](https://user-images.githubusercontent.com/3881137/152698094-a66f6481-7a83-458c-bd17-106d918ea930.png)

![Simulator Screen Shot - iPhone 12 - 2022-02-06 at 22 44 33](https://user-images.githubusercontent.com/3881137/152698083-e43b3baf-4817-43d9-8421-cf7cf093b451.png)

Result Screen 
![Simulator Screen Shot - iPhone 12 - 2022-02-06 at 22 44 23](https://user-images.githubusercontent.com/3881137/152698102-ed7affa3-54cf-4b08-b078-bec4ec081713.png)

![Simulator Screen Shot - iPhone 12 - 2022-02-06 at 23 11 54](https://user-images.githubusercontent.com/3881137/152698106-25d8398d-78a7-4060-bb43-81866b2a437e.png)
