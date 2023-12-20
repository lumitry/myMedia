use serde::Serialize;

#[derive(PartialEq, Debug)]
pub struct Tag {
    pub tag_id: i32,
    pub name: String,
    pub description: String,
    pub color: String,
    // TODO obviously update this struct to match the database schema
}

// see TAGS.md
/**
 * An EntryTag is a tag that is associated with an entry.
 * It stores the tag's id and its weight.
 * An entry contains a vector of EntryTags.
 */
#[derive(PartialEq, Debug, Serialize)]
pub struct EntryTag {
    pub tag_id: i32,
    pub tag_weight: f64,
}