# MyMedia (working title)

The media library for people who hate using their browsers. Built with Svelte, Tauri, and Sqlite.

Have you ever used sites like Letterboxd, Trakt, or Goodreads? There are plenty of web apps that do a great job of letting you track what media you consume, but they lack features for power users. myMedia is a cross-platform desktop app that lets you track your media consumption in a way that's more powerful and customizable than any web app. Data is all stored locally, but should be syncable without much hassle using Syncthing or similar services, since it's just SQlite.

Currently, I'm working on the very basics of getting a Tauri + Svelte app working; I've never used Rust or Svelte, so I might make some mistakes; bear with me.

I have a lot of long-term planning done already, at least for a v1.0.0 release and probably a v2.0.0 (v2 will probably be vector search, yet again something I have no experience with).

## Features

<!-- TODO: list some features, ideally only as you implement them though -->

<!-- TODO: also make a wiki in addition to the proper documentation -->

## Priorities

### Sprint 1

1. Basic frontend that mostly just shows off data, maybe no editing yet
2. Very basic backend that can serve data to frontend

## Documentation

### Frontend

Run with `cd media-ui && npm run dev -- --open`

## Contributing & Code Standards

<!-- TODO (...this) -->