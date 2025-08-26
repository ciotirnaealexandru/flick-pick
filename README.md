# Flick Pick

TV Show app for for TV Show lovers.

## App features

**Login / SignUp Pages** (form validation, working endpoints)
**Search Page** (connected with the TVMaze API, displays popular shows (with images), can search for shows by name)
**Show info Page** (can display info about the show)
**Profile Page** (can _update_ profile info and _delete_ account)

## Other

**Protected endpoints**, some can only be accessed by ADMIN

## Technologies

## Used for development

Git, Insomnia (for backend testing), Trello, Figma (for UI/UX design)

### Frontend

Flutter (Dart) - page routing, creating pages and components, color themes (future dark mode), connecting .envs, auth services (retrieving info from the backend with `package:http/http.dart`), creating models (user_model, show_model), form validation, keeping JWTs with `package:flutter_secure_storage/flutter_secure_storage.dart`, mapping images on a grid (for future cacheing)

### Backend

MySQL and Prisma ORM - setting up database seeding, user Roles (USER, ADMIN), User, custom UserShows

Express.js - endpoint routing, middlewares for route protection (only certain users or only admin guards), JWT token authorization, User CRUD (and /login, /signup, /me)

TVMaze API - connected with Express.js backend (retrieve popular shows, or by name, by id, get user season information, text parsing, cleaning up jsons)
