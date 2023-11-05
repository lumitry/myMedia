# Ratings

By default, there is one main rating for each entry. Ratings are also stored historically, so you can see how your opinion of something has changed over time.

## Ratable Things

You can obviously rate media types. You can also rate things like people, studios, characters, and even tags. This allows you to rate things like "how much do I like this studio?" or "how much do I like this tag?". In the future, this may allow for some interesting statistics.

## Custom Ratings

The user can also add their own custom ratings. For example, you can add a "Rewatchability" rating, or an "Is the protagonist any good?" rating. This system is familiar to users of Anilist, where you can add an arbitrary number of custom scoring categories. If you come from anilist, however, do note that as of right now it's not planned to implement automatically updating the main rating based on averaging all custom rating categories; in my experience, I almost always set the main rating myself anyway. This also makes it easier to handle changes like removing a custom rating category, or updating the main rating *then* updating one of the custom categories (should it update the main rating again? or trust that the main rating you manually set is what you wanted?).

## Scoring

On the backend, ratings are stored on a decimal scale from 0 to 1. The user, however, has control over how ratings function for them on the front-end. You can choose to have a 10-point scale, a 100-point scale, or even a 37-point scale if you want. You can also choose whether you want to use integers or decimals. This allows you to have a 10-point scale with decimals, or a 100-point scale with integers, or a 37-point scale with decimals, and so-on.

<!-- TODO:
- [ ] create the frontend system for changing rating scale; ideally the user can specify what their max is and if they want decimal or integer. so a 37-point integer scale should be possible, probably, even though it's silly.
-->

## History

Whenever you watch something, you can add a rating to it. This rating is stored in the database, along with the date you added it. This allows you to see how your opinion of something has changed over time.
