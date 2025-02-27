
#### code to produce figures and tables per ecoregion

  setwd(paste(pathdir,"3-Data analysis",EcoReg,sep="/")) 
  outdir <- paste(pathdir,"5-Output",EcoReg,sep="/") 

  shapeEEZ <- readOGR(dsn = paste(pathdir,"1-Input data/EEZ_land_union_v2_201410",sep="/") ,layer="EEZ_land_v2_201410") 
  shapeEcReg <- readOGR(dsn = paste(pathdir,"1-Input data/ICES_ecoregions",sep="/") ,layer="ICES_ecoregions_20171207_erase_ESRI")
  shapeReg  <- subset(shapeEcReg, Ecoregion== EcoReg)
  
#### fig 1
  fig1 <- readRDS(file = "fig1.rds")

  # Get the world map
  worldMap <- map_data("world")
  
  # get boundaries of ecoregion used for all plots
  minlong <- round(min(fig1$long)-0.1,digits = 0)
  maxlong <- round(max(fig1$long)+ 0.1,digits = 0)
  minlat  <- round(min(fig1$lat)- 0.1,digits = 0)
  maxlat  <- round(max(fig1$lat)+ 0.1,digits = 0)
  coordslim <- c(minlong,maxlong,minlat,maxlat)
  coordxmap <- round(seq(minlong,maxlong,length.out = 4))
  coordymap <- round(seq(minlat,maxlat,length.out = 4))
  
  # plotting specifics
  pointsize <- 0.5
  fig_width  <- (maxlong-minlong)/2.5
  fig_length <- (maxlat-minlat)/2
  
  jpeg(file = paste(outdir,"Figure_1_depth.jpeg",sep="/"), width=fig_width, height=fig_length,units ='in', res = 300)

  figmap <- ggplot() + geom_point(data=fig1, aes(x=long, y=lat , col=as.factor(within)),
                                  shape=15,size=0.5,na.rm=T) 
  figmap <- figmap +  scale_color_manual(values = c("white","darkblue"),name ="",labels=c("","depth 400-800 m",""))      
  figmap <- figmap +  geom_polygon(data = worldMap, aes(x = long, y = lat, group = group),color="grey",fill="grey")
  figmap <- figmap +  theme(plot.background=element_blank(),
                            panel.background=element_blank(),
                            axis.text.y   = element_text(size=16),
                            axis.text.x   = element_text(size=16),
                            axis.title.y  = element_text(size=16),
                            axis.title.x  = element_text(size=16),
                            panel.border  = element_rect(colour = "grey", size=.5,fill=NA),
                            legend.text   = element_text(size=11),
                            legend.title  = element_text(size=11),
                            legend.position ="bottom") +
    scale_x_continuous(breaks=coordxmap, name = "longitude") +
    scale_y_continuous(breaks=coordymap, name = "latitude")  +
    coord_cartesian(xlim=c(coordslim[1], coordslim[2]), ylim=c(coordslim[3],coordslim[4]))
  figmap<- figmap +   guides(colour = guide_legend(override.aes = list(size=5),nrow=2,byrow=TRUE))
  
  figmap2 <- figmap +  geom_polygon(data = shapeEEZ, aes(x = long, y = lat, group = group),color="grey",fill=NA)
  figmap2 <- figmap2 +  geom_polygon(data = shapeReg, aes(x = long, y = lat, group = group),color="black",fill=NA)
  print(figmap2)
  dev.off() 

#### table 2
  tab2 <- readRDS(file = "tab2.rds")
  write.csv(tab2, paste(outdir,"Table_2.csv",sep="/"))
  
#### table 3
  tab3 <- readRDS(file = "tab3.rds")
  tab3 <- cbind(tab3[[1]],tab3[[2]])
  tab3 <- tab3[, c(1, 4, 2, 5, 3,6)]
  tab3 <- tab3[c(1:5,12,6:11,13:15),]
  write.csv(tab3, paste(outdir,"Table_3.csv",sep="/"))

#### table 3a 
  tab3a <- readRDS(file = "tab3a.rds") 
  write.csv(tab3a, paste(outdir,"Table_3a.csv",sep="/")) 

 
