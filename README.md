# Flick Pick

TV Show app for for TV Show lovers.

## App features

**Login / SignUp Pages** (form validation, working endpoints)

**Search Page** (connected with the _TVMaze API_, displays popular shows (with images), can search for shows by name)

**Show info Page** (can display info about the show)

**Profile Page** (can _update_ profile info and _delete_ account)

## Endpoints

### /show

`/show/popular` - GET (_any_) ✅

`/show/search/:name` - GET (_any_) ✅

`/show/external/:api_id` - GET (_any_) ✅

`/show/:api_id` - GET (_JWT Required_) ✅

### /show/review

`/show/review/all` - GET (_ADMIN_)

### /user

`/user/signup` - POST (_any_) ✅

`/user/login` - POST (_any_) ✅

`/user/all` - GET (_ADMIN_) ✅

`/user/:user_id` - GET, PATCH, DELETE (_ADMIN_ or _USER_) ✅

`/user/me` - GET (_JWT Required_) ✅

### /user/show

`/user/show/all/:user_id` - GET (_ADMIN_ or _USER_) ✅

`/user/show/watched/:user_id` - GET (_ADMIN_ or _USER_) ✅

`/user/show/will_watch/:user_id` - GET (_ADMIN_ or _USER_) ✅

`/user/show/:user_id` - POST (_ADMIN_ or _USER_) ✅

`/user/show/:user_id/:show_id` - GET, ~~PATCH~~, DELETE (_ADMIN_ or _USER_) ✅

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
