# Feedback Form Popup (Frontend)

This project includes a Vue.js frontend for the Feedback Form Popup application. The frontend allows users to submit, view, update, and delete feedback through a user-friendly interface.

## Features
- Submit feedback entries
- View a specific feedback entry
- View all feedback entries
- Update a feedback entry
- Delete a feedback entry
- Responsive design
- User-friendly interface with modals and alerts


## Technologies Used
- Vue.js
- Axios
- Bootstrap
- Docker

## Prerequisites
- Node.js v14.20.1 or higher
- npm v6.14.17 or higher
- @vue/cli 5.0.8


## Running the Application

1. **Clone the repository using GitHub CLI**:
    ```bash
    gh repo clone dwididit/feedback-form-popup-client
    cd feedback-form-popup-client/
    ```

2. **Create a `.env` file and configure your environment variables**:
   ```bash
    # Edit the .env file with your configuration
   VUE_APP_BACKEND_URL=http://localhost:8000
   ```

3. **Build and run the application using Docker Compose**:
    ```bash
    docker-compose up --build -d
    ```

The application will run at: http://localhost


## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.