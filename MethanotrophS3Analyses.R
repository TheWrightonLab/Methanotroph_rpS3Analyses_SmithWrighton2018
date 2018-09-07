#20 June 2018
#This R script is for analyzing biogeography data, which is in the form of a tree and a map, with metadata.
#Load packages
library(ggplot2)
theme_set(theme_classic())
library(ggtree)
library(packcircles)
library(ggmap)
library(reshape)
library(RColorBrewer)
library(dendextend)
library(phangorn)
library(phytools)
library(phyloseq)
library(tidyr)
library(plyr)
library(grid)

#Set working directory
setwd("~/Downloads")

#Make tree object
MethanotrophS3Tree=read.raxml(file="Methanotroph_rpS3_Modified_Alignment_RAxML")
TreePlot=ggtree(MethanotrophS3Tree,layout="rectangular")+geom_tiplab(align=F)+geom_text2(aes(label=node))
#viewClade(TreePlot,node=1379)
#ggtree(MethanotrophS3Tree,layout="circular")+geom_text2(aes(label=node))#+geom_tiplab2(align=F)
#ggtree(MethanotrophS3Tree,layout="circular")+geom_nodepoint(aes(color=!is.na(as.numeric(bootstrap))&as.numeric(bootstrap)>70),size=5)
#Root the tree to the archaea sequences
MethanotrophS3Tree_Root=MethanotrophS3Tree;MethanotrophS3Tree_Root@phylo=root(MethanotrophS3Tree_Root@phylo,node=1402,edgelabel=T)
RootTreePlot=ggtree(MethanotrophS3Tree_Root,layout="rectangular")+geom_tiplab(align=F)+geom_text2(aes(label=node))
#viewClade(RootTreePlot,node=1395)
#ggtree(MethanotrophS3Tree_Root,layout="circular",ladderize=T)+geom_text2(aes(label=node))#+geom_tiplab2(align=F)
RootTreePlot2=ggtree(MethanotrophS3Tree_Root,layout="circular",ladderize=T)+theme(legend.position="left")+geom_treescale(width=1)
RootTreePlot3=open_tree(RootTreePlot2,angle=30)
RootTreePlot4=rotate_tree(RootTreePlot3,angle=90)

#Load metadata
MethanotrophS3Metadata=read.csv(file="Methanotroph_rpS3_Metadata.csv",header=T)
MethanotrophS3Metadata2=MethanotrophS3Metadata[is.na(MethanotrophS3Metadata$Outgroup),]
MethanotrophS3Metadata2$Latitude=round(MethanotrophS3Metadata2$Latitude,digits=1)
MethanotrophS3Metadata2$Longitude=round(MethanotrophS3Metadata2$Longitude,digits=1)
MethanotrophS3Metadata2$Dummy=rep(1,times=nrow(MethanotrophS3Metadata2))

#Modify data for heatmapping onto tree
heatdata1=MethanotrophS3Metadata2
heatdata1=heatdata1%>%drop_na(Name.in.Fastas)
rownames(heatdata1)=heatdata1$Name.in.Fastas;heatdata1=heatdata1[,-1]
RootTreePlot2A=ggtree(MethanotrophS3Tree_Root,layout="circular",ladderize=T)+theme(legend.position="left")+geom_treescale(width=1)
RootTreePlot3A=open_tree(RootTreePlot2A,angle=30)
RootTreePlot4A=rotate_tree(RootTreePlot3A,angle=90)
RootTreePlot5A=gheatmap(RootTreePlot4A,heatdata1[,c("Specific.Ecosystem","MetaType","Treatment"),drop=F],width=0.5)
LotsaColors2=c("green3","turquoise","orchid","maroon","deepskyblue","gray50","forestgreen","gray70","salmon","deepskyblue","black","deepskyblue","deepskyblue","cadetblue3","cadetblue3","black","red","red","slategray4","yellowgreen","azure2","deepskyblue","dodgerblue","yellow","maroon","chocolate2","goldenrod")
RootTreePlot6A=RootTreePlot5A+scale_fill_manual(values=LotsaColors2)+geom_nodepoint(aes(color=!is.na(as.numeric(bootstrap))&as.numeric(bootstrap)>=70),size=1.5)+geom_cladelabel(node=793,label="Gamma",offset=2,align=T)+geom_cladelabel(node=791,label="Alpha",offset=2,align=T)+geom_cladelabel(node=1384,label="Methylomirabilis",offset=2,align=T)+geom_cladelabel(node=1394,label="Methylacidiphilae",offset=2,align=T)+geom_cladelabel(node=1440,label="ANME-1",offset=2,align=T)+geom_cladelabel(node=1405,label="ANME-2",offset=2,align=T)
RootTreePlot6A

