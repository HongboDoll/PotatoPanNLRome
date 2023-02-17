######### 5:15 ratio
library('bezier')

a <- read.table('52_potato.caj1.bed',header=F)

ab <- read.table('caj1_aln_region.xls',header=F)

par(oma=c(0,0,0,0),mar=c(0,0,0,0))

left_margin <- a[1,3] # coordinates of 9930 reference #min(a$V3,b$V3,c$V3,d$V3,e$V3,f$V3), here a[1,3] refer to the left start coordinate of the first gene of 9930

spe_num <- max(as.vector(a[,length(a[1,])-1]))

width <- 0.9
sv_width <- 1.6

#### refine the coordinates of the other species according to Heinz1706 ref
left_l <- c()
for (i in 1:spe_num){
    a1 <- subset(a,V6==i)
    if (a1[1,3] > left_margin){
        left <- min(a1[,3])
        left_l <- c(left_l, left)
        for (n in 1:length(a1[,1])){
            a1[n,3] <- a1[n,3] - (left - left_margin)
            a1[n,4] <- a1[n,4] - (left - left_margin)
        } 
    } else {
        left <- min(a1[,3])
        left_l <- c(left_l, left)
        for (n in 1:length(a1[,1])){
            a1[n,3] <- a1[n,3] + (left_margin - left)
            a1[n,4] <- a1[n,4] + (left_margin - left)	
        }
    }
    a <- rbind(a1, subset(a,V6!=i))
}

for (i in 2:spe_num){
    ab1 <- subset(ab,V9==i)
    if (ab1[1,3] > left_margin){
        left <- left_l[i-1]
        for (n in 1:length(ab1[,1])){
            ab1[n,3] <- ab1[n,3] - (left - left_margin)
            ab1[n,4] <- ab1[n,4] - (left - left_margin)
        }
        if (ab1[1,7] > left_margin){
            left <- left_l[i]
            for (n in 1:length(ab1[,1])){
                ab1[n,7] <- ab1[n,7] - (left - left_margin)
                ab1[n,8] <- ab1[n,8] - (left - left_margin)
            }
        } else {
            left <- left_l[i]
            for (n in 1:length(ab1[,1])){
                ab1[n,7] <- ab1[n,7] + (left_margin - left)
                ab1[n,8] <- ab1[n,8] + (left_margin - left)
            }
        }
    } else {
        left <- left_l[i-1]
        for (n in 1:length(ab1[,1])){
            ab1[n,3] <- ab1[n,3] + (left_margin - left)
            ab1[n,4] <- ab1[n,4] + (left_margin - left)
        }
        if (ab1[1,7] > left_margin){
            left <- left_l[i]
            for (n in 1:length(ab1[,1])){
                ab1[n,7] <- ab1[n,7] - (left - left_margin)
                ab1[n,8] <- ab1[n,8] - (left - left_margin)
            }
        } else {
            left <- left_l[i]
            for (n in 1:length(ab1[,1])){
                ab1[n,7] <- ab1[n,7] + (left_margin - left)
                ab1[n,8] <- ab1[n,8] + (left_margin - left)
            }
        }
    }
    ab <- rbind(ab1, subset(ab,V9!=i))
}


#### plot frame and line 
right_margin <- max(a$V4)
inter <- (right_margin - left_margin)/30

#### move all these sgements to middle
xl <- c()
for (i in 1:spe_num){
    a1 <- subset(a,V6==i)
    x <- (right_margin - max(a1[,4]) - min(a1[,3]) + left_margin)/2
    xl <- c(xl, x)
    for (n in 1:length(a1[,1])){
        a1[n,3] <- a1[n,3] + x
        a1[n,4] <- a1[n,4] + x
    }
    a <- rbind(a1, subset(a,V6!=i))
}

for (i in 2:spe_num){
    ab1 <- subset(ab,V9==i)
    x <- xl[i-1]
    for (n in 1:length(ab1[,1])){
        ab1[n,3] <- ab1[n,3] + x
        ab1[n,4] <- ab1[n,4] + x
    }
    x <- xl[i]
    for (n in 1:length(ab1[,1])){
        ab1[n,7] <- ab1[n,7] + x
        ab1[n,8] <- ab1[n,8] + x
    }
    
    ab <- rbind(ab1, subset(ab,V9!=i))
}

#### plot line

