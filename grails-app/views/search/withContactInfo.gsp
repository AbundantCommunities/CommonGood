<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Abundant Communities - Edmonton</title>

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

                var aLeadQuestion = [];
                var aLeadAnswer = [];
                var aLeadFNames = [];
                var aLeadLName = [];
                var aLeadPhone = [];
                var aLeadEmail = [];
                var aLeadAddress = [];

                var aOrgQuestion = [];
                var aOrgAnswer = [];
                var aOrgFNames = [];
                var aOrgLName = [];
                var aOrgPhone = [];
                var aOrgEmail = [];
                var aOrgAddress = [];

                Encoder.EncodeType = "entity";

                <g:if test="${people.size() > 0}">
                    <g:each in="${people}" var="person">
                        pFNames.push(Encoder.htmlDecode('${person[1]}'));
                        pLName.push(Encoder.htmlDecode('${person[2]}'));
                        pPhone.push(Encoder.htmlDecode('${person[3]}'));
                        pEmail.push(Encoder.htmlDecode('${person[4]}'));
                        pAddress.push(Encoder.htmlDecode('${person[5]}'));
                    </g:each>
                </g:if>

                <g:if test="${answers.size() > 0}">
                    <g:each in="${answers}" var="answer">
                        <g:if test="${answer[1]}">
                            aLeadQuestion.push(Encoder.htmlDecode('${answer[6]}'));
                            aLeadAnswer.push(Encoder.htmlDecode('${answer[0]}'));
                            aLeadFNames.push(Encoder.htmlDecode('${answer[4]}'));
                            aLeadLName.push(Encoder.htmlDecode('${answer[5]}'));
                            aLeadPhone.push(Encoder.htmlDecode('${answer[7]}'));
                            aLeadEmail.push(Encoder.htmlDecode('${answer[8]}'));
                            aLeadAddress.push(Encoder.htmlDecode('${answer[9]}'));
                        </g:if>
                        <g:if test="${answer[2]}">
                            aOrgQuestion.push(Encoder.htmlDecode('${answer[6]}'));
                            aOrgAnswer.push(Encoder.htmlDecode('${answer[0]}'));
                            aOrgFNames.push(Encoder.htmlDecode('${answer[4]}'));
                            aOrgLName.push(Encoder.htmlDecode('${answer[5]}'));
                            aOrgPhone.push(Encoder.htmlDecode('${answer[7]}'));
                            aOrgEmail.push(Encoder.htmlDecode('${answer[8]}'));
                            aOrgAddress.push(Encoder.htmlDecode('${answer[9]}'));
                        </g:if>
                        <g:if test="${!answer[1]&&!answer[2]}">
                            aQuestion.push(Encoder.htmlDecode('${answer[6]}'));
                            aAnswer.push(Encoder.htmlDecode('${answer[0]}'));
                            aFNames.push(Encoder.htmlDecode('${answer[4]}'));
                            aLName.push(Encoder.htmlDecode('${answer[5]}'));
                            aPhone.push(Encoder.htmlDecode('${answer[7]}'));
                            aEmail.push(Encoder.htmlDecode('${answer[8]}'));
                            aAddress.push(Encoder.htmlDecode('${answer[9]}'));
                        </g:if>
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

                if (aLeadLName.length>0) {
                    body = body+'Those who would lead:\n\n';
                    for (i=0;i<aLeadLName.length;i++) {
                        body = body+'Answer: '+aLeadAnswer[i]+' (Question: '+aLeadQuestion[i]+')\n';
                        body = body+constructLine(aLeadFNames[i],aLeadLName[i],aLeadPhone[i],aLeadEmail[i],aLeadAddress[i]);
                        body = body+'\n';
                    }
                }

                if (aOrgLName.length>0) {
                    body = body+'Those who would organize:\n\n';
                    for (i=0;i<aOrgLName.length;i++) {
                        body = body+'Answer: '+aOrgAnswer[i]+' (Question: '+aOrgQuestion[i]+')\n';
                        body = body+constructLine(aOrgFNames[i],aOrgLName[i],aOrgPhone[i],aOrgEmail[i],aOrgAddress[i]);
                        body = body+'\n';
                    }
                }

                if (aLName.length>0&&aLeadLName.length==0&&aOrgLName.length==0) {
                    body = body+'No one has offered to lead or organize.';
                }

                body = encodeURIComponent(body);

                var email = 'mailto:?body='+body;

                document.location.href = email;
            }
        </script>

    </head>
    <body>
            <div id="content-children" style="padding-bottom:10px;">

                <div style="width:910px;">
                    <div class="content-heading" style="display:inline-block;">Searched for "${q}"</div>
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
                    <h4>"${q}" not found.</h4>
                </g:if>

                <g:if test="${people.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;"><h4>Found in ${people.size()} family member<g:if test="${people.size()>1}">s</g:if>:</h4></div>
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
                        <h4>Found in ${answers.size()} answer<g:if test="${answers.size()>1}">s</g:if>: <span style="font-weight:normal;">(<span style="font-weight:bold;">bold</span> = would lead, <span style="font-style:italic;">italic</span> = would organize)</span></h4>
                    </div>
                    <g:each in="${answers}" var="answer">
                        <div class="content-children-row">
                            <g:link controller="navigate" action="familymember" id="${answer[3]}"><div class="cell190 <g:if test='${answer[1]}'>cg-bold </g:if><g:if test='${answer[2]}'>cg-italic</g:if>">${answer[4]} ${answer[5]}</div></g:link>
                            <div class="cell120">${answer[7]}</div>
                            <div class="cell300"><a href="mailto:${answer[8]}">${answer[8]}</a></div>
                            <div class="cell250">${answer[9]}</div>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>


            </div>
    </body>
</html>