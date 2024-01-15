workspace {
    name "Conference Kata"
    description "The software architecture of the Conference Kata."

    model {
        user = person "Attendee"
        sponsor = person "Sponsor""Business person" {
            tags sponsor
        }
        speaker = person "Speaker""Natural person submitting papers" {
            tags speaker
        }
        softwareSystem = softwareSystem "Conference System""System desgin for Conference Management" {
            webapp = container "Web Application" "Conference Web Application" {
                tags website
                website = component "Website""React SPA - Shows conference information such as speakers, talks and schedule" {
                    tags "website"
                }
                attendee = component "Attendee System""System to manage attendee information, such as talks evaluation and access to slides"
                voting = component "Voting system""Send and receives evaluation via web, email, SMS or phone calls"
                branding = component "Branding system""Allow customization for several conference brands"

                website -> branding "Pull branding information from""HTTP Restful API"
                website -> attendee "Reads and writes information from ""HTTP Restful API"
                website -> voting "Sends requests and displays aggregation from""HTTPS"

            }
            group "Third-party" {
                cfpContainer = container "CFP System""Call For Papers System - Full management of speakers, talks, and schedule"{
                    cfp = component "CFP"
                    cfpStorage = component "storage"

                    cfp -> cfpStorage "Saves slides to"
                }
                crmContainer = container "CRM System" "Customer Relationship Management - sponsor management and notification system"{
                    crm = component "CRM"
                }
                ticketContainer = container "Alf.io""Ticketing System"{
                    ticket = component "Ticketing System"
                }
            }

            database = container "Database" "" "Relational database schema" {
                attendeeDB = component "Attendee DB""Relational DB for attendee" {
                    tags Database
                }
                ticketDb = component "Ticket DB""Relational Database" {
                    tags Database
                }
                websiteDb = component "Website DB""Relational Database" {
                    tags Database
                }
                cfpDB = component "CFP DB""Relational Database" {
                    tags Database
                }
                brandingDB = component "Branding DB""Stores information about branding" {
                    tags Database
                }

                ticket -> ticketDb "Reads and writes tickets info to"
                website -> websiteDb "Reads from and writes to"

                cfp -> cfpDB "Reads from and writes to"
                branding -> brandingDB "Reads and writes to"
                attendee -> attendeeDB "Reads and writes to"
            }

            // Interactions
            user -> website "Visits"
            user -> ticket "Buys from"

            speaker -> cfp "Applies to"
            cfp -> speaker "Send CFP info to"

            sponsor -> crm "Interacts with"
            crm -> sponsor "Send emails to"

            website -> cfp "Read data from"
            crm -> user "Send notifications to""Email"

            website -> crm "Reads Sponsor info from"
        }

        prod = deploymentEnvironment "Production" {
            deploymentNode "Amazon Web Services" {
                tags "Amazon Web Services - Cloud"

                region = deploymentNode "EU-East-1" {
                    description "AWS - Europe Zone"
                    technology "AWS"
                    tags "Amazon Web Services - Region"

                    route53 = infrastructureNode "Route 53" {
                        tags "Amazon Web Services - Route 53"
                    }

                    cdn = infrastructureNode "AWS CDN""Amazon CloudFront"{
                        tags "Amazon Web Services - CloudFront"
                    }

                    s3 = infrastructureNode "Storage""AWS - S3" {
                        tags "Amazon Web Services - Simple Storage Service"
                    }

                    deploymentNode "Amazon - Auto Scaling Groups""Manages elastic EC2 configuration" {
                        tags "Amazon Web Services - Application Auto Scaling"

                        deploymentNode "Amazon Web Services - EC2""This EC2 instance is part of an Auto Scaling Group" {
                            softwareSystemInstance softwareSystem
                            webApplicationInstance = containerInstance webapp
                        }
                    }

                    deploymentNode "Amazon EC2 - Tickets" {
                        tags "Amazon Web Services - EC2"

                        deploymentNode "Ubuntu Server" {
                            softwareSystemInstance softwareSystem
                            ticketApplicationInstance = containerInstance ticketContainer
                        }
                    }
                    deploymentNode "Amazon EC2 - CFP" {
                        tags "Amazon Web Services - EC2"
                        deploymentNode "Ubuntu Server" {
                            softwareSystemInstance softwareSystem
                            cfpApplicationInstance = containerInstance cfpContainer
                        }
                    }

                    deploymentNode "Amazon RDS" {
                        tags "Amazon Web Services - RDS"

                        deploymentNode "MySQL" {
                            tags "Amazon Web Services - RDS MySQL instance"
                            databaseApplicationInstance = containerInstance database
                        }
                    }

                    elb = infrastructureNode "Elastic Load Balancer" {
                        description "Automatically distributes incoming application traffic."
                        tags "Amazon Web Services - Elastic Load Balancing"
                    }
                }

                route53 -> elb "Forwards requests to" "HTTPS"
                elb -> webApplicationInstance "Forwards requests to" "HTTPS"
                elb -> cfpApplicationInstance "Forwards traffic to" "HTTPS"
                elb -> ticketApplicationInstance "Forwards requests to""HTTPS"
                elb -> cdn "Forwards request to""HTTPS"

                cfpApplicationInstance -> s3 "Storages slides to"
                cdn -> s3 "Enables access to slides"
            }
        }
    }

    views {
        systemLandscape softwareSystem {
            title "Conference System Landscape"
            include *
            autolayout lr
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
            autolayout lr
        }

        container softwareSystem {
            title "Container view of software system"
            include *
            autolayout lr
        }

        component cfpContainer {
            title "Component view of the CFP container"
            include *
            autolayout lr
        }

        component database {
            title "Container view of Database"
            include *
            autolayout lr
        }

        component webapp {
            title "Component view of web application"
            include * ticketDb websiteDb
            /*animation {
                user
                website
                ticketContainer
                database
                sponsor
                crm
                speaker
                cfp
            }*/
        }

        deployment softwareSystem prod "Production"{
            title "Deployment in production"
            include *
            autolayout lr

            animation {
                elb
                region
            }
        }

        styles {
            element "Group:Third-party" {
                border dotted
                color #AA0000
                background #BB0000
                opacity 75
            }

            element "Database"{
                background #00aa00
            }

            element "speaker" {
                background #000000
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
        }

        theme default
        themes https://static.structurizr.com/themes/amazon-web-services-2023.01.31/theme.json
    }

}