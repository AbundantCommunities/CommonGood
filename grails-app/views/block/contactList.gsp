<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
        <title>Abundant Communities - Edmonton</title>
        <meta name="description" content="Abundant Communities - Edmonton"/>
        <link rel="stylesheet" href="${resource(dir:'css',file:'common.css')}" />
        <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Quicksand">
    </head>
    <body>
        <div id="pagecontainer" style="width:770px;">
            <div style="margin-left:15px;padding-top:5px;"><h2>Contact List for Block ${block.code}, ${block.description}</h2></div>

            <div style="margin-left:15px;margin-top:15px;">
                <g:each in="${connectors}" var="bc">
                    <h3>BC: ${bc.fullName}, ${bc.phoneNumber}</h3>
                </g:each>
            </div>

            <div id="content-children" style="width:720px;padding-bottom:10px;">
                <g:each in="${families}" var="familyPack">
                    <div id="content-children-heading"><div class="cell350">${familyPack.thisFamily.name} Family, ${familyPack.thisFamily.address.text}</div></div>
                    <g:each in="${familyPack.members}" var="person">
                        <div class="content-children-row">
                            <div class="cell150">${person.fullName}</div>
                            <div class="cell120">${person.phoneNumber}</div>
                            <div class="cell300">${person.emailAddress}</div>
                            <div class="cell80">${person.birthYear}</div>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:10px;"></div>
                </g:each>
            </div>
            <br/>
        </div>
    </body>
</html>