plot(0,0,type='n',axes=F,main='',xlab='',ylab='',xlim=c(left_margin - inter, right_margin + inter), ylim=c(1*10-5,spe_num*10+5)) # ylim: min-5=1*10-5, max+5=(spe_num*10)+5

#### all sgenments are in equal length 

#for (i in 1:spe_num){
#    segments(left_margin - inter,i*10,right_margin + inter,i*10,lwd=5,lend=0, #col=rgb(128,128,128,max=255))
#}

#### sgenments lengths are associated with actual gene cluster length

for (i in 1:spe_num){
    a1 <- subset(a,V6==i)
    left <- min(a1[,3])
    right <- max(a1[,4])
    segments(left - inter,(spe_num+1-i)*10,right + inter,(spe_num+1-i)*10,lwd=2.5,lend=1, col=rgb(128,128,128,max=255))
}


#### plot gene body (according to plus and minus strand)
for (n in 1:spe_num){
    a1 <- subset(a,V6==n)
    nn <- n + (spe_num-(2*(n-1)+1))
    for (i in 1:length(a1[,1])){
        if (a1[i,7] == "yellow"){
            gene_col = '#FEDD7F'
        } else if (a1[i,7] == "red") {
            gene_col = 'red'
        } else {
            gene_col = '#84C9F7'
        }
        if (a1[i,5] == "+"){
            polygon(c(a1[i,3],a1[i,3],a1[i,3]+0.85*(a1[i,4]-a1[i,3]),a1[i,4],a1[i,3]+0.85*(a1[i,4]-a1[i,3]),a1[i,3]), c(nn*10+width,nn*10-width,nn*10-width,nn*10,nn*10+width,nn*10+width),col=gene_col,border='NA')
        } else {
            polygon(c(a1[i,4],a1[i,4],a1[i,4]-0.85*(a1[i,4]-a1[i,3]),a1[i,3],a1[i,4]-0.85*(a1[i,4]-a1[i,3]),a1[i,4]), c(nn*10+width,nn*10-width,nn*10-width,nn*10,nn*10+width,nn*10+width),col=gene_col,border='NA')
        }
    }
}

