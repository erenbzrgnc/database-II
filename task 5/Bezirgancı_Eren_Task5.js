/*EREN BEZIRGANCI*/

/* QUESTION1 */

db.getCollection('lodging').find({},{"host.name":1,"host.surname":1, "host.age":1, _id:0})




/* QUESTION2 */


db.getCollection("lodging").aggregate([ 

    {$project:{
       
    "priceInt": {$toInt :{ $substr: [ "$lodging.price", 1, -1] }},
    "facilities" : {$size :{$objectToArray: "$lodging.amenities"} }

    
    }},
    
    {$sort:{
        "priceInt":1,
        "facilities" : 1
   
        
        }}


])





/* QUESTION3 */

 db.getCollection('lodging').aggregate([
    {$match:{
        "isActive":true, 
        "registered": {"$lte":"2013-03-01"}
            }  
    },
    {$group:{
         _id: "$lodging.address.state",
        "sum" : {$sum: 1}
            }       
    },
    
    {$sort:{
        "sum":1
           }
     }
 ])


 /* QUESTION4 */

db.getCollection("lodging").aggregate([ 

    {$project:{
        
        "result":  {$cond: {if:{"$lte": [{$size:"$lodging.reviews"}, 2 ]}, 
        then: {"reviews2":"$lodging.reviews"}, 
        else:{
         "reviews": {$filter: {
             input:"$lodging.reviews",
             as: "el",
             cond: {"$eq" : [{"$mod": [{$indexOfArray:["$lodging.reviews", "$$el"]}, 3]} , 2] }
              }
              
            }
            
        }}     
           
    
    }}}
])
    



 /* QUESTION5 */
db.getCollection("lodging").aggregate([ 
    {$unwind:{
               path: "$lodging.reviews",
               includeArrayIndex: "arrayIndex"
        }},

    {$group:{
        _id : {"cleanliness": "$lodging.reviews.cleanliness",  "location": "$lodging.reviews.location", "food":"$lodging.reviews.food"},
        "total" : {$sum:1}
        
        }},
        
        
     {$sort:{
         "total":1
         
         }}
        
])




 /* QUESTION6 */

 db.getCollection("lodging").aggregate([
 
    {$match:{
    
       "lodging.address.state":"Ohio"
       }},
   
    {$unwind:{
       path: "$lodging.reviews",
       includeArrayIndex: "arrayIndex"
       }},
        
       
     {$unwind:{
        path: "$host.languages",
        includeArrayIndex: "arrayIndex"
        }},
       
      {$group:{
           _id: {"id":"$_id",
                  "lang" : "$host.languages", 
                  "accomodation": "$lodging"},
           "avg" : {$avg: {$divide: [{$add: ["$lodging.reviews.cleanliness","$lodging.reviews.food","$lodging.reviews.location"]},3]}},
           },
           },
       
       
       {$match:{
           
           $or : [{"avg": {$gt:7.5}}, {"_id.lang" : "english"}]

           }},
      
       {$sort:{
           "avg":1
           }}
       

])


        