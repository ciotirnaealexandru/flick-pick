# Flick Pick

### Your Next Binge, One Tap Away.

### Technologies

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

## 1. Project Overview

# _Flick Pick_

_Flick Pick_ is a **TV Show Mobile App** designed for people who want _all their favorite shows in one place_.

The app allows users to **search shows by name or genre**, discover new shows, find similar shows, and rate their favorites.

The core feature is creating **“Decks”**, which are personalized bundles of shows—similar to watchlists—so users can **keep everything neatly organized** and always know what to watch next.

## 2. Installation and Setup

### Prerequisites

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

**MySQL** and **Prisma ORM** - setting up database seeding, user Roles (USER, ADMIN), User, custom UserShows

To seed the database:

```bash
    npx prisma db push
    npx prisma generate
    npm run seed
```

**Express.js** + **Javascript** - endpoint routing, middlewares for route protection (only certain users or only admin guards), JWT token authorization, User CRUD (and /login, /signup, /me)

**TVMaze API** - connected with Express.js backend (retrieve popular shows, or by name, by id, get user season information, text parsing, cleaning up jsons)
