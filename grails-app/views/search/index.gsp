<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Abundant Communities - Edmonton</title>
    </head>
    <body>
            <div id="content-children" style="padding-bottom:10px;">

                <div style="margin-top:-10px;">
                    <h3>Searched for "${q}".</h3>
                </div>

                <g:if test="${people.size() == 0 && answers.size() == 0}">
                    <h4>"${q}" not found.</h4>
                </g:if>

                <g:if test="${people.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;"><h4>Family members found (${people.size()}):</h4></div>
                    <g:each in="${people}" var="person">
                        <div class="content-children-row">
                            <g:link controller="navigate" action="familymember" id="${person[0]}">${person[1]} ${person[2]}</g:link>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>

                <g:if test="${answers.size() > 0}">
                    <div style="margin-top:-5px;margin-bottom:-15px;"><h4>Answers found (${answers.size()}):</h4></div>
                    <g:each in="${answers}" var="answer">
                        <div class="content-children-row">
                            <div class="cell400">${answer[0]}</div>
                            <g:link controller="navigate" action="familymember" id="${answer[1]}"><div class="cell300">${answer[2]} ${answer[3]}</div></g:link>
                        </div>
                    </g:each>
                    <div class="content-children-row" style="height:5px;"></div>
                </g:if>


            </div>
    </body>
</html>
