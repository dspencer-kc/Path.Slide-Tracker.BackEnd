var mysql = require('mysql')
var mysqlConfig = require('../mysqlConfig')

module.exports = {

  caseblockslidecount: caseblockslidecount,
  caseblockslidecountdetails: caseblockslidecountdetails
}

function caseblockslidecount (request, response, callback) {
  // ===========================================================================================
  //    Case Block Slide Count
  // ============================================================================================

  console.log('caseblockslidecount')
  let strURLHash = null
  let strAPISecret = null
  //  let strSlideDistributionLocation = ''
  let strSlideDistributionLocation = null
  let strSQL = null
  let strLocnIDLookupSQL = null
  strURLHash = request.body.URLHASH
  strAPISecret = request.body.apitoken

  if (strAPISecret === process.env.APItoken) {
    //  MySQL Call to get location id based off of hash
    if (strURLHash) {
      strLocnIDLookupSQL = `SELECT LocationID FROM OPENLIS.tblSlideDistributionLocations where URLHash = '${strURLHash}';`

      // Connect to the database
      var conLocnIDLookup = mysql.createConnection(mysqlConfig)

      //  Callback
      conLocnIDLookup.query(strLocnIDLookupSQL, function (errLocnID, LocnIDLookupResult) {
        if (errLocnID) {
          response.send(errLocnID)
          console.log('LOC ID Query Error')
          console.log(errLocnID)
        // On Error, close connection
        } else {
        // if there is no error, you have the result
          // response.json(result)
          // console.log('result found')
          // console.log(LocnIDLookupResult)
          if (LocnIDLookupResult.length > 0) {
            strSlideDistributionLocation = LocnIDLookupResult[0].LocationID
          } else if (strURLHash === '063d01cd') {
            //  Look for MASTER hash to show all locations.
            strSlideDistributionLocation = 'Slide Distribution'
          }
          //  Query based on LOCNID, If master hash show all locations.

          if (strSlideDistributionLocation === 'Slide Distribution') {
            strSQL = 'SELECT * FROM OPENLIS.qryBlockCountAllRunTimesBySortVal;'
          } else {
            strSQL = '' +
            CaseBlockSlideSQL('First', 'funPreviousWorkDayCutoffDateTime()', 'funCurrentDayFirstRunCutoff()', strSlideDistributionLocation) +
            CaseBlockSlideSQL('Second', 'funCurrentDayFirstRunCutoff()', 'funCurrentDaySecondRunCutoff()', strSlideDistributionLocation) +
            CaseBlockSlideSQL('Third', 'funCurrentDaySecondRunCutoff()', 'funCurrentDayThirdRunCutoff()', strSlideDistributionLocation) +
            CaseBlockSlideSQL('Fourth', 'funCurrentDayThirdRunCutoff()', 'funCurrentDayFourthRunCutoff()', strSlideDistributionLocation) +
            CaseBlockSlideSQL('Total', 'funPreviousWorkDayCutoffDateTime()', 'now()', strSlideDistributionLocation)
          }

          console.log(strSQL)

          if (strSlideDistributionLocation !== null) {
            if (strSQL !== null) {
            // Connect to the database
              var con = mysql.createConnection(mysqlConfig)
              con.query(strSQL, function (err, result) {
                if (err) {
                  response.send(err)
                  console.log(err)
                // On Error, close connection
                } else {
                // if there is no error, you have the result
                  let arLocID = [strSlideDistributionLocation]
                  result.unshift(arLocID)
                  response.json(result)
                }
                con.end()
              })
            }
          } else {
            response.send('Error: Location Not Found')
          }
        }
        conLocnIDLookup.end()
      })
    } else {
      response.send('Error: Check Paremeters in API Request')
    }
  } else {
    response.send('Unknown Error')
  }
}
function caseblockslidecountdetails (request, response, callback) {
  let strAPISecret = null
  let strSlideDistributionLocation = null
  let strSQL = null

  strAPISecret = request.body.apitoken

  if (strAPISecret === process.env.APItoken) {
    strSlideDistributionLocation = request.body.SLIDEDISTLOCID
    strSlideDistributionLocation = 'LOCN' + strSlideDistributionLocation
    console.log(strSlideDistributionLocation)

    strSQL = `/*qrySlideDetails*/
      SELECT DTReadyForCourier, SlideID, StainLabel, SlideTray
      FROM tblSlides as subTblSlides
      INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
      WHERE subTblSlideDistribution.DTReadyForCourier >= funPreviousWorkDayCutoffDateTime() AND
        subTblSlideDistribution.DTReadyForCourier < now() AND
        SlideDistributionLocation = '${strSlideDistributionLocation}'
        Order By DTReadyForCourier desc;`

    console.log(strSQL)
    if (strSQL !== null) {
      // Connect to the database
      var con = mysql.createConnection(mysqlConfig)
      con.query(strSQL, function (err, result) {
        if (err) {
          response.send(err)
          console.log(err)
        // On Error, close connection
        } else {
        // if there is no error, you have the result
          response.json(result)
        }
        con.end()
      })
    }
  } else {
    response.send('Unknown Error')
  }
}

