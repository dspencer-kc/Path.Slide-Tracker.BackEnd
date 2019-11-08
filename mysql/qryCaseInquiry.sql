/*qryCaseInquiry*/
      SELECT tblSlides.SlideID, 
              tblSlides.StainLabel, 
              tblSlideDistribution.Status, 
              tblSlideDistribution.SlideDistributionLocation, 
              tblSlideDistribution.DTReadyForCourier, 
              tblSlides.LocationPrinted, 
              tblSlides.DTPrinted, 
              tblSlides.StainOrderDate, 
              tblSlideDistribution.SlideTray,
              tblBlock.DateTimeEngraved
      FROM   (tblSlides 
              LEFT JOIN tblSlideDistribution 
                      ON tblSlides.SlideDistributionID = 
                        tblSlideDistribution.SlideDistributionID) 
              LEFT JOIN tblBlock 
                    ON tblSlides.BlockID = tblBlock.BlockID 
      WHERE  (( ( tblSlides.AccessionID ) = ? ));