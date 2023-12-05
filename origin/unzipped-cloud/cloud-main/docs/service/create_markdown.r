
################################################################################
### In case the conversion from json to md will be made with a function.
# json_to_md <- function(json_file) {
# }
################################################################################


################################################################################
# Loading (or installing if necessary) the rjson package. 
require("rjson")

# Checking the list of available .json files.
json_files <- grep(".json", dir())
json_files <- dir()[json_files]

# Removing the template.json from the list of .json files.
json_files <- json_files[-which(json_files == "template.json")]

# Processing each .json file to create (or update) its associated .md file in
# a for loop. 

# json_file <- json_files[1]
# json_file

for (json_file in json_files) {
  dat     <- fromJSON(file=json_file)
  md_file <- paste0(dat$id, ".md")
  
  # Removing the .md file if exists to avoid multiple conversions in it. 
  if (md_file %in% dir()) {system(paste0("rm ", md_file))}
  
  # Creating the associated .md file.
  system(paste0("touch ", md_file))
  system(paste0("echo '' >> ", md_file))
  # system(paste0("touch ", dat$id, ".md"))
  
  # Checking if there is a logo file and, if so, adding it. 
  if ("screenshot" %in% names(dat)) {
    
    # Creating the full link to the logo file.
    screenshot_link <- paste0("https://raw.githubusercontent.com/VHP4Safety/cloud/main/docs/service/", dat$screenshot)
    
    # Adding a line to add the logo using the html syntax for the cloud repo.
    system(paste0("echo \"<img src='", screenshot_link,"' width='400' height='100'>\" >> ", md_file))
    system(paste0("echo \"\" >> ", md_file))
    
    # Adding another (commented out) line to add the logo using the markdown 
    # syntax to be used for creating .rst files in the documentation repo.
    system(paste0("echo \"<!--- ![screenshot of ", dat$service, "](", screenshot_link, " 'Click on the image to go to the service.') --->\" >> ", md_file))
    system(paste0("echo \"\" >> ", md_file))
  }
  
  system(paste0("echo \"------------------------\" >> ", md_file))
  system(paste0("echo \"\" >> ", md_file))
  
  
  # Adding the stylized service name.
  system(paste0("echo \"# ", dat$service, "\" >> ", md_file))
  system(paste0("echo \"\" >> ", md_file))
  
  # Adding the service description. 
  system(paste0("echo \"**Description:** ", dat$description, "\" >> ", md_file))
  system(paste0("echo \"\" >> ", md_file))
  
  # Adding the URL to the service (if exists).
  if ("url" %in% names(dat)) {
    system(paste0("echo \"**Webpage:** [", dat$url, "](", dat$url, ")\" >> ", md_file))
    system(paste0("echo \"\" >> ", md_file))
  }
  
  # Adding the DOI to the service (if exists).
  if ("doi" %in% names(dat)) {
    system(paste0("echo \"**Reference:** [https://doi.org/", dat$doi, "](https:doi.org/", dat$doi, ")\" >> ", md_file))
    system(paste0("echo \"\" >> ", md_file))
  }
  
  system(paste0("echo \"------------------------\" >> ", md_file))
  system(paste0("echo \"\" >> ", md_file))
  
  
  # Adding a section if there is instance information available. 
  system(paste0("echo \"## VHP4Safety Instance\" >> ", md_file))
  system(paste0("echo \"\" >> ", md_file))
  
  if ("instance" %in% names(dat)) {
    if ("type" %in% names(dat$instance)) {
      system(paste0("echo \"**Type:** ", dat$instance$type, " \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    } else {
      system(paste0("echo \"**Type:** NA \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
    
    if ("vhp-platform" %in% names(dat$instance)) {
      system(paste0("echo \"**VHP Platform:** ", dat$instance$`vhp-platform`, " \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    } else {
      system(paste0("echo \"**VHP Platform:** NA \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
    
    if ("url" %in% names(dat$instance)) {
      system(paste0("echo \"**URL:** [", dat$instance$url, "](", dat$instance$url, ")\" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    } else {
      system(paste0("echo \"**URL:** NA \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
    
    if ("license" %in% names(dat$instance)) {
      system(paste0("echo \"**License:** ", dat$instance$license, " \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    } else {
      system(paste0("echo \"**License:** NA \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
    
    if ("version" %in% names(dat$instance)) {
      system(paste0("echo \"**Version:** ", dat$instance$version, " \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    } else {
      system(paste0("echo \"**Version:** NA \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
    
    if ("source" %in% names(dat$instance)) {
      system(paste0("echo \"**Source:** [", dat$instance$source, "](", dat$instance$source, ")\" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    } else {
      system(paste0("echo \"**Source:** NA \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
    
    if ("docker" %in% names(dat$instance)) {
      system(paste0("echo \"**Docker:** [", dat$instance$docker, "](", dat$instance$docker, ")\" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    } else {
      system(paste0("echo \"**Docker:** NA \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
    
    if ("TRL" %in% names(dat$instance)) {
      system(paste0("echo \"**Technology Readiness Level:** ", dat$instance$TRL, " \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    } else {
      system(paste0("echo \"**Technology Readiness Level:** NA \" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
  } else {
    system(paste0("echo \"There is currently no instance to this service maintained by VHP4Safety.\" >> ", md_file))
    system(paste0("echo \"\" >> ", md_file))
  }

  system(paste0("echo \"------------------------\" >> ", md_file))
  system(paste0("echo \"\" >> ", md_file))
  
  
  # Adding a section for the provider contact information.
  system(paste0("echo \"## Provider Contact Information\" >> ", md_file))
  system(paste0("echo \"\" >> ", md_file))
  if ("provider" %in% names(dat)) {
    if ("contact" %in% names(dat$provider)) {
      
      # Creating the contact person info section differently based on the 
      # information available in the json file. 
      if (all(c("name", "email") %in% names(dat$provider$contact))) {
        system(paste0("echo \"**Contact Person:** ", dat$provider$contact$name, " (email: ", dat$provider$contact$email, ")\" >> ", md_file))
        system(paste0("echo \"\" >> ", md_file))
      } else if ("name" %in% names(dat$provider$contact)) {
        system(paste0("echo \"**Contact Person:** ", dat$provider$contact$name, "\" >> ", md_file))
        system(paste0("echo \"\" >> ", md_file))
      } else if ("email" %in% names(dat$provider$contact)) {
        system(paste0("echo \"**Contact Person (email):** ", dat$provider$contact$email, "\" >> ", md_file))
        system(paste0("echo \"\" >> ", md_file))
      }
    }
    
    # Creating the provider info section differently based on the information 
    # available in the json file. 
    if (all(c("url", "name") %in% names(dat$provider))) {
      system(paste0("echo \"**Provider:** [", dat$provider$name, "](", dat$provider$url, ")\" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    } else if ("name" %in% names(dat$provider)) {
      system(paste0("echo \"**Provider:** ", dat$provider$name, "\" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    } else if ("url" %in% names(dat$provider)) {
      system(paste0("echo \"**Provider:** [", dat$provider$url, "](", dat$provider$url, ")\" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
    
  } else {
    system(paste0("echo \"There is currently no information available about the service provider.\" >> ", md_file))
    system(paste0("echo \"\" >> ", md_file))
  }
  
  system(paste0("echo \"------------------------\" >> ", md_file))
  system(paste0("echo \"\" >> ", md_file))
  
  
  # Adding a section regarding the access to the service, if available. 
  if ("access" %in% names(dat)) {
    system(paste0("echo \"## Service Access\" >> ", md_file))
    system(paste0("echo \"\" >> ", md_file))
    
    if ("API" %in% names(dat$access)) {
      system(paste0("echo \"**API Type:** ", dat$access$API, "\" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
    
    if ("login" %in% names(dat$access)) {
      system(paste0("echo \"**Login Requirement:** ", dat$access$login, "\" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
    
    if ("packages" %in% names(dat$access)) {
      if (all(c("R", "Python") %in% names(dat$access$packages))) {
        system(paste0("echo \"**Other Implementations:** [R Package](", dat$access$packages$R, "), [Python Module](", dat$access$packages$Python, ")\" >> ", md_file))
        system(paste0("echo \"\" >> ", md_file))
      } else if ("R" %in% names(dat$access$packages)) {
        system(paste0("echo \"**Other Implementations:** [R Package](", dat$access$packages$R, ")\" >> ", md_file))
        system(paste0("echo \"\" >> ", md_file))
      } else if ("Python" %in% names(dat$access$packages)) {
        system(paste0("echo \"**Other Implementations:** [Python Module](", dat$access$packages$Python, ")\" >> ", md_file))
        system(paste0("echo \"\" >> ", md_file))
      }
      
    }
    
    system(paste0("echo \"------------------------\" >> ", md_file))
    system(paste0("echo \"\" >> ", md_file))
    
  }
  
  # Adding a section regarding the demo. 
  system(paste0("echo \"## Documentation\" >> ", md_file))
  system(paste0("echo \"\" >> ", md_file))
  
  if ("demo" %in% names(dat)) {
    if (all(c("title", "url") %in% dat$demo)) {
      system(paste0("echo \"[", dat$demo$title, "](", dat$demo$url, ")\" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    } else if ("url" %in% dat$demo) {
      system(paste0("echo \"[", dat$demo$url, "](", dat$demo$url, ")\" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
  } else {
    system(paste0("echo \"There is no documentation available at the moment.\" >> ", md_file))
    system(paste0("echo \"\" >> ", md_file))
  }
  
  # Adding a section regarding ELIXIR-related sources, if available.
  if ("ELIXIR" %in% names(dat)) {
    system(paste0("echo \"------------------------\" >> ", md_file))
    system(paste0("echo \"\" >> ", md_file))
    system(paste0("echo \"## ELIXIR-Related Sources\" >> ", md_file))
    system(paste0("echo \"\" >> ", md_file))
    
    if ("biotools" %in% names(dat$ELIXIR)) {
      system(paste0("echo \"[bio.tools](", dat$ELIXIR$biotools, ")\" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
    
    if ("tess" %in% names(dat$ELIXIR)) {
      system(paste0("echo \"[TeSS](", dat$ELIXIR$tess, ")\" >> ", md_file))
      system(paste0("echo \"\" >> ", md_file))
    }
  }
  
  system(paste0("echo \"------------------------\" >> ", md_file))
  system(paste0("echo \"\" >> ", md_file))
  
}
