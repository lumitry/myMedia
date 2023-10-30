export const entries = [
    {
        entry_type: "movie",
        entry_id: "tt0103064",
        title: "Terminator 2: Judgment Day", // why is this the default that copilot gives lmao?? THE IMDB ID IS EVEN CORRECT LMAO
    },
    {
        entry_type: "movie",
        entry_id: "tt0111161",
        title: "The Shawshank Redemption",
    }
];
// TODO: right now any changes in schema mean changing a million things, how can i make this simpler?
// also try connecting to sqlite. might require figuring out something like sequelize
// idk if its worth it since i was planning on doing the backend in rust
// https://sequelize.org/docs/v6/