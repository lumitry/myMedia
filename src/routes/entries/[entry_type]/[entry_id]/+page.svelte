<script>
	export let data;
</script>

<h1>{data.entry.title}</h1>

<!-- <div>
    {@html data.entry.content}
</div> -->

<!-- since i'm using a dynamic parameter for the entry type (src/routes/entries/[entry_type]/[entry_id]),
    we'll probably need conditionals in this page to check entry type and display (or not display) certain things based on the entry type.
    in general, tho, i probably would use components for this stuff anyway? so this page would just be a container for the components
-->
