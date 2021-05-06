require("tidyjson")
require(jsonlite)

valheim <- RJSONIO::fromJSON("rawdata/loottables.json")

valheim2 <- rlist::list.flatten(valheim)
       
valheim3 <- data.table(names=names(valheim2))

valheim3[,values:=valheim2]

max_splits <- ncol(valheim3[,tstrsplit(names,"\\.")])


valheim3[,(paste0("level",1:max_splits)):=tstrsplit(names,"\\.")]


valheim_loot <- valheim3[level1%ilike%"loot"]
valheim_loot[level2 =="Object",enemy:=
               values %>%  unlist]
valheim_loot[,enemy:=na.locf(enemy)]
valheim_loot[,.N,keyby=enemy]
valheim_loot[level3 =="Level",level:=values %>%  unlist]
valheim_loot[,level:=na.locf(level,na.rm=F),by=.(enemy)]
valheim_loot[,level:=na.locf(level,na.rm=F,fromLast=T),by=.(enemy)]

valheim_loot2 <- valheim_loot[level3 =="Loot"]

valheim_drops <- valheim_loot[level3 %like%"Drops",.(enemy,level,level3,values)]
valheim_drops[,c("items","probability"):=.(values[[1]][[1]],values[[1]][[2]]),by=1:nrow(valheim_drops)]

valheim_drops2 <- dcast(valheim_drops,enemy +level  ~ items,value.var = "probability")

valheim_drops2[,`4`:=0]
valheim_drops2[,`5`:=0]

valheim_drops2[is.na(valheim_drops2)] <- 0

valheim_drops2_enemy <- valheim_drops2[enemy=="Neck"]
valheim_drops2_enemy <- valheim_drops2

number <- names(valheim_drops2_enemy)[str_detect(names(valheim_drops2_enemy),"[:digit:]")]
  
valheim_drops2_enemy[,(number):=as.list(dnorm(0:5,0+0.2*level,1)*100),by=1:nrow(valheim_drops2_enemy)]
valheim_drops2_enemy[,total:=sum(dnorm(0:5,0+0.2*level,1)),by=1:nrow(valheim_drops2_enemy)]
valheim_drops2_enemy[,(number):=lapply(.SD,function(x) x/total),.SDcols=number]
valheim_drops2_enemy[,(number):=lapply(.SD,function(x) round(x)),.SDcols=number]
valheim_drops2_enemy[,total:=NULL]

valheim_melt <- melt(valheim_drops2_enemy,id.vars = c("enemy","level"))

valheim_melt[,variable:=as.numeric(as.character(variable))]

#valheim_melt[,combo:=list(list(paste0(variable,",",value))),by=1:nrow(valheim_melt)]

valheim_melt[,combo:=lapply(transpose(.(variable,value)), as.list)]

valheim_melt[1,combo]

valheim_melt2 <- valheim_melt[,.(Drops=combineListsAsOne(combo)),by=.(enemy,level)]

# valheim_melt2[,Drops:=Drops[[1]][[1]],by=1:nrow(valheim_melt2)]
# valheim_melt[1,combo][[1]] %>%  toJSON()
# valheim_melt2[1,Drops][[1]] %>%  toJSON()
#valheim_melt2[1,V1][[1]] %>%  toJSON(collapse="") %>% write("output2.json")


#[ [        0,    0.51 ],[        1,    0.38 ],[        2,     0.1 ],[        3,    0.01 ]]

valheim_loot3 <- valheim_loot2[,.(enemy,level,level4,values)]

valheim_loot3[level4 =="Item",item:=values %>%  unlist]
valheim_loot3[,item:=na.locf(item)]

valheim_loot4 <- valheim_loot3[level4 != "Item"]
# 
# toJSON(list(Object="Neck",
#             LeveledLoot=list(list(Level=1,
#                                                             Loot=list(list(Item="Tier0Ingredients",
#                                                                            Weight=90,
#                                                                            Rarity=list(0,
#                                                                                        0,
#                                                                                        0,
#                                                                                        0
#                                                                                        )
#                                                                            ))
#                                                             )
#                                                        ))) %>%  clipr::write_clip()

# for(i in 1: length(valheim_loot5[,unique(Object)])) {
#   list(Object=valheim_loot5[1,Object],
#        LeveledLoot=list(list(Level=1,
#                              Loot=list(list(Item="Tier0Ingredients",
#                                             Weight=90,
#                                             Rarity=list(0,
#                                                         0,
#                                                         0,
#                                                         0
#                                             )
#                              ))
#        )
#        ))
# }
# list(Item="Tier0Ingredients",
#                                                  Weight=90,
#                                                  Rarity=list(0,
#                                                              0,
#                                                              0,
#                                                              0
#                                                  )
# )
#####Loot
#enemy
#level
#item
#Rarity: vector of length 4

valheim_loot4 <- valheim_loot4[,tail(.SD,1),by=.(enemy,level,item,level4)]

valheim_loot5 <- dcast(valheim_loot4,enemy +level +item ~ level4,value.var = "values")

valheim_loot5[,Loot:=list(list(list("Item"=item,"Weight"=Weight %>%  unlist,"Rarity"=Rarity %>%  unlist))),by=1:nrow(valheim_loot5)]

valheim_loot6 <- valheim_loot5[,.(Loot=combineListsAsOne(Loot)),by=.(enemy,level)]

valheim_complete <- merge(valheim_loot6,valheim_melt2,by=c("enemy","level"))
setnames(valheim_complete,1:2,c("Object","Level"))

vg <- valheim_complete[Object=="Neck"]

vg[,object2:=list(list(Object))]

cbind(vg[1,Object],vg[1,lapply(.SD,function(x) x[[1]]),.SDcols=c("Loot","Drops")]) %>%  toJSON

vg[,Object:="Tier0Mob"]

testing <- list(Object=vg[1,Object],Drops=vg[1,Drops],Loot=vg[1,Loot][[1]]) %>%  toJSON

toJSON(vg) 
write(testing, "output.json")

#enter does not seem to matter
# 
write(RJSONIO::toJSON(valheim_loot6[1,Loot][[1]]), "output.json")
