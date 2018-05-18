<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta name="layout" content="basic">
        <title>Answers of a Group</title>
    </head>
    <body>

            <div class="content-section">
                    <div style="margin-top:-10px;"><h3>Answers Grouped under "${result.group.name}"</h3></div>

                    <g:if test="${result.answers.size()>0}">

                        <div>To remove an answer from the group, click the answer below.</div>
                        <div>&nbsp;</div>

                        <g:each in="${result.answers}" var="answer">
                            <div class="content-children-row">
                                <a href ="<g:createLink action='removeAnswer' id='${answer.id}'/>">${answer.text}</a><br/>
                            </div>
                        </g:each>
                        <div class="content-children-row">&nbsp;</div>


                    </g:if>
                    <g:else>
                        <div>There are no answers in the group.</div>
                        <div>&nbsp;</div>
                    </g:else>

                    <div class="button-row" style="margin-top:10px;">
                        <g:link><div class="button">Done</div></g:link>
                    </div>
                    <div>&nbsp;</div>

            </div>

    </body>
</html>
