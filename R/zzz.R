.onLoad <- function(libname, pkgname) {

    current_config <- httr::config()
    verify_peer <- FALSE
  
    ## This address problems with Ubuntu 20.04 and the Ensembl https certificates
    test <- try(httr::GET("https://www.ensembl.org"), silent = TRUE)
    if(inherits(test, "try-error")) {
      if(grepl(test[1], pattern = "unable to get local issuer certificate")) {
        verify_peer <- TRUE
        new_config <- httr::config(ssl_verifypeer = FALSE)
        httr::set_config(new_config, override = FALSE)
      }
    }
    
    current_config <- httr::config()
    ## This address problems with Ubuntu 20.04 and the Ensembl https certificates
    test <- try(httr::GET("https://www.ensembl.org"), silent = TRUE)
    if(inherits(test, "try-error")) {
      if(grepl(test[1], pattern = "sslv3 alert handshake failure")) {
        if(verify_peer)
          new_config <- httr::config(ssl_verifypeer = FALSE, 
                                     ssl_cipher_list = "DEFAULT@SECLEVEL=1")
        else 
          new_config <- httr::config(ssl_cipher_list = "DEFAULT@SECLEVEL=1")
        httr::set_config(new_config, override = FALSE)
      }
    }
}