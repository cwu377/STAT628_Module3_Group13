library(stringr)
library(ggplot2)

sushi=read.csv('sushi.csv')

ggplot(data=sushi,aes(x=stars))+
  geom_histogram(aes(y=..density..), fill="Skyblue")


sushi_park=read.csv('sushi_park.csv')

sushi_park$goodrating=sushi_park$stars>=4
sushi_park$OutdoorSeating=sushi_park$OutdoorSeating=='True'
sushi_park$RestaurantsDelivery=sushi_park$RestaurantsDelivery=='True'
sushi_park$WheelchairAccessible=sushi_park$WheelchairAccessible=='True'
sushi_park$BikeParking=sushi_park$BikeParking=='True'


sushi_park$NoiseLevel=gsub("u'",'',sushi_park$NoiseLevel)
sushi_park$NoiseLevel=gsub("'",'',sushi_park$NoiseLevel)
sushi_park$is_loud=str_detect(sushi_park$NoiseLevel,'d')


sushi_park$freewifi=str_detect(sushi_park$WiFi,'e')
sushi_park$casual=str_detect(sushi_park$Ambience,"'casual': True")
sushi_park$alco=str_detect(sushi_park$Alcohol,'r')

sp_model=glm(goodrating~OutdoorSeating+RestaurantsDelivery+WheelchairAccessible+
              BikeParking+is_loud+freewifi+casual+alco,
            data=sushi_park)
summary(sp_model)

ggplot(data=sushi_park,aes(x=stars,y=..density..,fill=alco))+
  geom_histogram(alpha=0.6,position = position_dodge())
ggplot(data=sushi_park,aes(x=stars,y=..density..,fill=WheelchairAccessible))+
  geom_histogram(alpha=0.6,position = position_dodge())
ggplot(data=sushi_park,aes(x=stars,y=..density..,fill=freewifi))+
  geom_histogram(alpha=0.6,position = position_dodge())
ggplot(data=sushi_park,aes(x=stars,y=..density..,fill=is_loud))+
  geom_histogram(alpha=0.6,position = position_dodge())













  