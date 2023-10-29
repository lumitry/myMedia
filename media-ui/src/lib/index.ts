// place files you want to import through the `$lib` alias in this folder.

// Because SvelteKit uses directory-based routing, it's easy to place modules and components alongside the routes that use them. A good rule of thumb is 'put code close to where it's used'.
// Sometimes, code is used in multiple places. When this happens, it's useful to have a place to put them that can be accessed by all routes without needing to prefix imports with ../../../../. In SvelteKit, that place is the src/lib directory. Anything inside this directory can be accessed by any module in src via the $lib alias.