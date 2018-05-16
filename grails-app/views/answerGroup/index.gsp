<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>Answer Group Management</title>
    </head>
    <body>
            <div class="content-section">
                    <div style="margin-top:-10px;"><h3>Manage Answer Groups</h3></div>
                    <g:if test="${ungroupedAnswerCount>1}">
                    <div>You have ${ungroupedAnswerCount} answers that are not grouped.</div>
                    </g:if>
                    <g:elseif test="${ungroupedAnswerCount==1}">
                    <div>You have ${ungroupedAnswerCount} answer that is not grouped.</div>
                    </g:elseif>
                    <g:else>
                    <div>You do not have any ungrouped answers.</div>
                    </g:else>
                    <div>&nbsp;</div>
                    <g:if test="${ungroupedAnswerCount>0}">
                    <div><a href="<g:createLink action='getUngroupedAnswers'/>">See my ungrouped answers</a></div>
                    </g:if>
                    <div>&nbsp;</div>
                    <div><h3>Your Groups</h3></div>
                    <g:if test="${groups.size()>0}">
                        <div>To see the answers in a group, click the group below.</div>
                        <div>&nbsp;</div>
                        <g:each in="${groups}" var="group">
                            <g:link action="getAnswers" id="${group.id}">${group.name}</g:link><br/>
                        </g:each>
                    </g:if>
                    <g:else>
                        <div>Currently there are no answer groups.</div>
                    </g:else>

                    <div>&nbsp;</div>
            </div>
    </body>
</html>
