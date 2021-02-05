#####Use to assign Kingdoms to taxIDs from NCBI

library(tidyverse)

###rankedlineage.dmp as downloaded from NCBI on 17th Dec 2019
tax <- read_tsv("FILEPATH/rankedlineage.dmp", 
                col_names = c("id", "name", "s", "g", "f", "o", "c","p", "k", "d"), 
                col_types=("i-c-c-c-c-c-c-c-c-c-"))

x2 <- gather(tax, "key", "value", 2:10) %>%
  filter(!is.na(value)) %>% 
  unite(2:3, col="name", sep="=") 

tax2 <-  group_by(x2, id) %>% 
  summarize(lineage= paste(name, collapse="; "))

blast_out = read.delim()

###rankedlineage.dmp as downloaded from NCBI on 17th Dec 2019
taxid <- read_tsv("FILEPATH/taxidlineage.dmp")
taxid = taxid[,c(1,3)]

library(stringr)

##Command line BLAST output in the format as seen in the example file
data_read = read.delim('FILEPATH/blasted_contigs.txt',header=F)

data_read2 = distinct(data_read,V1,.keep_all=TRUE)

data_read = as.matrix(data_read2)


vector_out = c()
for(i in 1:nrow(data_read))
{
  ###Change [i,X] where X = taxid column
  taxid_search = data_read[i,9]
  
  present = str_locate(taxid_search,';')
  if(!is.na(present[1]))
  {
    taxid_search = substr(taxid_search,1,(present[1]-1))
  }
  
  position = str_split((as.matrix(taxid[which(taxid[,1]==taxid_search),2]))," ")
  
  
  if(length(position) == 0)
  {
    vector_out = rbind(vector_out,c(data_read[i,],'unknown'))
  }
  else{
    
    bacteria = which(position[[1]] == '2')
    
    fungi = which(position[[1]] == '4751')
    
    virus = which(position[[1]] == '10239')
    
    if(length(bacteria) > 0)
    {
      vector_out = rbind(vector_out,c(data_read[i,],'bacteria'))
    }
    if(length(virus) > 0)
    {
      vector_out = rbind(vector_out,c(data_read[i,],'virus'))
    }
    if(length(fungi) > 0)
    {
      vector_out = rbind(vector_out,c(data_read[i,],'fungi'))
    }
    if(length(bacteria) == 0 && length(virus) == 0 && length(fungi) == 0)
    {
      vector_out = rbind(vector_out,c(data_read[i,],'other'))
    }
  }
}

##Write out new file, will have an additional column with assigned Kingdom
write.table(vector_out,'FILEPATH/higher_taxon.txt',sep='\t',row.names=F)



