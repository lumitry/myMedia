<!-- this routes to `/` in our page (i.e. it's the default page when you load the site) because svelte uses filesystem-based routing
in other words, because this is at the root of the `src/routes` directory, it is the root of the website!
pretty neat!
-->

<h1>Welcome to SvelteKit</h1>
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>

<script>
    import Greet from '$lib/Greet.svelte';
</script>

<Greet />