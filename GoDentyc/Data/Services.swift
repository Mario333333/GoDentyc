//
//  Services.swift
//  GoDentyc
//
//  Created by Mario Cesar Gaytan Cruz on 26/11/20.
//

/*
{
  "code": 200,
  "meta": {
    "pagination": {
      "total": 1803,
      "pages": 91,
      "page": 1,
      "limit": 20
    }
  },
  "data": [
    {
      "id": 25,
      "user_id": 13,
      "title": "Adultus suffoco thesaurus patior amo coma accusantium.",
      "completed": true,
      "created_at": "2020-11-26T03:50:04.353+05:30",
      "updated_at": "2020-11-26T03:50:04.353+05:30"
    },
   
  ]
}
 */

// La estructura debe implementar el protocolo decodable, para que se pueda decodificar una respuesta json y convertirla a un tipo de dato swift 
struct ServiceResponce: Decodable {
    let code: Int?
    let data: [Service]
}

struct Service: Decodable {
    let id: Int?
    let user_id: Int?
    let title: String?
    let completed: Bool?
}



import Foundation
