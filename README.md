# ad-triage-script
Domain trusts are links from one domain to another (which may or may not be on another forest). These trusts can be abused and attacked to 'leak' into another domain/forest by authenticating a securable AD principal, such as a compromised user, via the trusts. Security implications may include persistence and cross-organization compromises.

If you're responding to a security incident as an analyst for an MSP/MSSP that serves numerous organizations, this script can help triage the domain you're working on since some admins may not be aware of the trusts established in their AD. It's one thing to respond to small businesses operating on a single directory, it's a whole different ball game to respond to enterprise businesses with several subdomains and forests. 

**Features include the following:**<br />
_*Triages the current working domain and the forest it is joined to.<br />
*Enumerates the trusts(outbound, inbound and 2-way) currently established within the working domain.<br />
*Enumerates the universal groups and it's members.<br />
*Finds the Enterprise admins group and enumerates it's members.<br />
*Enumerates Foreign Security Principals, which are AD objects from another forest.<br />
*Enumerates AD Replication subnets.<br />
*Enumerates dhcp servers and associated subnets._


***To get full results, I recommend running the script on a domain controller that is not segmented from the PDCs on trusting domains.<br />
***Includes a b64 encoded one liner(incase you can run lines with no character limits).
