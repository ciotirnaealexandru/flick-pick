# Flick Pick

![Flutter](https://img.shields.io/badge/Flutter-1976D2?style=for-the-badge&logo=flutter&logoColor=white)
![Express](https://img.shields.io/badge/Express%20js-111111?style=for-the-badge&logo=express&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-5CA837?style=for-the-badge&logo=node.js&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-255D91?style=for-the-badge&logo=postgresql&logoColor=white)
![Prisma](https://img.shields.io/badge/Prisma-394151?style=for-the-badge&logo=prisma&logoColor=white)
![TMDB API](https://img.shields.io/badge/The_Movie_Databse_API-E68A00?style=for-the-badge&logo=amazonaws&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CC1F1F?style=for-the-badge&logo=githubactions&logoColor=white)
![Vercel](https://img.shields.io/badge/Vercel-111111?style=for-the-badge&logo=vercel&logoColor=white)
![Heroku](https://img.shields.io/badge/Heroku-5A50D0?style=for-the-badge&logo=heroku&logoColor=white)

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Features](#2-features)
3. [Project Architecture and Tech Stack](#3-project-architecture-and-tech-stack)
   - [API Endpoints](#api-endpoints)
   - [Technologies](#technologies)
4. [Installation and Setup](#4-installation-and-setup)
   - [Prerequisites](#prerequisites)
   - [Clone the GitHub Repository](#clone-the-github-repository)
   - [Frontend Setup](#frontend-setup)
   - [Backend Setup](#backend-setup)
   - [Recommended for Testing](#recommended-for-testing)
   - [Recommended for Feature Planning](#recommended-for-feature-planning)

## 1. Project Overview

Flick Pick is a **TV Show Mobile App** designed for the people who want _all their favorite shows in one place_.

The app allows users to **search shows** by _name_ or _genre_, **explore and sort trending series**, find **similar shows** and **rate** their favorites.

The heart of the app is **“Decks”**, _personalized bundles of shows_ similar to watchlists where users can keep everything neatly organized and always know what to watch next.

## 2. Features

### 🔐 Login / Sign Up Pages

- **Login** with an existing account or **sign up** for a new one.
- **Join as a guest** to _test out the app_.

### 🔍 Search Page

- _Fully integrated_ with **The Movie Database API**.
- Get the currently **popular** shows, view the **show posters** and choose with ease.
- **Search shows** by **name** or **genre**.
- **Sort shows** by **relevance**, **first premiered**, **last premiered** or **alphabetically**.

### 🎬 Show Info Page

- Get all the _essential details_ about the show, like the **image poster**, **title**, **runtime years**, **network**, **genres** and **description**.
- _Discover similar shows_ with the **More like this** feature, where you can discover what other viewers have also watched.
- **Add the show** to the decks you want. **Create**, **edit** and **delete** decks _on the spot_.

### 📚 Watchlist Page

- See your favourite shows packed in **Decks**.
- **Create new decks** and _quickly_ **add shows** to them.
- **Search decks** by **name**.
- **Sort decks** by **first added**, **last added** or **alphabetically**.
- View **all of your shows** in a special deck.

### 📂 Deck Info Page

- **Enter each deck** to see the respective shows.
- **Search shows inside the deck** by **name**.
- **Sort shows inside the deck** by **first added**, **last added** or **alphabetically**.
- **Edit** the deck or **delete it**.
- **Add new shows**.

### 👤 Profile Page

- Get all the _essential details_ about the user, like the **profile image**, **first name**, **last name**, **email** and **phone number**.
- Allow the user to **logout**, **update their profile** or **delete their account**.

## 3. Project Architecture and Tech Stack

### API Endpoints

| Endpoint                         | Method             | Access        | Notes |
| -------------------------------- | ------------------ | ------------- | ----- |
| `/show/popular`                  | GET                | Any           | ✅    |
| `/show/search/:name`             | GET                | Any           | ✅    |
| `/show/more/:api_id`             | GET                | Any           | ✅    |
| `/show/review/all`               | GET                | ADMIN         |       |
| `/user/signup`                   | POST               | Any           | ✅    |
| `/user/login`                    | POST               | Any           | ✅    |
| `/user/me`                       | GET                | JWT Required  | ✅    |
| `/user/all`                      | GET                | ADMIN         | ✅    |
| `/user/:user_id`                 | GET, PATCH, DELETE | ADMIN or USER | ✅    |
| `/user/deck/all/:user_id`        | GET                | ADMIN or USER | ✅    |
| `/user/deck/:user_id`            | POST               | ADMIN or USER | ✅    |
| `/user/deck/:user_id/:deck_id`   | GET, PATCH, DELETE | ADMIN or USER | ✅    |
| `/user/show/all/:user_id`        | GET                | ADMIN or USER | ✅    |
| `/user/show/:user_id`            | POST               | ADMIN or USER | ✅    |
| `/user/show/:user_id/:api_id`    | GET, DELETE        | ADMIN or USER | ✅    |
| `/user/show/review/all/:user_id` | GET                | ADMIN or USER |       |
| `/user/show/review/:user_id`     | POST               | ADMIN or USER |       |
| `/user/show/review/:user_id`     | GET, PATCH, DELETE | ADMIN or USER |       |

### Frontend

- **Flutter (Dart)** - page routing, creating pages and components, color themes (future dark mode), connecting .envs, auth services (retrieving info from the backend with `package:http/http.dart`), creating models (user_model, show_model), form validation, keeping JWTs with `package:flutter_secure_storage/flutter_secure_storage.dart`, mapping images on a grid (for future cacheing)

### Backend

- **PostgreSQL** and **Prisma ORM** - setting up database seeding, user Roles (USER, ADMIN), User, custom UserShows
- **Express.js** + **Javascript** - endpoint routing, middlewares for route protection (only certain users or only admin guards), JWT token authorization, User CRUD (and /login, /signup, /me)
- **TMDB API** - connected with Express.js backend (retrieve popular shows, or by name, by id, get user season information, text parsing, cleaning up jsons)

## 4. Installation and Setup

### Prerequisites

- **Node.js**: Ensure you have Node.js installed. You can download it from [nodejs.org](https://nodejs.org/).
- **PostgreSQL**: Set up a PostgreSQL database instance.
- **Flutter**: Setup Flutter on your computer (for more details, check out the [Flutter Docs](https://docs.flutter.dev/get-started/install)).

### Clone the **GitHub Repository**

```sh
git clone https://github.com/ciotirnaealexandru/flick-pick.git
```

### Frontend Setup

- Create a `.env` file in `/frontend` and copy the text from `.env.example`. Adjust the **environment variables** as explained in the file.

- Install the **dependencies**:

  ```sh
  cd ./frontend
  flutter pub get
  ```

- Start an **emulator** via _Android Studio_ or **connect a phone** with _USB debugging enabled_.

- Run the frontend:

  ```sh
  flutter run
  ```

### Backend Setup

- Create a **PostgreSQL database instance**.

- Create a `.env` file in `/backend` and copy the text from `.env.example`. Adjust the **environment variables** as explained in the file.

- Install the **dependencies**:

  ```sh
  cd ./backend
  npm install
  ```

- After you have a PostgreSQL database instance running, **prepare the database**:

  ```sh
  npx prisma db push
  npx prisma generate
  ```

- **Seed** the database:

  ```sh
  npm run seed
  ```

- Run the backend:

  ```sh
  npm run start
  ```

### Recommended for development

- **Insomnia**: For testing endpoints.
- **Android Studio**: For resolving dependencies, SDK issues and emulators.

### Recommended for feature planning

- **Trello**: For project tracking.
- **Figma**: For UI/UX design.
