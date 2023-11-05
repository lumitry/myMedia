# Database

## Philosophy

The database is designed to be as simple as possible, while still being able to handle the data we need to store. It is designed to be as flexible as possible, so that it can be used for any type of media. It should be expandable to support new types of media, and should be able to handle any type of data that we want to store. Adding to it shouldn't break old data.

**On Database Interaction:** Most database actions should probably be performed in Rust, and in general most of the app should be implemented in Rust, for the sake of performance. Minimizing language switching seems to be important for performance, so we should try to avoid switching between Rust and JS as much as possible. (*TODO*: I'll have to play around with Tauri and see how the interaction between Tauri and Svelte works. The more I can do in Rust, the better, but if it will end up involving a ton of language switches, JS/TS might be faster.)

## Database Schema

The database schema is defined [here](src-tauri/src/db/db_schema.sql). Data is stored via Sqlite. Primary keys are usually `INTEGER PRIMARY KEY AUTOINCREMENT`, but these should never need to be accessed by the user.

We can get away with things that normally would hurt performance and/or security because the database should only ever be accessed by one user at a time, and is stored locally.

It is important to note the differences between terms that a lay-person may use interchangeably:

- A series is a collection of seasons, books, etc. that are all part of the same story.
  - Series can contain other series. For example, Lord of the Rings is a series, but it contains the sub-series The Hobbit.
- A season may contain multiple **arcs**. Arcs are not defined in the database.

### Sub-Types

Types of media (tv shows, movies, books, etc.) can have **sub-types**. These are different from genres or tags.

<!-- TODO: make sure all these are implemented as db tables. most of the literature types aren't -->

| Media Type | Sub-Types          | Example                                          |
| ---------- | ------------------ | ------------------------------------------------ |
| TV Show    | Live-Action        | Breaking Bad                                     |
|            | Anime              | Death Note                                       |
|            | Animated (western) | Bluey                                            |
| Movie      | Live-Action        | Everything, Everywhere, All At Once              |
|            | Anime              | A Silent Voice                                   |
|            | Animated (western) | Spider-Man: Into the Spider-Verse                |
| Game       | Video Game         | Baldur’s Gate 3                                  |
|            | Board Game         | Monopoly                                         |
|            | Card Game          | Cards Against Humanity                           |
| Music      | Album              | *21* - Adele                                     |
|            | Single             | *Replay - Single* - Ayaz                         |
|            | EP                 | *Just Until… - EP* - Cordae                      |
|            | Mixtape            | *CLOUDS (THE MIXTAPE)* - NF                      |
|            | Compilation        | (todo)                                           |
|            | Live               | (todo)                                           |
|            | Remix              | (todo)                                           |
| Literature | Novel              | literally 1984                                   |
|            | Comic              | The Amazing Spider-Man                           |
|            | Short Story        | (todo)                                           |
|            | Anthology          | Foundations - Isaac Asimov                       |
|            | Compilation        | (todo)                                           |
|            | Poem               | *The Raven*                                      |
|            | Manga              | Vagabond                                         |
|            | Light Novel        | Mikkakan no Koufuku                              |
|            | Letter             | (archival letters from historical figures, etc.) |
|            | Textbook           | Clean Code                                       |
|            | Study              | (i.e. scientific journal entries)                |

### Universal Columns

Columns that are available for all media types.

(TODO finish adding these, and fill out all the links)

- Title
- Alternate Titles (see [ALTERNATE TITLES.md](<ALTERNATE TITLES.md>) for more info)
- Tags (see [TAGS.md](<TAGS.md>) for more info; they're stored as references to the tag's ID so that changing tag name/color is a free operation)
- Settings (see [SETTINGS.md](<SETTINGS.md>) for more info; stored as JSON array with keys for time (i.e. "1990s"), location (i.e. "New York, New York, US"), place (i.e. "home"), Relevance (weighting))
- Characters (see [CHARACTERS.md](<CHARACTERS.md>) for more info)
- Series (reference(s) to series ID; one entry can have multiple series)
- Order (order within a series, e.g. "Season 2", or "Book Four". What ordering you use is up to you, but you should probably be consistent. I prefer whatever the best "watch order" is to make things easier.)
- Description/Summary
- Notes (in the future these will be on a per-episode basis, for now they're just per-entry)
- Streaming URL (i.e. Netflix, Hulu, etc.)
- Local File Path (for the eventual [MPV Integration](<MPV INTEGRATION.md>), maybe a Calibre integration too idk) (TODO: how do we handle entries with multiple episodes. path for the folder and just guess the filename? how does jellyfin handle this?)
- Date Modified
- Date Created
- etc.

### Special Columns

Columns that depends on media type or subtype.

See [MEDIA_TYPES.md](MEDIA_TYPES.md) for more info.

(TODO)

### Other Tables

Most rows in a table will have their own page. For example, if you have a `#abc` tag, you can click on it to see all the media that has that tag and its description.

- Tags
  - Tags have a name, a color, and a description.
  - Genres are just tags.
  - (Optionally) tags can have a photo.
  - (Optionally) tags can have a parent tag.
- Studios
  - Studios have a name, a description, and a logo.
- People
  - People have a name, a description, and a photo.
  - (examples: directors, authors, actors, etc.)
  - Some sort of logic will try to link them to their works.
- Characters
  - Characters have a name, a description, and a photo.
- Series
  - Series have a name, a description, and a cover photo.
- Settings
  - Settings have a name, a description, and a photo.
  - (examples: time, location, place, etc.)
  - Some sort of logic will try to link them to their works.