synteny_col = rgb(220,220,220,max=255)
#### plot synteny relationship curved polygon
t <- seq(0, 1, length=100)
#p <- matrix(c(0,0, 1,2, 3,2, 4,4), nrow=4, ncol=2, byrow=TRUE)
#plot(bezier(t=t, p=p))
for (n in 2:spe_num){
    ab1 <- subset(ab,V9==n)
    nn <- n-1 + (spe_num-(2*(n-2)+1))
    a_y <- nn*10
    b_y <- (nn-1)*10
    for (i in 1:length(ab1[,1])){
        if (ab1[i,2] == "+" && ab1[i,6] == "+"){
            p1 <- matrix(c(ab1[i,3],a_y-width-0.2, ab1[i,3]+(ab1[i,7]-ab1[i,3])/4,a_y-width-0.2-(a_y-width-0.2-(b_y+width+0.2))/2,  ab1[i,3]+3*(ab1[i,7]-ab1[i,3])/4,b_y+width+0.2+(a_y-width-0.2-(b_y+width+0.2))/2, ab1[i,7],b_y+width+0.2), nrow=4, ncol=2, byrow=TRUE) ############### /2 represents curve ratio
            p2 <- matrix(c(ab1[i,3]+0.85*(ab1[i,4]-ab1[i,3]),a_y-width-0.2, ab1[i,3]+0.85*(ab1[i,4]-ab1[i,3])+(ab1[i,7]+0.85*(ab1[i,8]-ab1[i,7])-(ab1[i,3]+0.85*(ab1[i,4]-ab1[i,3])))/4,b_y+width+0.2+(a_y-width-0.2-(b_y+width+0.2))/2,  ab1[i,3]+0.85*(ab1[i,4]-ab1[i,3])+3*(ab1[i,7]+0.85*(ab1[i,8]-ab1[i,7])-(ab1[i,3]+0.85*(ab1[i,4]-ab1[i,3])))/4,a_y-width-0.2-(a_y-width-0.2-(b_y+width+0.2))/2, ab1[i,7]+0.85*(ab1[i,8]-ab1[i,7]),b_y+width+0.2), nrow=4, ncol=2, byrow=TRUE)
            x1 <- bezier(t=t, p=p1)[,1]
            y1 <- bezier(t=t, p=p1)[,2]
            x2 <- rev(bezier(t=t, p=p2)[,1])
            y2 <- rev(bezier(t=t, p=p2)[,2])
            cx <- c()
            cx <- c(x1, x2, ab1[i,3])
            cy <- c()
            cy <- c(y1, y2, a_y-width-0.2)
            polygon(cx,cy,col=synteny_col,border=synteny_col)
        } else if (ab1[i,2] == "-" && ab1[i,6] == "-") {
            p1 <- matrix(c(ab1[i,4],a_y-width-0.2, ab1[i,4]+(ab1[i,8]-ab1[i,4])/4,b_y+width+0.2+(a_y-width-0.2-(b_y+width+0.2))/2,  ab1[i,4]+3*(ab1[i,8]-ab1[i,4])/4,a_y-width-0.2-(a_y-width-0.2-(b_y+width+0.2))/2, ab1[i,8],b_y+width+0.2), nrow=4, ncol=2, byrow=TRUE)
            p2 <- matrix(c(ab1[i,4]-0.85*(ab1[i,4]-ab1[i,3]),a_y-width-0.2, ab1[i,4]-0.85*(ab1[i,4]-ab1[i,3])+(ab1[i,8]-0.85*(ab1[i,8]-ab1[i,7])-(ab1[i,4]-0.85*(ab1[i,4]-ab1[i,3])))/4,b_y+width+0.2+(a_y-width-0.2-(b_y+width+0.2))/2,  ab1[i,4]-0.85*(ab1[i,4]-ab1[i,3])+3*(ab1[i,8]-0.85*(ab1[i,8]-ab1[i,7])-(ab1[i,4]-0.85*(ab1[i,4]-ab1[i,3])))/4,a_y-width-0.2-(a_y-width-0.2-(b_y+width+0.2))/2, ab1[i,8]-0.85*(ab1[i,8]-ab1[i,7]),b_y+width+0.2), nrow=4, ncol=2, byrow=TRUE)
            x1 <- bezier(t=t, p=p1)[,1]
            y1 <- bezier(t=t, p=p1)[,2]
            x2 <- rev(bezier(t=t, p=p2)[,1])
            y2 <- rev(bezier(t=t, p=p2)[,2])
            cx <- c()
            cx <- c(x1, x2, ab1[i,4])
            cy <- c()
            cy <- c(y1, y2, a_y-width-0.2)
            polygon(cx,cy,col=synteny_col,border=synteny_col)
        } else {
            p1 <- matrix(c(ab1[i,3],a_y-width-0.2, ab1[i,3]+(ab1[i,7]-ab1[i,3])/4,a_y-width-0.2-(a_y-width-0.2-(b_y+width+0.2))/2,  ab1[i,3]+3*(ab1[i,7]-ab1[i,3])/4,b_y+width+0.2+(a_y-width-0.2-(b_y+width+0.2))/2, ab1[i,7],b_y+width+0.2), nrow=4, ncol=2, byrow=TRUE) ############### /2 represents curve ratio
            p2 <- matrix(c(ab1[i,3]+0.85*(ab1[i,4]-ab1[i,3]),a_y-width-0.2, ab1[i,3]+0.85*(ab1[i,4]-ab1[i,3])+(ab1[i,7]+0.85*(ab1[i,8]-ab1[i,7])-(ab1[i,3]+0.85*(ab1[i,4]-ab1[i,3])))/4,b_y+width+0.2+(a_y-width-0.2-(b_y+width+0.2))/2,  ab1[i,3]+0.85*(ab1[i,4]-ab1[i,3])+3*(ab1[i,7]+0.85*(ab1[i,8]-ab1[i,7])-(ab1[i,3]+0.85*(ab1[i,4]-ab1[i,3])))/4,a_y-width-0.2-(a_y-width-0.2-(b_y+width+0.2))/2, ab1[i,7]+0.85*(ab1[i,8]-ab1[i,7]),b_y+width+0.2), nrow=4, ncol=2, byrow=TRUE)
            x1 <- bezier(t=t, p=p1)[,1]
            y1 <- bezier(t=t, p=p1)[,2]
            x2 <- rev(bezier(t=t, p=p2)[,1])
            y2 <- rev(bezier(t=t, p=p2)[,2])
            cx <- c()
            cx <- c(x1, x2, ab1[i,3])
            cy <- c()
            cy <- c(y1, y2, a_y-width-0.2)
            polygon(cx,cy,col=synteny_col,border=synteny_col)
        }
    }
}

