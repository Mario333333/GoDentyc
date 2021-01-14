//
//  NetworkingProvider.swift
//  GoDentyc
//
//  Created by Mario Cesar Gaytan Cruz on 26/11/20.
//

import Foundation
import Alamofire


final class NetworkingProvider {
    static let shared = NetworkingProvider()
    let kBaseUrl = "https://gorest.co.in/public-api/"
    let statusOk = 200...299
    let kToken = "ec444623c7d7c0ae9b4ac2c09930c73f50767bfad9c3b1680464158ed137e72c"
    
    func getServices(success: @escaping (_ service: [Service])->(), failure: @escaping (_ error: Error)->()) {
        // con ese guion bajo _ user se oculta el nombre del parametro en la llamada, solo en la llamada se envia el valor
        // @escaping, indica que es un callback
        
        let url = "\(kBaseUrl)todos"
        // validate mthod para decirle a AF que es una peticion satisfactoria y se le pasa una secuencia de odigos satisfactorios
        AF.request(url, method: .get).validate(statusCode: statusOk).responseDecodable(of: ServiceResponce.self) { (response) in
            // al closure o constructor como dice brais le pasas el contexto de la clase o struct que tomara forma el json, los cuales tienen la misma estructura
            if let Services = response.value?.data {
                // llamada al callback
                success(Services)
            }else{
                failure(response.error!)
            }
            
        }
    }
    
}
