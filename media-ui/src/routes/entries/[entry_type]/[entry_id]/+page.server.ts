import { entries } from "../../../../lib/data.js";
import { error } from "@sveltejs/kit";

export function load({ params }) {
    const entry = entries.find(
        (entry: { entry_type: string; entry_id: string; title: string }) => entry.entry_type === params.entry_type && entry.entry_id === params.entry_id);

    if (!entry) throw error(404);

    return { entry };
}