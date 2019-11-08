/*qrySlideDistributonComments*/
SELECT
  CONCAT(
    Comment,
    " ",
    Author,
    " ",
    Station,
    " ",
    CommentDateTime) as RecentComments
FROM
  tblPathConsoleComments
WHERE
  SlideDistrLocationID = 'LOCNDERM' AND
  CommentType = 'SLIDEDISTRIBUTION' AND
  CommentDateTime >= DATE_SUB(NOW(), INTERVAL 12 HOUR);