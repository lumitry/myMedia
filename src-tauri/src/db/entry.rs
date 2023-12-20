use crate::db::media_types::MediaType;
use crate::db::tags::EntryTag;
// use time::{Date, OffsetDateTime};
use rusqlite::{Connection, Result};
use serde::Serialize;
use super::{ambiguous_time::AmbiguousTime, media_types};

/**
 * Represents an Entry in the database
 *
 * Will effectively be extended by the other entry types
 *
 * Unsure if Rust supports 'extends' relationships, but this is the idea
 */
#[derive(Serialize, Debug)]
pub struct Entry {
    pub entry_id: i32,
    pub title: String,
    pub cover_photo: String, // TODO how to store images? (definitely filepaths but rust should probably read the files and send them to the frontend, probably faster and safer than the frontend reading them)
    pub banner_image: String,
    pub summary: String,
    pub media_type: MediaType,
    pub rating: i32, // references ratings table
    pub release_date_start: AmbiguousTime,
    pub release_date_end: AmbiguousTime,
    pub tags: Vec<EntryTag>,
    pub settings: Vec<String>,
    pub characters: Vec<i32>, // references characters table
    pub series: Vec<i32>, // references series table
    pub order_in_series: i32,
    pub notes: String,
    pub streaming_url: String,
    pub file_path: String,
    pub date_modified: AmbiguousTime,
    pub date_created: AmbiguousTime,
}

impl Entry {
    pub fn new(
        entry_id: i32,
        title: String,
        cover_photo: String,
        banner_image: String,
        summary: String,
        media_type: MediaType,
        rating: i32,
        release_date_start: AmbiguousTime,
        release_date_end: AmbiguousTime,
        tags: Vec<EntryTag>,
        settings: Vec<String>,
        characters: Vec<i32>,
        series: Vec<i32>,
        order_in_series: i32,
        notes: String,
        streaming_url: String,
        file_path: String,
        date_modified: Option<AmbiguousTime>,
        date_created: Option<AmbiguousTime>,
    ) -> Entry {
        // if the dates are None, set them to the current date
        let date_modified = match date_modified {
            Some(date) => date,
            None => AmbiguousTime::new(2099, 1, 1, 1, 1, 1), // TODO make this completely ambiguous once that's implemented
        };
        let date_created = match date_created {
            Some(date) => date,
            None => AmbiguousTime::new(2099, 1, 1, 1, 1, 1), // TODO make this completely ambiguous once that's implemented
        };
        // TODO check to make sure the foreign keys are valid
        Entry {
            entry_id,
            title,
            cover_photo,
            banner_image,
            summary,
            media_type,
            rating,
            release_date_start,
            release_date_end,
            tags,
            settings,
            characters,
            series,
            order_in_series,
            notes,
            streaming_url,
            file_path,
            date_modified,
            date_created,
        }
    }
}

pub fn get_entries(conn: Connection) -> Result<Vec<Entry>> {
    let mut stmt = conn.prepare("SELECT * FROM entries").unwrap();

    let entries = stmt
        .query_map([], |row| {
            Ok(Entry::new(
                row.get(0)?,
                row.get(1)?,
                row.get(2)?,
                row.get(3)?,
                row.get(4)?,
                media_types::get_media_type_by_id(&conn, row.get(5)?).unwrap(),
                row.get(7)?,
                row.get(8)?,
                row.get(9)?,
                vec![],
                vec![],
                vec![],
                vec![],
                row.get(14)?,
                row.get(15)?,
                row.get(16)?,
                row.get(17)?,
                row.get(18)?,
                row.get(19)?,
            ))
        })?
        .map(|entry| entry.unwrap())
        .collect::<Vec<Entry>>();

    Ok(entries)
}

// TODO write (actual) tests
// TODO flatten all foreign keys (characters, series, tags)
// TODO get_entries_by_type
// TODO does this work with null values? you shouldn't *need* to set characters or series etc.; maybe i should make the types to be Option<T>?

#[cfg(test)]
mod test {
    use crate::db::media_types;

    use super::*;

    #[test]
    fn test_entry_new() {
        let conn = Connection::open_in_memory().unwrap();
        media_types::make_media_types(&conn).unwrap();

        let entry = Entry::new(
            1,
            "Test".to_string(),
            "test".to_string(),
            "test".to_string(),
            "test".to_string(),
            media_types::get_media_type_by_name(&conn, "tv").unwrap(),
            1,
            AmbiguousTime::new(2099,1,1,1,1,1),
            AmbiguousTime::new(2099,1,1,1,1,1),
            vec![],
            vec![],
            vec![],
            vec![],
            1,
            "test".to_string(),
            "test".to_string(),
            "test".to_string(),
            None,
            None,
        );
        // let test_date = AmbiguousTime::new(2099,1,1,1,1,1);
        let settings: Vec<String> = vec![];
        let chars: Vec<i32> = vec![];
        let series: Vec<i32> = vec![];
        assert_eq!(entry.entry_id, 1);
        assert_eq!(entry.title, "Test".to_string());
        assert_eq!(entry.cover_photo, "test".to_string());
        assert_eq!(entry.banner_image, "test".to_string());
        assert_eq!(entry.summary, "test".to_string());
        assert_eq!(entry.media_type.media_type_id, 1);
        assert_eq!(entry.media_type.name, "tv".to_string());
        assert_eq!(entry.rating, 1);
        assert_eq!(entry.release_date_start, AmbiguousTime::new(2099,1,1,1,1,1));
        assert_eq!(entry.release_date_end, AmbiguousTime::new(2099,1,1,1,1,1));
        assert_eq!(entry.tags, vec![]);
        assert_eq!(entry.settings, settings);
        assert_eq!(entry.characters, chars);
        assert_eq!(entry.series, series);
        assert_eq!(entry.order_in_series, 1);
        assert_eq!(entry.notes, "test".to_string());
        assert_eq!(entry.streaming_url, "test".to_string());
        assert_eq!(entry.file_path, "test".to_string());
        assert_eq!(entry.date_modified, AmbiguousTime::new(2099,1,1,1,1,1));
        assert_eq!(entry.date_created, AmbiguousTime::new(2099,1,1,1,1,1));
    }
}