# Import

## TL;DR

Use [MyAnimeList (MAL)](https://myanimelist.net) API to generate a
`KataManga_structure_and_data.sql` SQL script to populate the DB.

![Berserk — Credit: Dark Horse Comics](./data/chapter_169.webp)
<small>Berserk — Credit: Dark Horse Comics</small>

## Usage

Run `./mal_token.sh` and follow the instruction to generate the
`mal_token.json` file. Then, run `node index.js` to generate the
`KataManga_structure_and_data.sql` SQL file.


## Details

### mal_token.sh

This bash script aim to create the `mal_token.json` file with
the access token. It follows the [MyAnimeList API Authorization
Documentation](https://myanimelist.net/apiconfig/references/authorization), to
create an OAuth 2.0 access with [PKCE](https://tools.ietf.org/html/rfc7636), and
get the access token.

### index.js

This node script calls: 

1. `lib/top.js` that will generate `data/tmp/top100.json` and
`data/tmp/top100details.json`. These 2 files contains the top 100 mangas' details
and are generated from the MAL API.
2. `lib/sqlgen.js` that will generate the `INSERT` SQL statement
to populate the DB, based on data provided by the files in step
1 and the list of genres (`data/init/genres.json`), created from
https://myanimelist.net/info.php?go=genre. The generated file will be stored as
`data/data_top100.sql`.
3. The script will finally merge `data/init/structure.sql`,
`data/data_top100.sql`, `data/init/constraints.sql` to create the
`data/KataManga_structure_and_data.sql` that can be used to create the DB with
its data.
