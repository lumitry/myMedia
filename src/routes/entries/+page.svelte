<script lang="ts">
    export let data: any; // not sure what type this should be, and copilot won't work for me in svelte files
</script>

<h1>Entries</h1>

<ul>
    {#each data.summaries as { entry_type, entry_id, title }}
        <li>
            <a href="/entries/{entry_type}/{entry_id}">{title}</a>
        </li>
    {/each}
</ul>