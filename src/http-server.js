const express = require('express')
const app = express()
const router = express.Router()
const auth = require('./auth')
var bodyParser = require('body-parser')
var slideTrackerCaseBlockSlideCounts = require('./slide-tracking/CaseBlockSlideCount.js')

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

/*
app.use(function (req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE')
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type')
  res.setHeader('Access-Control-Allow-Credentials', true)
  next()
}) */

app.use(auth)

app.use(function (req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', '*')
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE')
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type')
  res.setHeader('Access-Control-Allow-Credentials', true)
  next()
})

/*
// all routes prefixed with /slidetracker
app.use('/slidetracker', router)
console.log('Slide Tracker Default Route')
// using router.get() to prefix our path
// url: http://localhost:3000/slidetracker/
router.get('/', (request, response) => {
  console.log('router.get')
  response.json({ message: 'Hello from the API' })
})
*/
app.post('/caseblockslidecount', (request, response) => {
  slideTrackerCaseBlockSlideCounts.caseblockslidecount(request, response, function (err, message) {
    if (err) return console.log(err)
    console.log(request)
    console.log(message)
    
  })
})

app.post('/caseblockslidecountdetails', (request, response) => {
  slideTrackerCaseBlockSlideCounts.caseblockslidecountdetails(request, response, function (err, message) {
    if (err) return console.log(err)
    console.log(message)
  })
})

module.exports = {
  start: start
}

function start (port, callback) {
  // set the server to listen on port XXXX
  server = app.listen(port, () => console.log(`Listening on port ${port}`))
}
