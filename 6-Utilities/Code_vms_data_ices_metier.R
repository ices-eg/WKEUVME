
  # getting VMS data from the ICES VMS library for WKEUVME
  
  # install ices VMS package
  # devtools::install_github("ices-tools-prod/icesVMS")

  library(icesVMS)
  icesVMS::update_token("vandenderen")   # enter password 

# set folder to save data
  pathdir <- "C:/Users/pdvd/Online for git/WKEUVME_noGIT"
  setwd(paste(pathdir,"VMS data repository",sep="/"))

# years/ regions 
  year <- c(2009:2018)
  Ecoreg <- c("Celtic Seas","Bay of Biscay and the Iberian Coast") # ,"Greater North Sea")

# metiers
  Gear_metier         <- c("Otter","Dredge","Beam","Seine")
  Gear_metier_benthis <- c("OT_CRU","OT_DMF","OT_MIX","OT_MIX_CRU_DMF","OT_MIX_DMF_BEN","OT_SPF")
  Gear_static <- c("FPO","LLS","GNS")

# get VMS data per gear, year and region and combine all data per region (gear and year in columns)
  for (j in 1:length(Ecoreg)){
    for (yy in 1:length(year)){
      
      # get all fishing categories
      for (me in 1: length(Gear_metier)){
        Fcat   <- icesVMS::get_wgfbit_data1(Ecoreg[j], year[yy] ,fishing_category = Gear_metier[me])
        if (length(Fcat) > 0){
          Fcat <- Fcat[,c(1,5,8,9,10,12,13)]
          colnames(Fcat)[1] <- c(paste("SAR",Gear_metier[me],year[yy],sep="_"))
          colnames(Fcat)[2] <- c(paste("mw_fish_hours",Gear_metier[me],year[yy],sep="_"))
        }
        assign(paste(Gear_metier[me]),Fcat)
      }
      
      # get all benthis metier categories for otter trawls
      for (meb in 1: length(Gear_metier_benthis)){
        Bmetier   <- icesVMS::get_wgfbit_data1(Ecoreg[j], year[yy] ,benthis_metier = Gear_metier_benthis[meb])
        if (length(Bmetier)>0){
          Bmetier <- Bmetier[,c(1,5,8,9,10,12,13)]
          colnames(Bmetier)[1] <- c(paste("SAR",Gear_metier_benthis[meb],year[yy],sep="_"))
          colnames(Bmetier)[2] <- c(paste("mw_fish_hours",Gear_metier_benthis[meb],year[yy],sep="_"))
        }
        assign(paste(Gear_metier_benthis[meb]),Bmetier)
      }
      
      # get total swept area all mobile bottom contacting gears  
      total   <- icesVMS::get_wgfbit_data1(Ecoreg[j], year[yy])
      if (length(total)>0){
        total <- total[,c(1,5,8,9,10,12,13)]
        colnames(total)[1] <- c(paste("SAR_total",year[yy],sep="_"))
        colnames(total)[2] <- c(paste("mw_fish_hours_total",year[yy],sep="_"))
      }
      
      # get Static gears  
      Static   <- get_passive_footprint(Ecoreg[j], year[yy])
      if (length(Static)>0){
        Static <- Static[,c(1,3:7)]
        Static[,1] <- 1
        colnames(Static)[1] <- c(paste("Static",year[yy],sep="_"))
      }
      
      # get all static metier categories
       for (mes in 1: length(Gear_static)){ 
         Smetier <- get_passive_footprint(Ecoreg[j], year[yy],metier_level4 = Gear_static[mes]) 
       if (length(Smetier)>0){ 
         Smetier <- Smetier[,c(1,3:7)]
         colnames(Smetier)[1] <- c(paste("Static",Gear_static[mes],year[yy],sep="_"))
         Smetier[,1] <- 1
         }
       assign(paste(Gear_static[mes]),Smetier)
      }

      Reg <- dplyr::bind_rows(Otter, Dredge, Beam, Seine, Static, total, OT_CRU, OT_DMF,OT_MIX,
                              OT_MIX_CRU_DMF,OT_MIX_DMF_BEN,OT_SPF,FPO,GNS,LLS)
      Reg2 <- aggregate(Reg[,c(1:2,8:ncol(Reg))], 
                       Reg[,c(3:7)],FUN = sum,na.rm=TRUE)
      assign(paste("Region",year[yy],sep="_"),Reg)
      
    }
    
    Region <- dplyr::bind_rows(Region_2009, Region_2010, Region_2011, Region_2012, Region_2013,
                               Region_2014, Region_2015, Region_2016, Region_2017, Region_2018)
    
    Region <- aggregate(Region[,c(1:2,8:ncol(Region))],
                        Region[,c(3:7)],FUN = sum,na.rm=TRUE)
    
    saveRDS(Region,  paste(Ecoreg[j],"VMS.rds",sep="_"))
    rm(list=ls()[! ls() %in% c("year","Ecoreg","Gear_metier","Gear_metier_benthis","Gear_static")])
  }

rm(list=ls()[! ls() %in% c("pathdir")])     