#Make a base map
mapWorld=borders("world",fill="seashell")
Plain=ggplot()+theme_void()+mapWorld
#Add data to map
S3Data=Plain+geom_point(data=MethanotrophS3Metadata2,aes(y=Latitude,x=Longitude))
MethanotrophS3Metadata3=MethanotrophS3Metadata2
MethanotrophS3Metadata3A=ddply(MethanotrophS3Metadata3,.(Genome.Type,BioProject,BioSample,Latitude,Longitude,PhyloClass),summarize,"Count"=sum(Dummy))
MethanotrophS3Metadata3B=ddply(MethanotrophS3Metadata3,.(Latitude,Longitude,PhyloClass),summarize,"Count"=sum(Dummy))
ClassColors2=c("forestgreen","red","purple","blue","orange")
S3FancyMap1=Plain+geom_jitter(data=MethanotrophS3Metadata3A[MethanotrophS3Metadata3A$Genome.Type!="Isolate",],aes(x=Longitude,y=Latitude,group=BioProject,size=Count,color=PhyloClass),width=1.5)+scale_size_continuous(range=c(5,10),breaks=c(1,5,10,20))+scale_color_manual(values=ClassColors2)+scale_shape_manual(values=c(17,17,16,15,15))+coord_fixed(1.3)
S3FancyMap1
ggplot(MethanotrophS3Metadata3A[is.na(MethanotrophS3Metadata3A$Latitude)&MethanotrophS3Metadata3A$Genome.Type!="Isolate",])+geom_bar(aes(x=1,y=Count,fill=PhyloClass),stat="identity")+coord_polar(theta="y",start=0)+scale_fill_manual(values=ClassColors2)

