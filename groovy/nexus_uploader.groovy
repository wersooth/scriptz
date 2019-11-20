#! /usr/bin/env groovy


/* jenkins Nexus Uploader

   ___            _    _             _   _                       _   _       _                 _           
  |_  |          | |  (_)           | \ | |                     | | | |     | |               | |          
    | | ___ _ __ | | ___ _ __  ___  |  \| | _____  ___   _ ___  | | | |_ __ | | ___   __ _  __| | ___ _ __ 
    | |/ _ \ '_ \| |/ / | '_ \/ __| | . ` |/ _ \ \/ / | | / __| | | | | '_ \| |/ _ \ / _` |/ _` |/ _ \ '__|
/\__/ /  __/ | | |   <| | | | \__ \ | |\  |  __/>  <| |_| \__ \ | |_| | |_) | | (_) | (_| | (_| |  __/ |   
\____/ \___|_| |_|_|\_\_|_| |_|___/ \_| \_/\___/_/\_\\__,_|___/  \___/| .__/|_|\___/ \__,_|\__,_|\___|_|   
                                                                      | |                                  
                                                                      |_|                                  


*/

def call(Map conf) {

    // check if all params exist. 
    if (! conf['nuser'] ) {
        echo "No Nexus Username! Define nuser parameter!"
    }
    if (! conf['npass'] ) {
        echo "No Nexus password! Define npass parameter!"
    }
    if (! conf['nrepo'] ) {
        echo "No Nexus repository URL! Define nrepo parameter!"
    }
    if (! conf['artifact'] ) {
        echo "No Artifact! Define artifact parameter!"
    }

    // checking for optional folder parameter

    if ( conf['nfolder'] ) {
        HAS_SUBFOLDERS = true
    } else {
        HAS_SUBFOLDERS = false
    }

    // checking for tools 
    CURL_EXIST = sh(script: 'which curl', returnStatus: true)
    WGET_EXIST = sh(script: 'which wget', returnStatus: true)

    if ( CURL_EXIST == 0 ) {
        if ( HAS_SUBFOLDERS== true ) {
            CURL_UPLOAD="curl -w '%{http_code}' -o /dev/null -u ${conf['nuser']}:${conf['npass']} --upload-file ${conf['artifact']} ${conf['nrepo']}/${conf['nfolder']}/${conf['artifact']}"
        } else {
            CURL_UPLOAD="curl -w '%{http_code}' -o /dev/null -u ${conf['nuser']}:${conf['npass']} --upload-file ${conf['artifact']} ${conf['nrepo']}/${conf['artifact']}"
        }
        UPLOAD_STATUS=sh (script: CURL_UPLOAD, returnStdout: true)
    } else if ( WGET_EXIST == 0 ) {        
        UPLOAD_STATUS="999"
    } else {        
        UPLOAD_STATUS="666"
    }

    //evaluate exit code

    switch(UPLOAD_STATUS) {
        case "400":
            print("ERROR! ${UPLOAD_STATUS} Bad Request!")
            break
        case "401":
            print("ERROR! ${UPLOAD_STATUS} Unauthorized!")
            break
        case "403":
            print("ERROR! ${UPLOAD_STATUS} Forbidden!")
            break
        case "404":
            print("ERROR! 404 Not Found!")
            break
        case "409":
            print("ERROR! ${UPLOAD_STATUS} Conflict error!")
            break
        case "500":
            print("ERROR! ${UPLOAD_STATUS} Internal Server error!")
            break
        case "502":
            print("ERROR! ${UPLOAD_STATUS} Bad Gateway!")
            break
        case "503":
            print("ERROR! ${UPLOAD_STATUS} Service Unavailable!")
            break
        case "504":
            print("ERROR! ${UPLOAD_STATUS} Gateway Timeout!")
            break
        case "598":
            print("ERROR! ${UPLOAD_STATUS} Network Read Error!")
            break
        case "599":
            print("ERROR! ${UPLOAD_STATUS} Network Connect timeout error!")
            break
        case "200":
            print("Artifact Uploaded. Status: ${UPLOAD_STATUS}")
            break
        case "201":
            print("Artifact Uploaded. Status: ${UPLOAD_STATUS}")
            break
        case "666":
            print("Cannot find CURL or WGET!")
            break
        case "999":
            print("Not Implemented!")
            break
        default:
            print("Unknown status! Status: ${UPLOAD_STATUS}")
        break
    }

}
