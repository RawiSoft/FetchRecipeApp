### Summary:
a simple app to download recipes form a server and display them in a list with the ability to filter and viewing details!

![Demo GIF](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExbjZjYWdmcTcwb3dmdzQxZ3VzMGh6anFwMXc0NWc4ZXQ4bzg5bWwweCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/i1vJ0B5Mgyw68B0vmm/giphy.gif)

### Focus Areas: 
I prioritized several key areas for the project:

Networking and Error Handling: Creating a robust and async network layer that uses protocols for dependency injection to facilitate testing. 
Data Decoding and State Management: Building reliable decoding logic and managing state effectively with @Published properties.
Caching: Using a simple NSCache for efficient image caching.
This approach ensures that the app remains responsive, modular, and easy to maintain.

### Time Spent:
I spent approximately 4 hours on the project:

2 hours on setting up the project, creating network and image services.
1 hour building UI views and implementing state management.
1 hour on testing, debugging, and documentation.

### Trade-offs and Decisions:
I used custom image caching to have more contol instead of relying on URLSession caching.
The ImageService uses a singleton pattern.

While this simplifies access, it makes testing harder and prevents dependency injection. 
A dependency-injected instance would be more testable.

Using CodingKeys in Recipe means that any backend change in key names could break decoding, but I used it for simplicity.
A more flexible approach (e.g., JSONSerialization with optional lookups) might be better for handling evolving APIs.

### Weakest Part of the Project:
I think it is the error handling, it needs logging, and properly handling all the senarios, currently it covers the main senarios.

