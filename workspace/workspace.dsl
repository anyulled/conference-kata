workspace {
    name "Conference Kata"
    description "The software architecture of the Software Crafters' Conference Kata."

    !adrs adrs
    !docs docs

    model {
        user = person "Attendee"
        organizer = person "Organizer" "Someone managing the system" {
            tags organizer
        }
        sponsor = person "Sponsor" "A Business person" {
            tags sponsor
        }
        speaker = person "Speaker" "Natural person submitting papers" {
            tags speaker
        }

        softwareSystem = softwareSystem "Conference System" "System desgin for Conference Management" {

            webapp = container "Web Application" "Conference Web Application" website {

                website = component "Website" "React SPA - Shows conference information such as speakers, talks and schedule" {
                    tags "website"
                }
                attendee = component "Attendee System" "System to manage attendee information, such as talks evaluation and access to slides"
                voting = component "Voting system" "Send and receives evaluation via web, email, SMS or phone calls"
                branding = component "Branding system" "Allow customization for several conference brands"

                website -> branding "Pull branding information from" "gRPC" gRPC
                website -> attendee "Reads and writes information from " "gRPC" gRPC
                website -> voting "Sends requests and displays aggregation from" "gRPC" gRPC
                user -> website "Visits"
                organizer -> branding "Customizes branding"
            }
            database = container "Database" "" "Relational database schema" {
                tags Database
                attendeeDB = component "Attendee DB" "Relational DB for attendee" {
                    tags Database
                }
                websiteDb = component "Website DB" "Relational Database" {
                    tags Database
                }
                brandingDB = component "Branding DB" "Stores information about branding" {
                    tags Database
                }

                website -> websiteDb "Reads from and writes to" "JDBC"
                branding -> brandingDB "Reads and writes to" "JDBC"
                attendee -> attendeeDB "Reads and writes to" "JDBC"
                voting -> websiteDb "Reads from and writes to" "JDBC"
            }

        }

        group "Third-party" {

            authSystem = softwareSystem "Authentication" "Authentication Service - SaaS" {
                tags external
                authContainer = container "Authentication Service" "Third-party service" {
                    authAPI = component "Auth API""https"

                }
                softwareSystem -> this "Authenticates user to"
                webapp -> authContainer "Authenticates user to" "Third-party service"
                website -> authContainer "Authenticates user to" "Third-party service"

            }

            cfpSystem = softwareSystem "CFP" "Call for Papers" {
                tags external
                cfpContainer = container "CFP System" "Call For Papers System - Full management of speakers, talks, and schedule" {
                    cfp = component "CFP"
                    cfpDB = component "CFP DB" "Relational Database" {
                        tags Database
                    }
                    cfpStorage = component "storage"

                    cfp -> cfpStorage "Saves slides to"
                    cfp -> cfpDB "Reads from and writes to"
                    cfp -> speaker "Send CFP info to"
                    speaker -> cfp "Applies to"
                    website -> cfp "Reads data from" "Https"
                }
            }

            crmSystem = softwareSystem "CRM" "Customer relationship manager" {
                tags external
                crmContainer = container "CRM System" "Customer Relationship Management - sponsor management and notification system" {
                    crm = component "CRM"
                }

                sponsor -> crm "Interacts with"
                crm -> sponsor "Send emails to" "Email"
                crm -> user "Send notifications to" "Email, sms"
                website -> crm "Reads Sponsor info from" "Https"
            }

            ticketSystem = softwareSystem "Ticket" "Ticket management" {
                tags external
                ticketContainer = container "Ticket System" "Ticketing System" {
                    ticket = component "Ticketing System"
                    ticketDb = component "Ticket DB" "Relational Database" {
                        tags Database
                    }
                }

                user -> ticket "Buys from"
                ticket -> ticketDb "Reads and writes tickets info to"
            }

        }

        prod = deploymentEnvironment "Production Deployment" {
            deploymentNode "Amazon Web Services" {
                tags "Amazon Web Services - Cloud Map	"

                region = deploymentNode "EU-East-1" {
                    description "AWS - Europe Zone"
                    technology "AWS"
                    tags "Amazon Web Services - Region"

                    route53 = infrastructureNode "Route 53" {
                        tags "Amazon Web Services - Route 53"
                    }
                    elb = infrastructureNode "Elastic Load Balancer" {
                        description "Automatically distributes incoming application traffic."
                        tags "Amazon Web Services - Elastic Load Balancing"
                    }
                    cdn = infrastructureNode "AWS CDN" "Amazon CloudFront" {
                        tags "Amazon Web Services - CloudFront"
                    }
                    s3 = infrastructureNode "Storage" "AWS - S3" {
                        tags "Amazon Web Services - Simple Storage Service"
                    }

                    deploymentNode "Amazon - Auto Scaling Groups" "Manages elastic EC2 configuration" {
                        tags "Amazon Web Services - Application Auto Scaling"

                        deploymentNode "Amazon Web Services - EC2" "This EC2 instance is part of an Auto Scaling Group" {
                            tags "Amazon Web Services - EC2"
                            softwareSystemInstance softwareSystem
                            webApplicationInstance = containerInstance webapp
                        }
                    }
                    deploymentNode "Amazon EC2 - CRM" {
                        tags "Amazon Web Services - EC2"

                        deploymentNode "Ubuntu Server - CRM App" {
                            tags "Ubuntu"
                            softwareSystemInstance crmSystem
                            crmApplicationInstance = containerInstance crmContainer
                        }
                    }
                    deploymentNode "Amazon EC2 - Tickets" {
                        tags "Amazon Web Services - EC2"

                        deploymentNode "Ubuntu Server - Ticket App" {
                            tags "Ubuntu"
                            softwareSystemInstance ticketSystem
                            ticketApplicationInstance = containerInstance ticketContainer
                        }
                        elb -> this "Forwards requests to" "HTTPS"
                    }
                    deploymentNode "Amazon EC2 - CFP" {
                        tags "Amazon Web Services - EC2"
                        deploymentNode "Ubuntu Server - CFP App" {
                            tags "Ubuntu"
                            softwareSystemInstance cfpSystem
                            cfpApplicationInstance = containerInstance cfpContainer
                        }
                        this -> s3 "Storages slides"
                        cfpApplicationInstance -> s3 "Storages slides"
                    }
                    deploymentNode "Amazon EC2 - Auth" {
                        tags "Amazon Web Services - EC2"
                        deploymentNode "Ubuntu Server - Auth App" {
                            tags "Ubuntu"
                            softwareSystemInstance authSystem
                            authApplicationInstance = containerInstance authContainer
                        }
                        //webApplicationInstance -> authApplicationInstance "Send Authentication requests to""HTTPS"

                    }
                    deploymentNode "Amazon RDS" {
                        tags "Amazon Web Services - RDS"

                        deploymentNode "MySQL" {
                            tags "Amazon Web Services - RDS MySQL instance"
                            databaseApplicationInstance = containerInstance database
                        }
                    }

                }

                route53 -> elb "Forwards requests to" "HTTPS"
                elb -> ticketApplicationInstance "Forwards requests to" "HTTPS"
                elb -> authApplicationInstance "Forwards requests to" "HTTPS"
                elb -> crmApplicationInstance "Forwards requests to" "HTTPS"
                elb -> cfpApplicationInstance "Forwards traffic to" "HTTPS"
                elb -> webApplicationInstance "Forwards requests to" "HTTPS"
                elb -> cdn "Forwards request to" "HTTPS"

                cfpApplicationInstance -> s3 "Storages slides to"
                cdn -> s3 "Enables access to slides"
            }
        }
    }

    views {
        systemLandscape softwareSystem {
            title "Conference System Landscape"
            include *

            animation {
                softwareSystem
                user
                sponsor
                speaker
            }
        }

        systemContext softwareSystem {
            title "Conference System Context"
            include *

        }

        container softwareSystem {
            title "Container view of software system"
            include *

        }

        component database {
            title "Container view of Database"
            include *
        }

        component webapp {
            title "Component view of web application"
            include *
            animation {
                user
                website
                branding
                database
            }
        }

        deployment softwareSystem prod "Production" {
            title "Deployment in production"
            include *

            animation {
                route53
                elb
                webApplicationInstance
                databaseApplicationInstance
            }
        }

        styles {
            element "Group:Third-party" {
                border dotted
                color #AA0000
                background #BB0000
                opacity 75
            }
            element "external" {
                shape component
                background #000088
            }
            element "Database" {
                color #FFFFFF
                background #00aa00
            }
            element "speaker" {
                background #000000
                color #ffffff
            }

            element "organizer" {
                background #002454
                color #ffffff
            }
            element "sponsor" {
                background #FF0000
                color #ffffff
            }
            element "Database" {
                shape cylinder
            }
            element "website" {
                shape WebBrowser
            }
            element "Ubuntu" {
                color #E95420
                background #E95420
                stroke #E95420
                icon "images/ubuntu-logo.jpeg"
            }
            relationship "gRPC" {
                color #000088
                style dotted
            }
        }

        theme default
        themes https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json
        themes https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json
    }

}
