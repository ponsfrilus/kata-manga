const fs = require('fs')

const storeJSONData = (data, path) => {
  try {
    console.log(`Saving ${path}`)
    fs.writeFileSync(path, JSON.stringify(data, null, ' '))
  } catch (err) {
    console.error(err)
    return err
  }
  return true
}

const storeData = (data, path) => {
  try {
    console.log(`Saving ${path}`)
    fs.writeFileSync(path, data)
  } catch (err) {
    console.error(err)
    return err
  }
  return true
}

const loadData = (path) => {
  try {
    console.log(`Reading ${path}`)
    return fs.readFileSync(path, 'utf8')
  } catch (err) {
    console.error(err)
    return false
  }
}

const appendData = (data, path) => {
  try {
    console.log(`Adding data to ${path}`)
    return fs.appendFileSync(path, data)
  } catch (err) {
    console.error(err)
    return false
  }
}

exports.storeJSONData = storeJSONData
exports.storeData = storeData
exports.loadData = loadData
exports.appendData = appendData
