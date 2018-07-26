###
##load required libraries
library(caret)
library(tidyverse)
library(extrafont) #to use extra fonts not in the system
font_import() #download fonts this take few mnuites
loadfonts(device = "win") #load fonts to use in R


##Import data
sale.data <- read.csv("data/Wholesale customers data.csv")
sale.data$Channel <- as.factor(sale.data$Channel)
sale.data$Channel <- fct_recode(sale.data$Channel, Horeca = "1", Retail = "2")

sale.data$Region <- as.factor(sale.data$Region)
sale.data$Region <- fct_recode(sale.data$Region, Lisbon = "1", Oporto = "2", Other = "3")
sale.data$Region <- NULL

##Split to train and test sets
set.seed(75)
trainrows <- createDataPartition(sale.data$Channel, p = .75, list = F)
sale.train <- sale.data[trainrows,]
sale.test <- sale.data[-trainrows,]
sale.test$Channel <- fct_relevel(sale.test$Channel, "Retail")


##Logistic regression, using all variables as predictors 
set.seed(75)
glmFit <- train(Channel ~ ., data = sale.train, method = "glm", 
                metric = "ROC",
                trControl = trainControl(method = "cv", number = 10, 
                                         summaryFunction = twoClassSummary,  
                                         classProbs = T))

##Variables importance
summary(glmFit)
glmFit %>%
    varImp()

##Logestic regression, using only the most important variables
set.seed(75)
glmFit <- train(Channel ~ Detergents_Paper+Grocery, data = sale.train, method = "glm", 
                metric = "ROC",
                trControl = trainControl(method = "cv", number = 10, 
                                         summaryFunction = twoClassSummary,  
                                         classProbs = T)
)

##Confusion matrix, with sensitivity, specificity
confusionMatrix(fct_relevel(predict(glmFit, newdata = sale.test), "Retail"), sale.test$Channel)
##Measure the model performance using lift curve 
glmProb <- predict(glmFit, newdata = sale.test, type = "prob")
tempdata.glm <- data.frame(vals = sale.test$Channel, glmProb = glmProb$Retail)
liftCurve.glm <- caret::lift(vals ~ glmProb, data = tempdata.glm)
ggplot(liftCurve.glm)


##predict new samples
x1 <- seq(min(sale.test$Detergents_Paper)-10, 10000, by = 15)
x2 <- seq(min(sale.test$Grocery)-10, 40000, by = 30)
xGrid <- expand.grid(x1, x2)
colnames(xGrid) <- c("Detergents_Paper", "Grocery")
y <- fct_recode(predict(glmFit, xGrid), H = "Horeca", R = "Retail")

##plot predicted and observed samples 
ggplot()+
    geom_point(aes(x = xGrid$Detergents_Paper, y = xGrid$Grocery, color = y))+
    geom_point(aes(x = sale.test$Detergents_Paper, y = sale.test$Grocery, 
                   color = sale.test$Channel))+
    scale_color_manual(name = "CHANNEL", values = c("#991010", "#CC2017", "#207713", "#23B133"),
                       labels = c("Horeca Area", "Horeca", "Retail Area", "Retail"))+
    scale_x_continuous(name = "DETERGENT & PAPER", limits = c(-1, 10000))+
    scale_y_continuous(name = "GROCERY", limits = c(-1, 40000))+
    theme(axis.title = element_text(size = 15, color = "#99CC89", 
                                    family = "Courier New", face = "bold"),
          axis.text.y = element_text(angle = 70, vjust = .4, hjust = .5), 
          axis.ticks = element_line(color = "grey50"),
          axis.ticks.length = unit(.1, "cm"),
          plot.margin  = margin(.15, .15, .15, .15, "inches"),
          legend.background = element_rect(fill = "grey85", color = "red", size = 1),
          legend.title = element_text(color = "blue", face = "bold", size = 14),
          legend.text = element_text(color = rgb(.06, .06, .4)),
          legend.key = element_rect(color = "grey50"),
          panel.background = element_rect(fill = "white"),
          panel.border = element_rect(size = 1.5, fill = NA, color = "grey50")
          )
    


    
