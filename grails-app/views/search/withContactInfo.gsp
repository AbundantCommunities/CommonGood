<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>CommonGood Search With Contact Info</title>

        <script type="text/javascript">
            function showSearchResults() {
                document.getElementById('show-results-form').submit();
            }

            function constructLine(fNames,lName,phone,email,address) {
                var lineIsClean = true;
                var constructedLine = '';

                if (fNames.length>0) {
                    constructedLine = constructedLine+fNames;
                    lineIsClean = false;
                }
                if (lName.length>0) {
                    if (!lineIsClean) {
                        constructedLine = constructedLine+' ';
                    }
                    constructedLine = constructedLine+lName;
                    lineIsClean = false;
                }
                if (phone.length>0) {
                    if (!lineIsClean) {
                        constructedLine = constructedLine+', ';
                    }
                    constructedLine = constructedLine+phone;
                    lineIsClean = false;
                }
                if (email.length>0) {
                    if (!lineIsClean) {
                        constructedLine = constructedLine+', ';
                    }
                    constructedLine = constructedLine+email;
                    lineIsClean = false;
                }
                if (address.length>0) {
                    if (!lineIsClean) {
                        constructedLine = constructedLine+', ';
                    }
                    constructedLine = constructedLine+address;
                }
                constructedLine = constructedLine+'\n';

                return constructedLine;
            }

            function emailList() {

                var pFNames = [];
                var pLName = [];
                var pPhone = [];
                var pEmail = [];
                var pAddress = [];

                var aQuestion = [];
                var aAnswer = [];
                var aFNames = []
                var aLName = [];
                var aPhone = []
                var aEmail = [];
                var aAddress = [];

                var aAssistQuestion = [];
                var aAssistAnswer = [];
                var aAssistFNames = [];
                var aAssistLName = [];
                var aAssistPhone = [];
                var aAssistEmail = [];
                var aAssistAddress = [];

                <g:if test="${people.size() > 0}">
                    <g:each in="${people}" var="person">
                        pFNames.push(decodeEntities('${person[1]}'));
                        pLName.push(decodeEntities('${person[2]}'));
                        pPhone.push(decodeEntities('${person[3]}'));
                        pEmail.push(decodeEntities('${person[4]}'));
                        pAddress.push(decodeEntities('${person[5]}'));
                    </g:each>
                </g:if>

                <g:if test="${answers.size() > 0}">
                    <g:each in="${answers}" var="answer">
                        <g:if test="${answer[1]}">
                            aAssistQuestion.push(decodeEntities('${answer[5]}'));
                            aAssistAnswer.push(decodeEntities('${answer[0]}'));
                            aAssistFNames.push(decodeEntities('${answer[3]}'));
                            aAssistLName.push(decodeEntities('${answer[4]}'));
                            aAssistPhone.push(decodeEntities('${answer[6]}'));
                            aAssistEmail.push(decodeEntities('${answer[7]}'));
                            aAssistAddress.push(decodeEntities('${answer[8]}'));
                        </g:if>
                        <g:else>
                            aQuestion.push(decodeEntities('${answer[5]}'));
                            aAnswer.push(decodeEntities('${answer[0]}'));
                            aFNames.push(decodeEntities('${answer[3]}'));
                            aLName.push(decodeEntities('${answer[4]}'));
                            aPhone.push(decodeEntities('${answer[6]}'));
                            aEmail.push(decodeEntities('${answer[7]}'));
                            aAddress.push(decodeEntities('${answer[8]}'));
                        </g:else>
                    </g:each>
                </g:if>

                var lineIsClean;
                var body = '\n\n\n\n-----------------------------------------------------------\nSearch results for "${q}":\n\n';

                if (pLName.length>0) {
                    body = body+'Found in ${people.size()} family member';
                    if (pLName.length>1) {
                        body = body+'s';
                    }
                    body = body+':\n\n';
                    for (i=0; i<pLName.length;i++) {
                        body = body+constructLine(pFNames[i],pLName[i],pPhone[i],pEmail[i],pAddress[i]);
                    }
                    body = body+'\n';
                }

                if (${answers.size()}>0) {
                    if (pLName.length>0) {
                        body = body+'\n';
                    }
                    body = body+'Found in ${answers.size()} answer';
                    if (${answers.size()}>1) {
                        body = body+'s';
                    }
                    body = body+':\n\n';
                }

                if (aLName.length>0) {
                    for (i=0;i<aLName.length;i++) {
                        body = body+'Answer: '+aAnswer[i]+' (Question: '+aQuestion[i]+')\n';
                        body = body+constructLine(aFNames[i],aLName[i],aPhone[i],aEmail[i],aAddress[i]);
                        body = body+'\n';
                    }
                }

                if (aAssistLName.length>0) {
                    body = body+'Those who would assist:\n\n';
                    for (i=0;i<aAssistLName.length;i++) {
                        body = body+'Answer: '+aAssistAnswer[i]+' (Question: '+aAssistQuestion[i]+')\n';
                        body = body+constructLine(aAssistFNames[i],aAssistLName[i],aAssistPhone[i],aAssistEmail[i],aAssistAddress[i]);
                        body = body+'\n';
                    }
                }

                if (aLName.length>0&&aAssistLName.length==0) {
                    body = body+'No one has offered to assist.\n';
                }

                body = encodeURIComponent(body);
                var email = 'mailto:?body='+body;
                document.location.href = email;
            }
        </script>

    </head>
    <body>
            <div class="content-section">

                <div style="width:910px;">
                    <div class="content-heading" style="display:inline-block;">&nbsp;</div>
                    <g:if test="${people.size()>0 || answers.size()>0}">
                        <div style="display:inline-block;float:right;"><span style="font-weight:bold;">Show:</span>  <a href="#" onclick="showSearchResults();">Search Results</a> | Contact Info</div>
                    </g:if>
                    <form id="show-results-form" action="<g:createLink controller='search' />" method="get">
                        <input id="show-results-criteria" type="hidden" name="q" value="${q}" />
                    </form>
                </div>

                <g:if test="${people.size()>0 || answers.size()>0}">
                    <div style="width:910px;">
                        <div style="display:inline-block;float:right;"><a href="#" onclick="emailList();">Email Contact List</a></div>
                    </div>
                </g:if>

                <g:if test="${people.size() == 0 && answers.size() == 0}">
                    <h4>Failed to find the exact word/phrase: "${q}"</h4>
                </g:if>

                <g:if test="${people.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;"><h4>Found "${q}" in ${people.size()} family member<g:if test="${people.size()>1}">s</g:if>:</h4></div>
                    <g:each in="${people}" var="person">
                        <div class="content-children-row">
                            <div class="cell190"><g:link controller="navigate" action="familymember" id="${person[0]}">${person[1]} ${person[2]}</g:link></div>
                            <div class="cell120">${person[3]}</div>
                            <div class="cell300"><a href="mailto:${person[4]}">${person[4]}</a></div>
                            <div class="cell250">${person[5]}</div>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>

                <g:if test="${answers.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;">
                        <h4>Found "${q}" in ${answers.size()} answer<g:if test="${answers.size()>1}">s</g:if>: <span style="font-weight:normal;">(<span style="font-weight:bold;">bold</span> = would assist)</span></h4>
                    </div>
                    <g:each in="${answers}" var="answer">
                        <div class="content-children-row">
                            <g:link controller="navigate" action="familymember" id="${answer[2]}"><div class="cell190 <g:if test='${answer[1]}'>bold</g:if>">${answer[3]} ${answer[4]}</div></g:link>
                            <div class="cell120">${answer[6]}</div>
                            <div class="cell300"><a href="mailto:${answer[7]}">${answer[7]}</a></div>
                            <div class="cell250">${answer[8]}</div>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>


            </div>
    </body>
</html>
