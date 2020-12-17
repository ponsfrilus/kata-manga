const MAL = require('./../mal_token.json')
const fetch = require('node-fetch')
const fs = require('fs')
const { storeJSONData } = require('./utils.js')

async function getTop(offset = 0) {
  url = `https://api.myanimelist.net/v2/manga/ranking?ranking_type=manga&offset=${offset}`
  //console.log(`https://api.myanimelist.net/v2/manga/ranking?ranking_type=manga&offset=${offset}`)
  return await fetch(url, {
    method: 'get',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${MAL.access_token}`,
    },
  })
    .then((res) => {
      //console.log("getTop")
      return res.json()
    })
    .then((json) => {
      //console.log(json.data)
      return json
    })
}

async function topX(limit = 100) {
  ret = []
  for (let i = 0; i < limit; i = i + 10) {
    let part = await getTop(i)
    for (const entry of part.data) {
      ret.push(entry)
    }
  }
  // save intermediate data
  storeJSONData(ret, `./data/tmp/top${limit}.json`)
  return ret
}

async function getDetails(id) {
  return await fetch(
    `https://api.myanimelist.net/v2/manga/${id}?nsfw=true&fields=id,title,main_picture,alternative_titles,start_date,end_date,status,synopsis,nsfw,genres,authors{id,first_name,last_name},serialization{id,name,link},num_volumes,num_chapters`,
    {
      method: 'get',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${MAL.access_token}`,
      },
    }
  )
    .then((res) => {
      //console.log(res)
      return res.json()
    })
    .then((json) => json)
}

const getTopMangas = async (limit = 100) => {
  console.log(`Get the top ${limit} mangas`)
  top = await topX(limit)

  console.log(`Get the top ${limit} mangas' details`)
  topdetails = []
  for (const entry of top) {
    detail = await getDetails(entry.node.id)
    detail.rank = entry.ranking.rank
    topdetails.push(detail)
  }
  storeJSONData(topdetails, `./data/tmp/top${limit}details.json`)
}

exports.getTopMangas = getTopMangas