#### figure 6
  fig6 <- readRDS(file = "fig6.rds") 
  fig6$temp <- 0
  fig6$temp[fig6$adjacent.cells>0] <-1

  jpeg(file = paste(outdir,"Figure_6.jpeg",sep="/"), width=fig_width, height=fig_length,units ='in', res = 300)
  figmap <- ggplot() + geom_point(data=fig6, aes(x=long, y=lat , col=as.factor(temp)),
                                  shape=15,size=0.5,na.rm=T) 
  figmap <- figmap +  scale_color_manual(values = c("#bcbddc","#54278f"),name ="",labels=c("unfished","fished"))      
  figmap <- figmap +  geom_polygon(data = worldMap, aes(x = long, y = lat, group = group),color="grey",fill="grey")
  figmap <- figmap +  theme(plot.background=element_blank(),
                            panel.background=element_blank(),
                            axis.text.y   = element_text(size=16),
                            axis.text.x   = element_text(size=16),
                            axis.title.y  = element_text(size=16),
                            axis.title.x  = element_text(size=16),
                            panel.border  = element_rect(colour = "grey", size=.5,fill=NA),
                            legend.text   = element_text(size=11),
                            legend.title  = element_text(size=11),
                            legend.position ="bottom") +
    scale_x_continuous(breaks=coordxmap, name = "longitude") +
    scale_y_continuous(breaks=coordymap, name = "latitude")  +
    coord_cartesian(xlim=c(coordslim[1], coordslim[2]), ylim=c(coordslim[3],coordslim[4]))
  figmap<- figmap +   guides(colour = guide_legend(override.aes = list(size=5),nrow=2,byrow=TRUE))
  
  figmap2 <- figmap +  geom_polygon(data = shapeEEZ, aes(x = long, y = lat, group = group),color="grey",fill=NA)
  figmap2 <- figmap2 +  geom_polygon(data = shapeReg, aes(x = long, y = lat, group = group),color="black",fill=NA)
  print(figmap2)
  dev.off() 


#### figure 6b - c-squares with multiple fishing gears 
  
  jpeg(file = paste(outdir,"Figure_6b.jpeg",sep="/"), width=fig_width, height=fig_length,units ='in', res = 300) 
  figmap <- ggplot() + geom_point(data=fig6[fig6$temp > 0,], aes(x=long, y=lat , col=as.factor(ref_count)),
                                  shape=15,size=0.5,na.rm=T)  
  figmap <- figmap +  geom_polygon(data = worldMap, aes(x = long, y = lat, group = group),color="grey",fill="grey")
  figmap <- figmap +  theme(plot.background=element_blank(), 
                            panel.background=element_blank(),
                            axis.text.y   = element_text(size=16),
                            axis.text.x   = element_text(size=16),
                            axis.title.y  = element_text(size=16),
                            axis.title.x  = element_text(size=16),
                            panel.border  = element_rect(colour = "grey", size=.5,fill=NA), 
                            legend.text   = element_text(size=11), 
                            legend.title  = element_text(size=11), 
                            legend.position ="bottom") + 
    scale_x_continuous(breaks=coordxmap, name = "longitude") + 
    scale_y_continuous(breaks=coordymap, name = "latitude")  + 
    coord_cartesian(xlim=c(coordslim[1], coordslim[2]), ylim=c(coordslim[3],coordslim[4])) 
  figmap <- figmap +  labs(col="gears count") 
  figmap <- figmap + guides(colour = guide_legend(override.aes = list(size=5),nrow=2,byrow=TRUE))
  figmap2 <- figmap +  geom_polygon(data = shapeEEZ, aes(x = long, y = lat, group = group),color="grey",fill=NA) 
  figmap2 <- figmap2 +  geom_polygon(data = shapeReg, aes(x = long, y = lat, group = group),color="black",fill=NA)
  print(figmap2) 
  dev.off()  
 
