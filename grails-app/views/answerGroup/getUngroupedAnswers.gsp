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


        </script>

        <style type="text/css">

            #group-button {
                left:50px;
                height: 22px;
                width: 80px;
                font-weight: bold;
                color: #B48B6A;
                margin-top:10px;
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


            #done-button {
                left:20px;
                height: 22px;
                width: 80px;
                color: #B48B6A;
                padding-top: 4px;
                margin-left:5px;
                margin-top:10px;
                text-align: center;
                border: solid;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
            }

            div.sticky {
                position: -webkit-sticky;
                position: sticky;
                margin-top:-30px;
                top: 0;
                margin-bottom:10px;
            }


        </style>

    </head>
    <body>
            <div class="content-section">
                <div style="margin-top:-10px;"><h3>Ungrouped Answers</h3></div>

                <div>To assist in identifying related answers, answers with more than one term may appear more than once in the list below.</div>
                <div>&nbsp;</div>
                <div>Select answers you would like to group then click the Group button.</div>

                <div class="sticky">
                    <div style="display:inline-block;width:730px;"></div>
                    <div id="group-button" style="display:inline-block;" onclick="groupAnswers();">Group</div>
                    <g:link><div id="done-button" style="display:inline-block;">Done</div></g:link>
                </div>

                <div class="content-row bold">
                    <div class="cell20"></div>
                    <div class="cell500">Answer</div>
                    <div class="cell190">Question</div>
                    <div class="cell170">Person</div>
                </div>


                <form id="group-form" action="<g:createLink action='getGroupsForAnswers' />" method="POST">

                <g:each in="${result}" var="permutation">
                    <div class="content-children-row">
                        <div class="cell20"><input type="checkbox" name="cga-${permutation.answerId}"/></div>
                        <div class="cell500">${permutation.permutedText}</div>
                        <div class="cell190">${permutation.shortQuestion}</div>
                        <div class="cell170">${permutation.personName}</div>
                    </div>
                </g:each>
                </form>
    </body>
</html>
