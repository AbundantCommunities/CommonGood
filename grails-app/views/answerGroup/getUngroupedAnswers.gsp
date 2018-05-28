<%@ page contentType="text/html;charset=UTF-8" %>

<html>
    <head>
        <meta name="layout" content="basic">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ungrouped Answers</title>


        <script type="text/javascript">

            function groupAnswers() {
                document.getElementById('group-form').submit();
            }



            window.onload = function onWindowLoad() {
                <g:if test="${flash.message}">
                document.getElementById("button-div").style.top = "210px";
                </g:if>
            }

        </script>

        <style type="text/css">

            #group-button {
                position: absolute;
                left:90px;
                height: 22px;
                width: 80px;
                font-weight: bold;
                color: #B48B6A;
                padding-top: 4px;
                text-align: center;
                border: solid;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
                cursor: pointer;
            }


            #cancel-button {
                position: absolute;
                height: 22px;
                width: 80px;
                color: #B48B6A;
                padding-top: 4px;
                text-align: center;
                border: solid;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
            }

        </style>

    </head>
    <body>
            <div class="content-section">
                <div id="button-div" style="position:fixed;top:110px;left:917px">
                    <div id="group-button" onclick="groupAnswers();">Group</div>
                    <g:link><div id="cancel-button">Cancel</div></g:link>
                </div>
                <div style="margin-top:-10px;"><h3>Ungrouped Answers</h3></div>

                <div>To assist in identifying related answers, answers with more than one term may appear more than once in the list below.</div>
                <div>&nbsp;</div>
                <div>Select answers you would like to group then click the Group button.</div>
                <div>&nbsp;</div>

                <div class="content-row bold">
                    <div class="cell20"></div>
                    <div class="cell500">Answer</div>
                    <div class="cell190">Question</div>
                    <div class="cell170">Person</div>
                </div>





                <form id="group-form" action="<g:createLink action='getGroupsForAnswers' />" method="POST">



                <g:each in="${result}" var="permutation">
                    <div class="content-children-row">
                        <div class="cell20" style="height:18px;overflow:auto;"><input type="checkbox" name="cga-${permutation.answerId}"/></div>
                        <div class="cell500">${permutation.permutedText}</div>
                        <div class="cell190">${permutation.shortQuestion}</div>
                        <div class="cell170">${permutation.personName}</div>
                    </div>
                </g:each>
                </form>
    </body>
</html>