#### figure 7
  fig7 <- readRDS(file = "fig7.rds") 
  
  jpeg(file = paste(outdir,"Figure_7a.jpeg",sep="/"), width=fig_width, height=fig_length,units ='in', res = 300)
  figmap <- ggplot() + geom_point(data=fig7, aes(x=long, y=lat , col=as.factor(ref_cat)),
                                  shape=15,size=0.5,na.rm=T) 
  figmap <- figmap +  scale_color_manual(values = c("#bcbddc","#54278f"),name ="",labels=c("unfished","fished"))      
  figmap <- figmap +  geom_polygon(data = worldMap, aes(x = long, y = lat, group = group),color="grey",fill="grey")
  figmap <- figmap +  theme(plot.background=element_blank(),
                            panel.background=element_blank(),
                            axis.text.y   = element_text(size=16),
                            axis.text.x   = element_text(size=16),
                            axis.title.y  = element_text(size=16),
                            axis.title.x  = element_text(size=16),
                            panel.border  = element_rect(colour = "grey", size=.5,fill=NA),
                            legend.text   = element_text(size=11),
                            legend.title  = element_text(size=11),
                            legend.position ="bottom") +
    scale_x_continuous(breaks=coordxmap, name = "longitude") +
    scale_y_continuous(breaks=coordymap, name = "latitude")  +
    coord_cartesian(xlim=c(coordslim[1], coordslim[2]), ylim=c(coordslim[3],coordslim[4]))
  figmap<- figmap +   guides(colour = guide_legend(override.aes = list(size=5),nrow=2,byrow=TRUE))
  
  figmap2 <- figmap +  geom_polygon(data = shapeEEZ, aes(x = long, y = lat, group = group),color="grey",fill=NA)
  figmap2 <- figmap2 +  geom_polygon(data = shapeReg, aes(x = long, y = lat, group = group),color="black",fill=NA)
  print(figmap2)
  dev.off() 
  
  jpeg(file = paste(outdir,"Figure_7b.jpeg",sep="/"), width=fig_width, height=fig_length,units ='in', res = 300)
  figmap <- ggplot() + geom_point(data=fig7, aes(x=long, y=lat , col=as.factor(ref_vs_after)),
                                  shape=15,size=0.5,na.rm=T) 
  figmap <- figmap +  scale_color_manual(values = c("#bcbddc","#54278f","#b30000","#fcae91"),name ="",
                                         labels=c("unfished (both periods)","only fished in 2009-11",
                                                  "only fished in 2012-18","fished (both periods)"))      
  figmap <- figmap +  geom_polygon(data = worldMap, aes(x = long, y = lat, group = group),color="grey",fill="grey")
  figmap <- figmap +  theme(plot.background=element_blank(),
                            panel.background=element_blank(),
                            axis.text.y   = element_text(size=16),
                            axis.text.x   = element_text(size=16),
                            axis.title.y  = element_text(size=16),
                            axis.title.x  = element_text(size=16),
                            panel.border  = element_rect(colour = "grey", size=.5,fill=NA),
                            legend.text   = element_text(size=11),
                            legend.title  = element_text(size=11),
                            legend.position = "bottom") +
    scale_x_continuous(breaks=coordxmap, name = "longitude") +
    scale_y_continuous(breaks=coordymap, name = "latitude")  +
    coord_cartesian(xlim=c(coordslim[1], coordslim[2]), ylim=c(coordslim[3],coordslim[4]))
  figmap <- figmap + guides(colour = guide_legend(override.aes = list(size=5),nrow=2,byrow=TRUE))

  
  figmap2 <- figmap +  geom_polygon(data = shapeEEZ, aes(x = long, y = lat, group = group),color="grey",fill=NA)
  figmap2 <- figmap2 +  geom_polygon(data = shapeReg, aes(x = long, y = lat, group = group),color="black",fill=NA)
  print(figmap2)
  dev.off() 
 
