use std::fmt; // ???
use rusqlite::{types::FromSql, types::FromSqlResult, types::ValueRef};
use serde::Serialize;

#[derive(PartialEq, Debug, Serialize)]
pub struct AmbiguousTime {
    pub year: i32,
    pub month: i32,
    pub day: i32,
    pub hour: i32,
    pub minute: i32,
    pub second: i32,
}

// TODO these should also support ambiguous values (i.e. 2023-??-??), maybe this should be a frontend thing? probably should be? i'm unsure.
// TODO make time from JSON repr

impl AmbiguousTime {
    pub fn new(
        year: i32,
        month: i32,
        day: i32,
        hour: i32,
        minute: i32,
        second: i32,
    ) -> AmbiguousTime {
        AmbiguousTime {
            year,
            month,
            day,
            hour,
            minute,
            second,
        }
    }
}

impl FromSql for AmbiguousTime {
    fn column_result(value: ValueRef) -> FromSqlResult<Self> {
        // TODO this should parse the JSON format
        let mut iter = value.as_str()?.split('-');
        let year = iter.next().unwrap().parse::<i32>().unwrap();
        let month = iter.next().unwrap().parse::<i32>().unwrap();
        let day = iter.next().unwrap().parse::<i32>().unwrap();
        let hour = iter.next().unwrap().parse::<i32>().unwrap();
        let minute = iter.next().unwrap().parse::<i32>().unwrap();
        let second = iter.next().unwrap().parse::<i32>().unwrap();

        Ok(AmbiguousTime {
            year,
            month,
            day,
            hour,
            minute,
            second,
        })
    }
}

impl fmt::Display for AmbiguousTime {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(
            f,
            "{}-{}-{} {}:{}:{}",
            self.year, self.month, self.day, self.hour, self.minute, self.second
        )
    }
}