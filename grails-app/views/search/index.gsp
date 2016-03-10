<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Abundant Communities - Edmonton</title>
        <script type="text/javascript">
            function showContactInfo() {
                document.getElementById('show-contact-form').submit();
            }

        </script>
    </head>
    <body>
            <div id="content-children" style="padding-bottom:10px;">

                <div style="width:910px;">
                    <g:if test="${people.size()>0 || answers.size()>0}">
                        <div style="display:inline-block;float:right;"><span style="font-weight:bold;">Show:</span>  Search Results | <a href="#" onclick="showContactInfo();">Contact Info</a></div>
                    </g:if>
                    <form id="show-contact-form" action="<g:createLink controller='search' action='withContactInfo' />" method="get">
                        <input id="show-contact-criteria" type="hidden" name="q" value="${q}" />
                    </form>
                </div>


                <g:if test="${people.size() == 0 && answers.size() == 0}">
                    <h4>Failed to find the exact word/phrase: "${q}"</h4>
                </g:if>

                <g:if test="${people.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;">
                        <h4>Found "${q}" in ${people.size()} <g:if test="${people.size()>1}">people</g:if><g:else>person</g:else>:</h4>
                    </div>
                    <g:each in="${people}" var="person">
                        <div class="content-children-row">
                            <g:link controller="navigate" action="familymember" id="${person[0]}">${person[1]} ${person[2]}</g:link>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>

                <g:if test="${answers.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;">
                        <h4>Found "${q}" in ${answers.size()} answer<g:if test="${answers.size()>1}">s</g:if>: <span style="font-weight:normal;">(<span style="font-weight:bold;">bold</span> = would lead, <span style="font-style:italic;">italic</span> = would organize)</span></h4>
                    </div>
                    <g:each in="${answers}" var="answer">
                        <div class="content-children-row">
                            <div class="cell550">
                                <span class="<g:if test='${answer[1]}'>cg-bold </g:if><g:if test='${answer[2]}'>cg-italic</g:if>">${answer[0]}</span> 
                                <span style="font-size:x-small;">(${answer[6]})</span>
                            </div>
                            <g:link controller="navigate" action="familymember" id="${answer[3]}"><div class="cell300">${answer[4]} ${answer[5]}</div></g:link>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>


            </div>
    </body>
</html>
