# Tags

## Backend

Tags are stored as a table in the database. Each tag has a name, a color, a rating, and a description. Optionally, they also have a parent tag(s).

Tags for entries and characters are stored as JSON:

```json
{
    "tags": [
        {
            "tag_id": 1,
            "weight": 0.5
        },
        {
            "tag_id": 2,
            "weight": 0.75
        }
    ]
}
```

## Tag Weights

Tags have a weight between 0 and 1. A weighting of 1 means the tag is very relevant to the entry, while a weighting of 0 means the tag is not relevant at all.

When searching for entries, you can filter by tag weight. For example, you can search for all entries that have a "Fantasy" tag with a weight of at least 0.5.

(Similar systems exist on Anilist and AniDB, but users can't define their own tags for their entries.)

## Nesting

Tags may or may not have parent tags. Parent tags can have parent tags of their own as well.

Tags can have multiple parent tags. Note that if you have multi-level nesting, you only need to include the direct parent, not all the ones above it.

It is up to the user whether a parent tag includes its children. For example, if you have a "Fantasy" tag, you can choose whether to include all the tags that are children of "Fantasy" (i.e. "Isekai", "Magic", etc.) when you filter by "Fantasy".

As an example of nesting:

- Fantasy
  - High Fantasy
  - Low Fantasy
  - Magic
    - Elemental Magic
    - Spirit Magic
  - Urban Fantasy
  - Isekai
    - To a Video Game
    - To another world
- Sci-Fi
  - Cyberpunk
  - Space Opera
  - Space Western
  - Steampunk
  - Time Travel

And so on.

## Tag Colors

Tags have a color, which is used to color the tag in the UI. This is stored as a hex color code.

I may add handling for colors that are hard to read (i.e. white text on a yellow background), but for now it's up to the user to make sure their tags are readable.

## Tag Ratings

Tags can have a rating just like entries, referring to the `ratings` table.
