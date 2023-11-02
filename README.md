# MyMedia (working title)

The media library for people who hate using their browsers. Built with Svelte, Tauri, and Sqlite.

Have you ever used sites like Letterboxd, Trakt, or Goodreads? There are plenty of web apps that do a great job of letting you track what media you consume, but they lack features for power users. myMedia is a cross-platform desktop app that lets you track your media consumption in a way that's more powerful and customizable than any web app. Data is all stored locally, but should be syncable without much hassle using Syncthing or similar services, since it's just SQlite.

Currently, I'm working on the very basics of getting a Tauri + Svelte app working; I've never used Rust or Svelte, so I might make some mistakes; bear with me.

I have a lot of long-term planning done already, at least for a v1.0.0 release and probably a v2.0.0 (v2 will probably be vector search, yet again something I have no experience with).

## Features

<!-- TODO: list some features, ideally only as you implement them though -->

<!-- TODO: also make a wiki in addition to the proper documentation -->

### Potential Future Features

- Custom SQL queries? at your own risk, of course. (Similar to Obsidian Dataview)
- Custom "Views" based on filter chains with custom columns and sorting (would also work with custom SQL)

## Roadmap

(see the GitHub Project for a more detailed roadmap)

(these are STC)

- v0.0.1: (pre-pre-alpha) Basic Tauri + Svelte app that can display data from an Sqlite database. Read-only
- v0.1.0: Editable data (UI/UX should be good) and a browse page
- v0.2.0: Basic search, filtering, and sorting
- v0.3.0: Connect to APIs (OMDB, IMDB, TMDB, AniDB, etc.) to fetch data
- v0.4.0: Per-episode/per-chapter notes and (potentially) ratings and tags for episodes/chapters
- v0.5.0: Full-text search, maybe more advanced filtering
- v0.6.0: Importing/Exporting data
- v1.0.0: Finalize UX, make sure docs are thorough, etc.
- v2.0.0: Vector Search

## Priorities

### Sprint 1

1. Basic frontend that mostly just shows off data, maybe no editing yet
2. Very basic backend that can serve data to frontend

Bugs:

- Opening an external link in Tauri opens it in the same window instead of a browser.

## Documentation

### Frontend

Run with `pnpm tauri dev`

## Contributing & Code Standards

Install js dependencies with `pnpm install`
Then, install the tauri cli: `cargo install tauri-cli`

<!-- TODO (...this) -->

### Testing & Code Coverage

8.5 seconds to run a single test? Playwright is just the best, isn't it :)