#### figure 8
  source(paste(pathdir,"4-Code for figures and tables/Figure8_source_restricted.R",sep="/"))
  
  # reset the paths
  setwd(paste(pathdir,"3-Data analysis",EcoReg,sep="/")) 
  outdir <- paste(pathdir,"5-Output",EcoReg,sep="/") 
  
  jpeg(file = paste(outdir,"Figure_8a.jpeg",sep="/"), width=fig_width, height=fig_length*0.8,units ='in', res = 300)
  par(mar = c(5, 4, 4, 4) + 0.3)              
  plot(fig8$Otter_intensity~fig8$perc, type="l", lwd=2, col = "red", xaxt="n",              
       yaxt = "n", xlab="Percentiles of total grid cell SAR", ylab = "SAR/c-square")              
  axis(1,c( seq(0, 100, by=10)),c(rev( seq(0, 100, by=10))))
  axis(side = 2, at = pretty(fig8$Otter_intensity),las=1, col.axis="red")     
  par(new = TRUE)                           
  plot(area~quat,type="l", lwd=2, axes = FALSE, xlab = "", ylab = "")
  mtext("Cumulative area (%)", side = 4, line = 3)             
  axis(side = 4, at = pretty(quat),las=1, col.axis="black")
  lines(x=c(90,90),y=c(0,100),lty=3)
  text(45,80,"core fishing area \n (90% of total SAR)")
  arrows(10, 70, 80, 70, code= 3)
  dev.off()
  
  jpeg(file = paste(outdir,"Figure_8b.jpeg",sep="/"), width=fig_width, height=fig_length,units ='in', res = 300)
  figmap <- ggplot() + geom_point(data=fig8b, aes(x=long, y=lat , col=cat2),
                                  shape=15,size=0.5,na.rm=T)  + ggtitle("")
  figmap <- figmap +  scale_color_manual(values = c("lightblue","darkblue"),name ="",
                                         labels=c("0-10th perc.","10-100th perc. (core fishing area)"))      
  figmap <- figmap +  geom_polygon(data = worldMap, aes(x = long, y = lat, group = group),color="grey",fill="grey")
  figmap <- figmap +  theme(plot.background=element_blank(),
                            panel.background=element_blank(),
                            axis.text.y   = element_text(size=12),
                            axis.text.x   = element_text(size=12),
                            axis.title.y  = element_text(size=12),
                            axis.title.x  = element_text(size=12),
                            panel.border  = element_rect(colour = "grey", size=.5,fill=NA),
                            legend.text   = element_text(size=11),
                            legend.title  = element_text(size=11),
                            legend.position ="bottom") +
    scale_x_continuous(breaks=coordxmap, name = "Longitude") +
    scale_y_continuous(breaks=coordymap, name = "Latitude")  +
    coord_cartesian(xlim=c(coordslim[1], coordslim[2]), ylim=c(coordslim[3],coordslim[4]))
  figmap<- figmap +   guides(colour = guide_legend(override.aes = list(size=5),nrow=1,byrow=TRUE))
  
  figmap2 <- figmap +  geom_polygon(data = shapeEEZ, aes(x = long, y = lat, group = group),color="grey",fill=NA)
  figmap2 <- figmap2 +  geom_polygon(data = shapeReg, aes(x = long, y = lat, group = group),color="black",fill=NA)
  print(figmap2)
  dev.off() 

  copl <- c("#a6bddb","#74a9cf","#2b8cbe","#045a8d","#d9f0a3","#addd8e","#78c679","#31a354","#d95f0e","#993404")
  labeltext <- c("0-10","10-20","20-30","30-40","40-50","50-60","60-70","70-80","80-90","90-100")
  
  jpeg(file = paste(outdir,"Figure_8c.jpeg",sep="/"), width=fig_width, height=fig_length,units ='in', res = 300)
  
  figmap <- ggplot() + geom_point(data=fig8b, aes(x=long, y=lat , col=rev(cat3)),
                                  shape=15,size=0.5,na.rm=T)  + ggtitle("(c) fishing in 2009-2011")
  figmap <- figmap +  scale_color_manual(values = copl,name ="Percentiles",labels=labeltext)      
  figmap <- figmap +  geom_polygon(data = worldMap, aes(x = long, y = lat, group = group),color="grey",fill="grey")
  figmap <- figmap +  theme(plot.background=element_blank(),
                            panel.background=element_blank(),
                            axis.text.y   = element_text(size=16),
                            axis.text.x   = element_text(size=16),
                            axis.title.y  = element_text(size=16),
                            axis.title.x  = element_text(size=16),
                            panel.border  = element_rect(colour = "grey", size=.5,fill=NA),
                            legend.text   = element_text(size=11),
                            legend.title  = element_text(size=11),
                            legend.position ="bottom") +
    scale_x_continuous(breaks=coordxmap, name = "longitude") +
    scale_y_continuous(breaks=coordymap, name = "latitude")  +
    coord_cartesian(xlim=c(coordslim[1], coordslim[2]), ylim=c(coordslim[3],coordslim[4]))
  figmap<- figmap +   guides(colour = guide_legend(override.aes = list(size=5),nrow=2,byrow=TRUE))
  figmap <- figmap +  geom_polygon(data = shapeEEZ, aes(x = long, y = lat, group = group),color="grey",fill=NA)
  figmap <- figmap +  geom_polygon(data = shapeReg, aes(x = long, y = lat, group = group),color="black",fill=NA)
  print(figmap)
  dev.off()
  
  copl <- c("#a6bddb","#74a9cf","#2b8cbe","#045a8d","#d9f0a3","#addd8e","#78c679","#31a354","#d95f0e","#993404")
  labeltext <- c("0-10","10-20","20-30","30-40","40-50","50-60","60-70","70-80","80-90","90-100")
  
  jpeg(file = paste(outdir,"Figure_8d.jpeg",sep="/"), width=fig_width, height=fig_length,units ='in', res = 300)
  
  figmap <- ggplot() + geom_point(data=fig8d, aes(x=long, y=lat , col=rev(cat4)),
                                  shape=15,size=0.5,na.rm=T) + ggtitle("(d) fishing in 2015-2018")
  figmap <- figmap +  scale_color_manual(values = copl,name ="Percentiles",labels=labeltext)      
  figmap <- figmap +  geom_polygon(data = worldMap, aes(x = long, y = lat, group = group),color="grey",fill="grey")
  figmap <- figmap +  theme(plot.background=element_blank(),
                            panel.background=element_blank(),
                            axis.text.y   = element_text(size=16),
                            axis.text.x   = element_text(size=16),
                            axis.title.y  = element_text(size=16),
                            axis.title.x  = element_text(size=16),
                            panel.border  = element_rect(colour = "grey", size=.5,fill=NA),
                            legend.text   = element_text(size=11),
                            legend.title  = element_text(size=11),
                            legend.position ="bottom") +
    scale_x_continuous(breaks=coordxmap, name = "longitude") +
    scale_y_continuous(breaks=coordymap, name = "latitude")  +
    coord_cartesian(xlim=c(coordslim[1], coordslim[2]), ylim=c(coordslim[3],coordslim[4]))
  figmap<- figmap +   guides(colour = guide_legend(override.aes = list(size=5),nrow=2,byrow=TRUE))
  figmap <- figmap +  geom_polygon(data = shapeEEZ, aes(x = long, y = lat, group = group),color="grey",fill=NA)
  figmap <- figmap +  geom_polygon(data = shapeReg, aes(x = long, y = lat, group = group),color="black",fill=NA)
  print(figmap)
  dev.off()
  
  
