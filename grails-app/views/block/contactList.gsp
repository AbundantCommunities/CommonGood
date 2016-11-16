<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>CommonGood - Contact List</title>
        <asset:javascript src="copy2clipboard.js"/>
        <script type="text/javascript">

            function doEmailOne(emailAddress) {
                if (emailAddress) {
                    var numRows = 1;
                    var title = 'Email Person';
                    var description = 'CommonGood cannot send email for you, but you can copy the email address to the clipboard and then paste to address a new message that you create the way you normally do.';
                    var copyContentTitle = 'Person email address'
                    presentForCopy('emaildiv',emailAddress,numRows,title,description,copyContentTitle);
                }
            }

        </script>

        <style type="text/css">

            #emaildiv {
                top:90px;
                left:200px;
                width:540px;
            }

        </style>

    </head>
    <body>
            <div class="content-section">

                <div style="margin-top:-10px;"><h3>Contact List for Block ${block.code}, ${block.description}</h3></div>
                <div>
                    <g:each in="${connectors}" var="bc">
                        <h4>BC: ${bc.fullName}, ${bc.phoneNumber}</h4>
                    </g:each>
                </div>

                <g:each in="${families}" var="familyPack">
                    <div class="content-row bold"><div class="cell350">${familyPack.thisFamily.name} Family, ${familyPack.thisFamily.address.text}</div></div>
                    <g:each in="${familyPack.members}" var="person">
                        <div class="content-children-row">
                            <g:link controller="navigate" action="familymember" id="${person.id}"><div class="cell150">${person.fullName}</div></g:link>
                            <div class="cell120">${person.phoneNumber}</div>
                            <a href="#" onclick="doEmailOne('${person.emailAddress}');"><div class="cell300">${person.emailAddress}</div></a>
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
            <div id="transparent-overlay"></div>
            <div id="emaildiv" class="modal"></div>
    </body>
</html>