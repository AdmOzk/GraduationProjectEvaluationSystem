# Graduation Project Evaluation System

The **Graduation Project Evaluation System** is an integrated platform designed to streamline the entire process of graduation project management, from submission and evaluation to scheduling presentations. 
This system facilitates seamless interaction between professors and students through web and mobile interfaces, ensuring an efficient workflow for both parties.

## Features

### For Professors

- **Set Availability:** Professors can log into the web platform to set their available hours for project evaluations. This information is then used to automatically schedule presentation dates.
- **Evaluate and Grade Projects:** Through the mobile application, professors can evaluate projects submitted by students, assign grades, and provide feedback.
- **View Project Details:** Professors have access to detailed project information and can track the progress of evaluations directly from the mobile app.

### For Students

- **View Documents and Guidelines:** Students can access all necessary documents, guidelines, and submission requirements on the web platform.
- **Project Submission:** Students can upload their graduation projects directly through the website, ensuring a smooth and straightforward submission process.
- **View Project Results:** After evaluation, students can log into the website to view their project results, including grades and any feedback provided by professors.
- **Presentation Scheduling:** Students can check their assigned presentation dates and see which professor will be evaluating their project.

## Technology Stack

- **Web Application:** Developed using .NET Core MVC, providing a robust and scalable framework for managing web-based functionalities.
- **Mobile Application:** Built with Flutter, ensuring a seamless cross-platform experience for both Android and iOS users.
- **API:** The system uses a Web API for handling authentication and data access, ensuring secure and efficient communication between the web and mobile applications.

## Detailed Functionality

### 1. Professors

- **Availability Management:** Professors utilize the web platform to specify their available times for evaluating projects. This information feeds into the system’s scheduling algorithm.
- **Project Evaluation:** Through the mobile app, professors can access a list of assigned projects, view detailed descriptions, and evaluate the submissions. Grading is performed in the app, allowing professors to provide instant feedback.
- **Performance Tracking:** Professors can monitor their own evaluation progress and review historical data on past project evaluations.

### 2. Students

- **Access Resources:** The web application provides students with access to a comprehensive set of documents and guidelines necessary for their projects. This includes templates, rubrics, and example projects.
- **Project Upload:** Students can upload their completed projects through a simple and user-friendly interface. The system supports various file formats to accommodate different types of projects.
- **Result Notification:** Once a project is graded, students receive a notification. They can log into the web app to view their grades, read feedback, and prepare for their presentations.
- **Presentation Coordination:** Students can see the date, time, and location of their presentations, as well as the professor who will be evaluating their performance.

### 3. Scheduling

- **Automated Scheduling Algorithm:** The system uses a sophisticated algorithm to match student projects with available professors, taking into account both the professors' availability and the students' submission dates. This ensures that presentations are scheduled efficiently and that all parties are well-prepared.
- **Conflict Resolution:** If a scheduling conflict arises, the system automatically adjusts the timetable and notifies affected users, ensuring minimal disruption.

### 4. Authentication and Security

- **Secure Login:** The system utilizes a secure web API for authentication, ensuring that all user data is protected. Both the web and mobile applications require login credentials, and access is granted based on user roles (professor or student).
- **Data Integrity:** All data transferred between the web and mobile applications is encrypted, ensuring secure communication and data integrity.
- **Role-Based Access Control:** The system employs role-based access control to restrict certain functionalities to specific users, enhancing security and ensuring proper use of the platform.

### Visit my Linkedin account to review demo.


