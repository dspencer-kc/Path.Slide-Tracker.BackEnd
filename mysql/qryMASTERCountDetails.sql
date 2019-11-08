    /*qryFirstRunCaseCountMASTER*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subAccessionID)
      FROM (SELECT subTblSlides.AccessionID AS subAccessionID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= funPreviousWorkDayCutoffDateTime()
              AND  subTblSlideDistribution.DTReadyForCourier < funCurrentDayFirstRunCutoff()
              GROUP BY subTblSlides.AccessionID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS FirstRunCaseCount;

    /*qryFirstRunBlockCountMASTER*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subBlockID)
      FROM (SELECT subTblSlides.BlockID AS subBlockID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= funPreviousWorkDayCutoffDateTime()
              AND  subTblSlideDistribution.DTReadyForCourier < funCurrentDayFirstRunCutoff()
              GROUP BY subTblSlides.BlockID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS FirstRunBlockCount;

    /*qryFirstRunSlideCountMASTER*/
    SELECT COUNT(subTblSlides.SlideID) AS FirstRunSlideCount
    FROM tblSlides as subTblSlides
    INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
    WHERE subTblSlideDistribution.DTReadyForCourier >= funPreviousWorkDayCutoffDateTime() AND
      subTblSlideDistribution.DTReadyForCourier < funCurrentDayFirstRunCutoff();

    /*qrySecondRunCaseCountMASTER*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subAccessionID)
      FROM (SELECT subTblSlides.AccessionID AS subAccessionID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= funCurrentDayFirstRunCutoff()
              AND  subTblSlideDistribution.DTReadyForCourier < funCurrentDaySecondRunCutoff()
              GROUP BY subTblSlides.AccessionID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS SecondRunCaseCount;

    /*qrySecondRunBlockCountMASTER*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subBlockID)
      FROM (SELECT subTblSlides.BlockID AS subBlockID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= funCurrentDayFirstRunCutoff()
              AND  subTblSlideDistribution.DTReadyForCourier < funCurrentDaySecondRunCutoff()
              GROUP BY subTblSlides.BlockID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS SecondRunBlockCount;

    /*qrySecondRunSlideCountMASTER*/
    SELECT COUNT(subTblSlides.SlideID) AS SecondRunSlideCount
    FROM tblSlides as subTblSlides
    INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
    WHERE subTblSlideDistribution.DTReadyForCourier >= funCurrentDayFirstRunCutoff() AND
      subTblSlideDistribution.DTReadyForCourier < funCurrentDaySecondRunCutoff();

    /*qryThirdRunCaseCountMASTER*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subAccessionID)
      FROM (SELECT subTblSlides.AccessionID AS subAccessionID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= funCurrentDaySecondRunCutoff()
              AND  subTblSlideDistribution.DTReadyForCourier < funCurrentDayThirdRunCutoff()
              GROUP BY subTblSlides.AccessionID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS ThirdRunCaseCount;

    /*qryThirdRunBlockCountMASTER*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subBlockID)
      FROM (SELECT subTblSlides.BlockID AS subBlockID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= funCurrentDaySecondRunCutoff()
              AND  subTblSlideDistribution.DTReadyForCourier < funCurrentDayThirdRunCutoff()
              GROUP BY subTblSlides.BlockID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS ThirdRunBlockCount;

    /*qryThirdRunSlideCountMASTER*/
    SELECT COUNT(subTblSlides.SlideID) AS ThirdRunSlideCount
    FROM tblSlides as subTblSlides
    INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
    WHERE subTblSlideDistribution.DTReadyForCourier >= funCurrentDaySecondRunCutoff() AND
      subTblSlideDistribution.DTReadyForCourier < funCurrentDayThirdRunCutoff();

    /*qryFourthRunCaseCountMASTER*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subAccessionID)
      FROM (SELECT subTblSlides.AccessionID AS subAccessionID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= funCurrentDayThirdRunCutoff()
              AND  subTblSlideDistribution.DTReadyForCourier < funCurrentDayFourthRunCutoff()
              GROUP BY subTblSlides.AccessionID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS FourthRunCaseCount;

    /*qryFourthRunBlockCountMASTER*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subBlockID)
      FROM (SELECT subTblSlides.BlockID AS subBlockID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= funCurrentDayThirdRunCutoff()
              AND  subTblSlideDistribution.DTReadyForCourier < funCurrentDayFourthRunCutoff()
              GROUP BY subTblSlides.BlockID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS FourthRunBlockCount;

    /*qryFourthRunSlideCountMASTER*/
    SELECT COUNT(subTblSlides.SlideID) AS FourthRunSlideCount
    FROM tblSlides as subTblSlides
    INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
    WHERE subTblSlideDistribution.DTReadyForCourier >= funCurrentDayThirdRunCutoff() AND
      subTblSlideDistribution.DTReadyForCourier < funCurrentDayFourthRunCutoff();

    /*qryTotalRunCaseCountMASTER*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subAccessionID)
      FROM (SELECT subTblSlides.AccessionID AS subAccessionID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= funPreviousWorkDayCutoffDateTime()
              AND  subTblSlideDistribution.DTReadyForCourier < now()
              GROUP BY subTblSlides.AccessionID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS TotalRunCaseCount;

    /*qryTotalRunBlockCountMASTER*/
    SELECT IFNULL(
      (SELECT Count(qrySubBlockCountWLocation.subBlockID)
      FROM (SELECT subTblSlides.BlockID AS subBlockID, subTblSlideDistribution.SlideDistributionLocation
              FROM tblSlides as subTblSlides
              INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
              WHERE subTblSlideDistribution.DTReadyForCourier >= funPreviousWorkDayCutoffDateTime()
              AND  subTblSlideDistribution.DTReadyForCourier < now()
              GROUP BY subTblSlides.BlockID, SlideDistributionLocation) as qrySubBlockCountWLocation
      GROUP BY SlideDistributionLocation
      )
    , 0)  AS TotalRunBlockCount;

    /*qryTotalRunSlideCountMASTER*/
    SELECT COUNT(subTblSlides.SlideID) AS TotalRunSlideCount
    FROM tblSlides as subTblSlides
    INNER JOIN   tblSlideDistribution as subTblSlideDistribution on subTblSlides.SlideDistributionID = subTblSlideDistribution.SlideDistributionID
    WHERE subTblSlideDistribution.DTReadyForCourier >= funPreviousWorkDayCutoffDateTime() AND
      subTblSlideDistribution.DTReadyForCourier < now();