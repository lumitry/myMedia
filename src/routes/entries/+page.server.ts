import { entries } from "../../lib/data.js";

// Every page of your app can declare a load function in a +page.server.js file alongside the +page.svelte file.
// As the file name suggests, this module only ever runs on the server, including for client-side navigations.
export function load() {
    // entries.forEach((entry: { entry_type: string; entry_id: string; title: string }) => {
    //     console.log(entry.entry_type, entry.entry_id, entry.title);
    // });
    return {
        summaries: entries.map((entry: { entry_type: string; entry_id: string; title: string }) => ({
            entry_type: entry.entry_type,
            entry_id: entry.entry_id,
            title: entry.title
        }))
    };
}

// For the sake of the tutorial, we're importing data from `src/routes/blog/data.js`.
// In a real app, you'd be more likely to load the data from a database or a CMS, but for now we'll do it like this.