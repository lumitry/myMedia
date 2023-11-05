<script>
    import { invoke } from '@tauri-apps/api/tauri'

    let name = '';
    let greetMsg = '';
    let entries = '';

    async function greet() {
        greetMsg = await invoke('greet', { name });
    }

    async function get_entries() {
        let entries_orig = await invoke('get_entries');
        // entries = entries_orig;
        for (let entry in entries_orig) {
            entries += entries_orig[entry].entry_name + '\n';
        }
    }
</script>

<div>
    <input id="greet-input" placeholder="Enter a name..." bind:value="{name}" />
    <button on:click="{greet}">Greet</button>
    <p>{greetMsg}</p>
    <button on:click="{get_entries}">Get Entries</button>
    <p>{entries}</p>
</div>