# Conference Kata

System design for [Conference Kata](https://nealford.com/katas/kata?id=AllStuffNoCruft)

## Requirements 
Conference organizer needs a management system for the conferences he runs for both speakers and attendees

### Users:
Hundreds of speakers, dozens of event staff, thousands of attendees

### Requirements:
attendees can access speaking schedule online, including room assignments
speakers can manage talks (enter, edit, modify)
attendees 'vote up/down' talks
organizer can notify attendees of schedule changes up-to-the-minute (if attendees opt in)
each conference (being a different subject) can be branded independently
speaker slides are accessible online only to attendees
evaluation system via web page, email, SMS, or phone
### Additional Context:

Conference runs across the Europe.

### Small support staff.

'Burst' traffic: extremely busy when the conference is occurring.
Conference organizer wants to easily 'skin' the site for different technology offerings.

## System Quality attributes
 [List of system quality attributes](https://en.wikipedia.org/wiki/List_of_system_quality_attributes)

* **Scalability**: The system must handle varying loads, especially 'burst' traffic during conferences. This includes the ability to scale resources up or down as needed to accommodate the number of attendees and speakers accessing the system simultaneously.
* **Performance**: The system should provide quick response times and handle requests efficiently, especially important during peak usage times. This includes fast loading of schedules, smooth handling of talk submissions, and efficient processing of attendee votes.
* **Availability**: High availability is crucial, particularly during the conference. The system should be operational and accessible with minimal downtime.
* **Reliability**: The system should function correctly and provide consistent results. This includes accurate scheduling information, reliable voting mechanisms, and dependable notifications for schedule changes.
* **Usability**: The system must be user-friendly for attendees, speakers, sponsors, and event staff. This includes intuitive navigation, clear interfaces for talk submissions, voting, and schedule viewing.
* **Security**: Given that the system handles personal information of attendees and speakers, robust security measures are essential to protect against unauthorized access and data breaches. This includes securing sensitive data like contact information and talk content.
* **Flexibility and Customizability:** The system should allow for easy branding and customization for different conferences. This includes the ability to change themes, layouts, and branding elements for each event.
* **Maintainability**: The system should be easy to maintain and update, allowing for quick fixes, updates, and the addition of new features without significant downtime or disruption.
* **Interoperability**: Given the integration with third-party systems (like the CFP and CRM systems), the system must effectively interact and integrate with these external systems.