function CaseBlockSlideSQL (strRun, strStartTime, strCutoffTime, strSlideDistributionLocation) {
  // Parameter Examples:
  //  strRun: First
  //  strStartTime (function call to calculate time, or datetime): funPreviousWorkDayCutoffDateTime()
  //  strCutoffTime (function call to calculate time, or datetime): funCurrentDayFirstRunCutoff()
  //  strSlideDistributionLocation: 'LOCNDERM'

  let strSQL = ''

  if (strSlideDistributionLocation === 'MASTER') {
    //  MASTER Slide location - return all slide details.
    strSQL = `
    /*qry${strRun}RunCaseCount${strSlideDistributionLocation}*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subAccessionID)
      FROM (SELECT subTblSlides.AccessionID AS subAccessionID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= ${strStartTime}
              AND  subTblSlideDistribution.DTReadyForCourier < ${strCutoffTime}
              GROUP BY subTblSlides.AccessionID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS ${strRun}RunCaseCount;

    /*qry${strRun}RunBlockCount${strSlideDistributionLocation}*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subBlockID)
      FROM (SELECT subTblSlides.BlockID AS subBlockID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= ${strStartTime}
              AND  subTblSlideDistribution.DTReadyForCourier < ${strCutoffTime}
              GROUP BY subTblSlides.BlockID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS ${strRun}RunBlockCount;

    /*qry${strRun}RunSlideCount${strSlideDistributionLocation}*/
    SELECT COUNT(subTblSlides.SlideID) AS ${strRun}RunSlideCount
    FROM tblSlides as subTblSlides
    INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
    WHERE subTblSlideDistribution.DTReadyForCourier >= ${strStartTime} AND
      subTblSlideDistribution.DTReadyForCourier < ${strCutoffTime};
    `
  } else {
    strSQL = `
    /*qry${strRun}RunCaseCount${strSlideDistributionLocation}*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subAccessionID)
      FROM (SELECT subTblSlides.AccessionID AS subAccessionID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= ${strStartTime}
              AND  subTblSlideDistribution.DTReadyForCourier < ${strCutoffTime} AND
              SlideDistributionLocation = '${strSlideDistributionLocation}'
              GROUP BY subTblSlides.AccessionID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS ${strRun}RunCaseCount;

    /*qry${strRun}RunBlockCount${strSlideDistributionLocation}*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subBlockID)
      FROM (SELECT subTblSlides.BlockID AS subBlockID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= ${strStartTime}
              AND  subTblSlideDistribution.DTReadyForCourier < ${strCutoffTime} AND
              SlideDistributionLocation = '${strSlideDistributionLocation}'
              GROUP BY subTblSlides.BlockID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS ${strRun}RunBlockCount;

    /*qry${strRun}RunSlideCount${strSlideDistributionLocation}*/
    SELECT COUNT(subTblSlides.SlideID) AS ${strRun}RunSlideCount
    FROM tblSlides as subTblSlides
    INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
    WHERE subTblSlideDistribution.DTReadyForCourier >= ${strStartTime} AND
      subTblSlideDistribution.DTReadyForCourier < ${strCutoffTime} AND
      SlideDistributionLocation = '${strSlideDistributionLocation}';
    `
  }

  return strSQL
}
