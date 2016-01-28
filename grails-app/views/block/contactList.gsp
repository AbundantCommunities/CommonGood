<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Abundant Communities - Edmonton</title>
    </head>
    <body>
            <div id="content-children" style="padding-bottom:10px;">

                <div style="margin-top:-10px;"><h3>Contact List for Block ${block.code}, ${block.description}</h3></div>
                <div>
                    <g:each in="${connectors}" var="bc">
                        <h4>BC: ${bc.fullName}, ${bc.phoneNumber}</h4>
                    </g:each>
                </div>

                <g:each in="${families}" var="familyPack">
                    <div id="content-children-heading"><div class="cell350">${familyPack.thisFamily.name} Family, ${familyPack.thisFamily.address.text}</div></div>
                    <g:each in="${familyPack.members}" var="person">
                        <div class="content-children-row">
                            <g:link controller="navigate" action="familymember" id="${person.id}"><div class="cell150">${person.fullName}</div></g:link>
                            <div class="cell120">${person.phoneNumber}</div>
                            <a href="mailto:${person.emailAddress}" target="_top"><div class="cell300">${person.emailAddress}</div></a>
                            <g:if test="${person.birthYear!=0}">
                                <div class="cell80">${person.birthYear}</div>
                            </g:if>
                            <g:else>
                                <div class="cell80"></div>
                            </g:else>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:10px;"></div>
                </g:each>
            </div>
    </body>
</html>