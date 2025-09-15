# Flick Pick

### _Your Next Binge, One Tap Away._

![Flutter](https://img.shields.io/badge/Flutter-1976D2?style=for-the-badge&logo=flutter&logoColor=white)
![Express](https://img.shields.io/badge/Express%20js-111111?style=for-the-badge&logo=express&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-5CA837?style=for-the-badge&logo=node.js&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-255D91?style=for-the-badge&logo=postgresql&logoColor=white)
![Prisma](https://img.shields.io/badge/Prisma-394151?style=for-the-badge&logo=prisma&logoColor=white)
![TMDB API](https://img.shields.io/badge/The_Movie_Databse_API-E68A00?style=for-the-badge&logo=amazonaws&logoColor=white)
![JWT](https://img.shields.io/badge/JWT-d45dc4?style=for-the-badge&logo=jsonwebtoken&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CC1F1F?style=for-the-badge&logo=githubactions&logoColor=white)
![Vercel](https://img.shields.io/badge/Vercel-111111?style=for-the-badge&logo=vercel&logoColor=white)
![Heroku](https://img.shields.io/badge/Heroku-5A50D0?style=for-the-badge&logo=heroku&logoColor=white)

---

## 1. Project Overview

_Flick Pick_ is a **TV Show Mobile App** designed for the people who want _all their favorite shows in one place_.

The app allows users to **search shows** by _name_ or _genre_, **expore and sort trending series**, find **similar shows**, and **rate** their favorites.

The heart of the app is **“Decks”**, personalized bundles of shows similar to watchlists where users can **keep everything neatly organized** and always know what to watch next.

## 2. Installation and Setup

### Prerequisites

- **Node.js**: Ensure you have Node.js installed. You can download it from [nodejs.org](https://nodejs.org/).

- **npm**: Comes with Node.js.

- **PostgreSQL**: Set up a PostgreSQL database instance.

- **Flutter**: Setup Flutter on your computer (for more details, check out the [Flutter Docs](https://docs.flutter.dev/get-started/install)).

### Clone the **GitHub Repository**

```sh
git clone https://github.com/ciotirnaealexandru/flick-pick.git
```

### Setup Frontend

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

### Setup Backend

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

## App features

**Login / SignUp Pages** (form validation, working endpoints)

**Search Page** (connected with the The Movie Database API\_, displays popular shows (with images), can search for shows by name)

**Show info Page** (can display info about the show)

**Profile Page** (can _update_ profile info and _delete_ account)

## Endpoints

### /show

`/show/popular` - GET (_any_) ✅

`/show/search/:name` - GET (_any_) ✅

`/show/more/:api_id` - GET (_any_) ✅

### /show/review

`/show/review/all` - GET (_ADMIN_)

### /user

`/user/signup` - POST (_any_) ✅

`/user/login` - POST (_any_) ✅

`/user/me` - GET (_JWT Required_) ✅

`/user/all` - GET (_ADMIN_) ✅

`/user/:user_id` - GET, PATCH, DELETE (_ADMIN_ or _USER_) ✅

### /user/deck

`/user/deck/all/:user_id` - GET (_ADMIN_ or _USER_) ✅

`/user/deck/:user_id` - POST (_ADMIN_ or _USER_) ✅

`/user/deck/:user_id/:deck_id` - GET, PATCH, DELETE (_ADMIN_ or _USER_) ✅

### /user/show

`/user/show/all/:user_id` - GET (_ADMIN_ or _USER_) ✅

`/user/show/:user_id` - POST (_ADMIN_ or _USER_) ✅

`/user/show/:user_id/:api_id` - GET, ~~PATCH~~, DELETE (_ADMIN_ or _USER_) ✅

### /user/show/review

`/user/show/review/all/:user_id` - GET (_ADMIN_ or _USER_)

`/user/show/review/:user_id` - POST, GET, PATCH, DELETE (_ADMIN_ or _USER_)

## Technologies

### Used for development

**Git**, **Insomnia** (for backend testing), **Android Studio** (for resolving dependencies, SDK issues and emulators), **Bash**, **Trello** (for task tracking), **Figma** (for UI/UX design)

### Frontend

**Flutter (Dart)** - page routing, creating pages and components, color themes (future dark mode), connecting .envs, auth services (retrieving info from the backend with `package:http/http.dart`), creating models (user_model, show_model), form validation, keeping JWTs with `package:flutter_secure_storage/flutter_secure_storage.dart`, mapping images on a grid (for future cacheing)

### Backend

**PostgreSQL** and **Prisma ORM** - setting up database seeding, user Roles (USER, ADMIN), User, custom UserShows

**Express.js** + **Javascript** - endpoint routing, middlewares for route protection (only certain users or only admin guards), JWT token authorization, User CRUD (and /login, /signup, /me)

**TMDB API** - connected with Express.js backend (retrieve popular shows, or by name, by id, get user season information, text parsing, cleaning up jsons)