#### table 4
  tab4 <- readRDS(file = "tab4.rds")
  colnames(tab4) <- c("Region","VME presence","Precaution low -- fished","Precaution low -- total",
                      "Precaution medium -- fished", "Precaution medium -- total",
                      "Precaution high -- fished","Precaution high -- total")
  write.csv(tab4, paste(outdir,"Table_4.csv",sep="/")) 
  
  tab4a <- readRDS(file = "tab4a.rds")

  colnames(tab4a) <- c("Region","VME presence","Precaution low -- fished","Precaution low -- total",
                    
                    "Precaution medium -- fished", "Precaution medium -- total",
                    
                    "Precaution high -- fished","Precaution high -- total",
                    
                    "Sub-gear")

  write.csv(tab4a, paste(outdir,"Table_4a.csv",sep="/")) 

#### Figure 9
  source(paste(pathdir,"4-Code for figures and tables/Figure9_source_restricted.R",sep="/"))
  
  # reset the paths
  setwd(paste(pathdir,"3-Data analysis",EcoReg,sep="/")) 
  outdir <- paste(pathdir,"5-Output",EcoReg,sep="/") 
  
  fig9$category[fig9$category =="none_0"] <- NA
  fig9$category[fig9$category =="none_1"] <- NA
  fig9 <- subset(fig9,!(is.na(fig9$category)))
  
  #if (EcoReg == "Celtic Seas"){
  #  colfig9 <- c("#238b45","#bae4b3", "#e31a1c","#fdbe85","#bdd7e7")
  #  labeltext <- c("high - unfished","high - fished","low - unfished","low - fished",
  #                "medium - fished")
  #} else{
    colfig9 <- c("#238b45","#bae4b3", "#e31a1c","#fdbe85","#2171b5","#bdd7e7")
    labeltext <- c("high - unfished","high - fished","low - unfished","low - fished",
                 "medium - unfished", "medium - fished")
  #}
  
  jpeg(file = paste(outdir,"Figure_9.jpeg",sep="/"), width=fig_width, height=fig_length,units ='in', res = 300)
  figmap <- ggplot() + geom_point(data=fig9, aes(x=long, y=lat , col=as.factor(category)),
                                  shape=15,size=0.5,na.rm=T) 
  figmap <- figmap +  scale_color_manual(values = colfig9,name ="Category:",
                                         labels=labeltext)      
  figmap <- figmap +  geom_polygon(data = worldMap, aes(x = long, y = lat, group = group),color="grey",fill="grey")
  figmap <- figmap +  theme(plot.background=element_blank(),
                            panel.background=element_blank(),
                            axis.text.y   = element_text(size=16),
                            axis.text.x   = element_text(size=16),
                            axis.title.y  = element_text(size=16),
                            axis.title.x  = element_text(size=16),
                            panel.border  = element_rect(colour = "grey", size=.5,fill=NA),
                            legend.text   = element_text(size=11),
                            legend.title  = element_text(size=11),
                            legend.position = "bottom") +
    scale_x_continuous(breaks=coordxmap, name = "longitude") +
    scale_y_continuous(breaks=coordymap, name = "latitude")  +
    coord_cartesian(xlim=c(coordslim[1], coordslim[2]), ylim=c(coordslim[3],coordslim[4]))
  figmap <- figmap + guides(colour = guide_legend(override.aes = list(size=5),nrow=3,byrow=TRUE))
  
  figmap2 <- figmap +  geom_polygon(data = shapeEEZ, aes(x = long, y = lat, group = group),color="grey",fill=NA)
  figmap2 <- figmap2 +  geom_polygon(data = shapeReg, aes(x = long, y = lat, group = group),color="black",fill=NA)
  print(figmap2)
  dev.off() 
  
