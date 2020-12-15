const fs = require('fs')
const { loadData, storeData } = require('./utils.js')

// https://stackoverflow.com/a/21760438/960623
const addSlashes = (str) => {
  str = JSON.stringify(String(str))
  str = str.substring(1, str.length - 1)
  str = str.replace(/'/g, "\\'")
  return str
}

const zeroDate = (date) => {
  if (date == null) {
    return date
  }
  if (/^(\d{4})-(\d{2})-(\d{2})/.test(date)) {
    return date
  }
  let regex = /^(\d{4})?-?(\d{2})?-?(\d{2})?/
  let matches = date.match(regex)
  let newDate = ''
  if (matches[1] == undefined) {
    newDate += '0000-'
  } else {
    newDate += matches[1] + '-'
  }
  if (matches[2] == undefined) {
    newDate += '00-'
  } else {
    newDate += matches[2] + '-'
  }
  if (matches[3] == undefined) {
    newDate += '00'
  } else {
    newDate += matches[4]
  }
  return newDate
}

const genSQL = (limit = 100) => {
  let data = JSON.parse(loadData(`./data/tmp/top${limit}details.json`))
  let genredesc = JSON.parse(loadData('./data/init/genres.json'))

  sql = []
  sql['manga'] = []
  sql['genre'] = []
  sql['author'] = []
  sql['magazine'] = []
  sql['classify'] = []
  sql['write'] = []
  sql['publish'] = []

  for (let manga of data) {
    // console.log(`\n# ${manga.id.toString().padStart(6, '0')} — ${manga.title} `.padEnd(80, '-'))
    let end_date =
      typeof manga.end_date == 'undefined' ? null : '"' + manga.end_date + '"'

    manga.start_date = zeroDate(manga.start_date)
    manga.end_date = zeroDate(manga.end_date)
    let manga_sql =
      'REPLACE INTO `manga` (`id`, `title`, `status`, `start_date`, `end_date`, `synopsis`) VALUES (' +
      manga.id +
      ', "' +
      manga.title +
      '", "' +
      manga.status +
      '", "' +
      manga.start_date +
      '", ' +
      end_date +
      ', "' +
      addSlashes(manga.synopsis) +
      '");'
    sql['manga'].push(manga_sql)

    for (let genre of manga.genres) {
      let genre_sql =
        'REPLACE INTO `genre` (`id`, `name`, `description`) VALUES (' +
        genre.id +
        ', "' +
        genre.name +
        '", "' +
        addSlashes(genredesc[genre.name]) +
        '");'
      sql['genre'].push(genre_sql)

      let classify_sql =
        'REPLACE INTO `classify` (`idmanga`, `idgenre`) VALUES (' +
        manga.id +
        ', ' +
        genre.id +
        ');'
      sql['classify'].push(classify_sql)
    }

    for (let author of manga.authors) {
      let author_sql =
        'REPLACE INTO `author` (`id`, `first_name`, `last_name`) VALUES (' +
        author.node.id +
        ', "' +
        author.node.first_name +
        '", "' +
        author.node.last_name +
        '");'
      sql['author'].push(author_sql)

      let write_sql =
        'REPLACE INTO `write` (`idmanga`, `idauthor`, `role`) VALUES (' +
        manga.id +
        ', ' +
        author.node.id +
        ', "' +
        author.role +
        '");'
      sql['write'].push(write_sql)
    }

    for (mag of manga.serialization) {
      let mag_sql =
        'REPLACE INTO `magazine` (`id`, `name`) VALUES (' +
        mag.node.id +
        ', "' +
        mag.node.name +
        '");'
      sql['magazine'].push(mag_sql)

      let publish_sql =
        'REPLACE INTO `publish` (`idmanga`, `idmagazine`) VALUES (' +
        manga.id +
        ', ' +
        mag.node.id +
        ');'
      sql['publish'].push(publish_sql)
    }
  }
  let sqlgen = ''
  for (let type in sql) {
    spacer = `-- # ${type.padStart(78, '-')}`
    currentTypeSQL = ''
    sql[type].forEach((el) => {
      //console.log(el)
      currentTypeSQL += el + '\n'
    })
    sqlgen += spacer + '\n'
    sqlgen += currentTypeSQL + '\n'
  }

  // console.log(sqlgen)
  storeData(sqlgen, `./data/tmp/data_top${limit}.sql`)
}

exports.genSQL = genSQL
