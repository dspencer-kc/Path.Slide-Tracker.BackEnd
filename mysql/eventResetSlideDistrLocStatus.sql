CREATE EVENT eventDailySetSlideLocationStatusToOpen
  ON SCHEDULE
    EVERY 1 DAY
    STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY + INTERVAL 1 HOUR)
  DO
    UPDATE `OPENLIS`.`tblSlideDistributionLocations`
       SET
        `Status` = 'OPEN'
       WHERE `Enabled` = 'Y';