#Look at taxonomic breakdowns among genes and MAGs
#Genes by %ID top ref. isolate or MAG
ClassColors1=c("forestgreen","purple","blue")
ggplot(MethanotrophS3Metadata2[MethanotrophS3Metadata2$Genome.Type=="Gene"|MethanotrophS3Metadata2$Genome.Type=="MAG",])+geom_histogram(aes(x=IsolateRefPercID,fill=PhyloClass),binwidth=1,position="stack",color="black")+scale_fill_manual(values=ClassColors1)+facet_grid(Genome.Type~.,scales="free_y")
ddply(MethanotrophS3Metadata2[MethanotrophS3Metadata2$Genome.Type=="Gene"|MethanotrophS3Metadata2$Genome.Type=="MAG",],.(Genome.Type,PhyloClass,IsolatePercID=factor(round(IsolateRefPercID,digits=0))),summarize,Count=sum(Dummy))
ddply(MethanotrophS3Metadata2[MethanotrophS3Metadata2$Genome.Type=="Gene"|MethanotrophS3Metadata2$Genome.Type=="MAG",],.(Genome.Type,PhyloClass),summarize,Count=sum(Dummy))
ddply(MethanotrophS3Metadata2[MethanotrophS3Metadata2$Genome.Type=="Gene"&MethanotrophS3Metadata2$IsolateRefPercID>=97,],.(PhyloClass),summarize,Count=sum(Dummy))
ddply(MethanotrophS3Metadata2[MethanotrophS3Metadata2$Genome.Type=="MAG"&MethanotrophS3Metadata2$IsolateRefPercID>=97,],.(PhyloClass),summarize,Count=sum(Dummy))
#MAGs taxonomy
MethanotrophS3Metadata4=MethanotrophS3Metadata2
MethanotrophS3Metadata4$Genome.Type[MethanotrophS3Metadata4$Genome.Type=="Contig"]="MAG";MethanotrophS3Metadata4$Genome.Type[MethanotrophS3Metadata4$Genome.Type=="SAG"]="MAG"
MethanotrophS3PhyloDat=as.data.frame(ddply(MethanotrophS3Metadata4,.(Genome.Type,PhyloClass,PhyloFamily,PhyloGenus),summarize,Count=sum(Dummy)))
MethanotrophS3PhyloDat$PhyloClass=factor(MethanotrophS3PhyloDat$PhyloClass,levels=unique(MethanotrophS3PhyloDat$PhyloClass))
MethanotrophS3PhyloDat$PhyloFamily=factor(MethanotrophS3PhyloDat$PhyloFamily,levels=unique(MethanotrophS3PhyloDat$PhyloFamily))
MethanotrophS3PhyloDat$PhyloGenus=factor(MethanotrophS3PhyloDat$PhyloGenus,levels=unique(MethanotrophS3PhyloDat$PhyloGenus))
MethanotrophS3PhyloDat$Genome.Type=factor(MethanotrophS3PhyloDat$Genome.Type,levels=c("Isolate","MAG","Gene"))
MethanotrophS3PhyloDat=MethanotrophS3PhyloDat[order(MethanotrophS3PhyloDat$PhyloGenus),];MethanotrophS3PhyloDat=MethanotrophS3PhyloDat[order(MethanotrophS3PhyloDat$PhyloClass),]
UniqGen=unique(MethanotrophS3PhyloDat$PhyloGenus[MethanotrophS3PhyloDat$PhyloGenus!="Unclassified"&MethanotrophS3PhyloDat$PhyloGenus!="Unknown"])
MethanotrophS3PhyloDat$PhyloGenus=factor(MethanotrophS3PhyloDat$PhyloGenus,levels=unique(MethanotrophS3PhyloDat$PhyloGenus))
#ggplot(MethanotrophS3PhyloDat)+geom_bar(aes(x=PhyloClass,y=Count,fill=PhyloGenus),position="stack",stat="identity")+facet_grid(Genome.Type~.,scales="free_y")+scale_fill_viridis_d()
#GenusColors=c(brewer.pal(6,"YlGn"),"black","gray50","#005a32","#de2d26",rep(brewer.pal(9,"BuPu"),times=2),"#6a51a3","#2171b5","#fdae6b","#d94801")
#ggplot(MethanotrophS3PhyloDat)+geom_bar(aes(x=PhyloClass,y=Count,fill=PhyloGenus,group=PhyloFamily),color="white",position="stack",stat="identity")+facet_grid(Genome.Type~.,scales="free_y")+scale_fill_manual(values=GenusColors)
#ggplot(MethanotrophS3PhyloDat[MethanotrophS3PhyloDat$Genome.Type=="MAG",])+geom_bar(aes(x=PhyloClass,y=Count,fill=PhyloGenus),position="stack",stat="identity")+scale_fill_viridis_d()
GenusColors2=c(brewer.pal(3,"YlGn"),"black","#005a32",brewer.pal(6,"BuPu"),brewer.pal(5,"BuPu"),"blue","red")
ggplot(MethanotrophS3PhyloDat[MethanotrophS3PhyloDat$Genome.Type=="MAG",])+geom_bar(aes(x=PhyloClass,y=Count,fill=PhyloGenus,group=PhyloFamily),color="white",position="stack",stat="identity")+scale_fill_manual(values=GenusColors2)
#ggplot(MethanotrophS3PhyloDat[MethanotrophS3PhyloDat$Genome.Type!="Gene",])+geom_bar(aes(x=PhyloClass,y=Count,fill=PhyloGenus,group=PhyloFamily),position="stack",stat="identity")+facet_grid(Genome.Type~.,scales="free_y")+scale_fill_viridis_d()
#GenusColors3=c(brewer.pal(6,"YlGn"),"black","#005a32","#de2d26",rep(brewer.pal(9,"BuPu"),times=2),"#6a51a3","#2171b5","#fdae6b","#d94801")
#ggplot(MethanotrophS3PhyloDat[MethanotrophS3PhyloDat$Genome.Type!="Gene",])+geom_bar(aes(x=PhyloClass,y=Count,fill=PhyloGenus,group=PhyloFamily),color="white",position="stack",stat="identity")+facet_grid(Genome.Type~.,scales="free_y")+scale_fill_manual(values=GenusColors3)