#### Figure 10

# figure 10 map of overlap between fishing intensity otter trawls and VME
  fig10 <- VMEVMS
  fig10 <- cbind(fig10, fig8b[match(fig10$csquares,fig8b$csquares), c("cat2")])  
  colnames(fig10)[ncol(fig10)] <- "Otter_cat"
  fig10$VME_ClassII <- ifelse(fig10$precaution == "none", 0, 1 )
  fig10$category <- paste(fig10$Otter_cat,fig10$VME_ClassII,sep="_")   

  colfig10 <- c("#bae4b3", "#238b45", "#fdbe85","#e31a1c","#bdd7e7","#2171b5")
  
  jpeg(file = paste(outdir,"Figure_10.jpeg",sep="/"), width=fig_width, height=fig_length,units ='in', res = 300)
  figmap <- ggplot() + geom_point(data=fig10, aes(x=long, y=lat , col=as.factor(category)),
                                  shape=15,size=0.5,na.rm=T) 
  figmap <- figmap +  scale_color_manual(values = colfig10,name ="Category:",
                                         labels=c("low intensity - no VME","low intensity - VME",
                                                  "med/high int. - no VME","med/high int. - VME",
                                                  "unfished - no VME", "unfished - VME"))      
  figmap <- figmap +  geom_polygon(data = worldMap, aes(x = long, y = lat, group = group),color="grey",fill="grey")
  figmap <- figmap +  theme(plot.background=element_blank(),
                            panel.background=element_blank(),
                            axis.text.y   = element_text(size=16),
                            axis.text.x   = element_text(size=16),
                            axis.title.y  = element_text(size=16),
                            axis.title.x  = element_text(size=16),
                            panel.border  = element_rect(colour = "grey", size=.5,fill=NA),
                            legend.text   = element_text(size=11),
                            legend.title  = element_text(size=11),
                            legend.position = "bottom") +
    scale_x_continuous(breaks=coordxmap, name = "longitude") +
    scale_y_continuous(breaks=coordymap, name = "latitude")  +
    coord_cartesian(xlim=c(coordslim[1], coordslim[2]), ylim=c(coordslim[3],coordslim[4]))
  figmap <- figmap + guides(colour = guide_legend(override.aes = list(size=5),nrow=3,byrow=TRUE))
  
  figmap2 <- figmap +  geom_polygon(data = shapeEEZ, aes(x = long, y = lat, group = group),color="grey",fill=NA)
  figmap2 <- figmap2 +  geom_polygon(data = shapeReg, aes(x = long, y = lat, group = group),color="black",fill=NA)
  print(figmap2)
  dev.off() 
  
  rm(list=setdiff(ls(), c("pathdir", "pathdir_nogit" , "EcoReg")))
