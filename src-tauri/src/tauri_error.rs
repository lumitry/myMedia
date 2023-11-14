// thanks tauri docs for this error handling code, never would have figured this out
// create the error type that represents all errors possible in our program
#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error(transparent)]
    Io(#[from] std::io::Error),
    #[error(transparent)]
    Sqlite(#[from] rusqlite::Error),
}

// we must manually implement serde::Serialize
impl serde::Serialize for Error {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
    S: serde::ser::Serializer,
    {
    println!("Error: {}", self.to_string());
    return serializer.serialize_str(self.to_string().as_ref());
    }
}