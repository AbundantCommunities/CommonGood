<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="report">
        <title>Block Connectors</title>
        <script src="${resource(dir:'js',file:'encoder.js')}"></script>
        <script type="text/javascript">

            function criteriaStatus() {
                var searchText = document.getElementById('qInput').value;
                var fromBirthYearValue = document.getElementById('fromBirthYearInput').value;
                var toBirthYearValue = document.getElementById('toBirthYearInput').value;

                var searchTextPresent = searchText.length>0;
                var fromBirthYearPresent = fromBirthYearValue.length>0;
                var fromBirthYearValid = isValidAge(fromBirthYearValue);
                var toBirthYearPresent = toBirthYearValue.length>0;
                var toBirthYearValid = isValidAge(toBirthYearValue);

                if (!searchTextPresent && !fromBirthYearPresent && !toBirthYearPresent) {
                    return "Please enter something to search for.";
                } else {
                    if (fromBirthYearPresent && !fromBirthYearValid) {
                        return "Please enter a valid 'from age'.";
                    }
                    if (toBirthYearPresent && !toBirthYearValid) {
                        return "Please enter a valid 'to age'.";
                    }
                    if (fromBirthYearPresent && toBirthYearPresent && parseInt(toBirthYearValue) < parseInt(fromBirthYearValue)) {
                        return "The 'to' age must be the same or greater than the 'from' age.";
                    }
                }

                return "";

            }

            function doAdvancedSearch() {

                var currentCriteriaStatus = criteriaStatus();

                if (currentCriteriaStatus.length > 0) {
                    alert(currentCriteriaStatus);
                } else {
                    document.getElementById("advanced-form").submit();
                }
            }

            function isValidAge(someAge) {
                minAge = 0;
                maxAge = 110;

                if (someAge.length > 0) {
                    var pattern = /^([1-9]\d*|0)$/;

                    if (pattern.test(someAge)) {
                        if(someAge >= minAge && someAge <= maxAge) {
                           //Got a number in range - do something with it
                           return true;
                        } else {
                           //It's a number but out of range
                           return false;
                        }
                    } else {
                       //Non numeric some where in input
                       return false;
                    }
                } else {
                    return true;
                }
            }

            function constructAgeRangeDescription(fromAge,toAge) {
                if (fromAge.length == 0 && toAge.length == 0) {
                    return "";
                } else {
                    if (fromAge.length > 0 && toAge.length > 0) {
                        if (fromAge == toAge) {
                            return ' '+fromAge+' years old';
                        } else {
                            return ' aged '+fromAge+' to '+toAge;
                        }
                    } else if (fromAge.length > 0) {
                        return ' '+fromAge+' and older';
                    } else {
                        return ' age '+toAge+' or less';
                    }
                }
            }


            function updateSearchStatus() {
                var searchText = document.getElementById('qInput').value;
                var fromBirthYearValue = document.getElementById('fromBirthYearInput').value;
                var toBirthYearValue = document.getElementById('toBirthYearInput').value;

                var searchTextPresent = searchText.length>0;
                var fromBirthYearPresent = fromBirthYearValue.length>0;
                var fromBirthYearValid = isValidAge(fromBirthYearValue);
                var toBirthYearPresent = toBirthYearValue.length>0;
                var toBirthYearValid = isValidAge(toBirthYearValue);

                if (fromBirthYearValid) {
                    document.getElementById('fromValidImg').setAttribute("style","display:none;");
                } else {
                    document.getElementById('fromValidImg').setAttribute("style","display:default;");
                }
                if (toBirthYearValid) {
                    document.getElementById('toValidImg').setAttribute("style","display:none;");
                } else {
                    document.getElementById('toValidImg').setAttribute("style","display:default;");
                }

                if (fromBirthYearValid && toBirthYearValid) {
                    // valid input values, check if toAge is >= fromAge
                    if (fromBirthYearPresent && toBirthYearPresent && parseInt(toBirthYearValue) < parseInt(fromBirthYearValue)) {
                        document.getElementById('searchDescription').innerHTML = "The 'to' age must be the same or greater than the 'from' age.";
                    } else {
                        if (searchTextPresent || fromBirthYearPresent || toBirthYearPresent) {
                            var newSearchDescription;
                            if (searchTextPresent) {
                                newSearchDescription = 'Search answers and people';
                                if (fromBirthYearPresent || toBirthYearPresent) {
                                    newSearchDescription = newSearchDescription+constructAgeRangeDescription(fromBirthYearValue,toBirthYearValue);
                                }
                                newSearchDescription = newSearchDescription+' for "'+searchText+'"'
                            } else {
                                newSearchDescription = 'Search for people'+constructAgeRangeDescription(fromBirthYearValue,toBirthYearValue);
                            }
                            document.getElementById('searchDescription').innerHTML = newSearchDescription;
                        } else {
                            document.getElementById('searchDescription').innerHTML = "";
                        }
                    }


                } else if (!fromBirthYearValid) {
                    document.getElementById('searchDescription').innerHTML = "Please enter a valid 'from age'.";
                } else {
                    document.getElementById('searchDescription').innerHTML = "Please enter a valid 'to age'.";
                }
            }

            function checkAdvancedEnter(e) {
                var characterCode;

                if(e && e.which) { //if which property of event object is supported (NN4)
                    e = e;
                    characterCode = e.which; //character code is contained in NN4's which property
                }
                else{
                    e = event;
                    characterCode = e.keyCode; //character code is contained in IE's keyCode property
                }

                if(characterCode == 13) { //if generated character code is equal to ascii 13 (if enter key)
                    doAdvancedSearch(); //submit the form
                } else {
                    updateSearchStatus();
                }
            }


        </script>
        <style type="text/css">
            #advanced-content {
                width:360px;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
                margin:auto;
                margin-top: 10px;
                margin-bottom: 10px;
                padding: 20px;
            }
            .criteria-container {
                width: 100%;
                height:30px;
            }
            .criteria-label {
                width: 30%;
                display: inline-block;
                text-align: right;
            }
            .criteria-value {
                width: 45%;
                display: inline-block;
                text-align: left;
            }
            #search-button {
                display: inline-block;
                height: 22px;
                width: 80px;
                margin-left: 10px;
                cursor:pointer; /*forces the cursor to change to a hand when the button is hovered*/
                color:#B48B6A;
                padding-top: 4px;
                text-align: center;
                border-radius: 5px;
                border-width:thin;
                border-style:solid;
                border-color: #B48B6A;
                background-color:#FFFFFF;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
            <div id="content-children" style="padding-bottom:10px;text-align:center;background:rgba(0,0,0,0.1);">
                <div id="advanced-content">
                    <div style="margin-top:-15px;"><h3>Advanced Search</h3></div>
                    <div style="font-size:smaller;margin-top:-10px;margin-bottom:10px;">Enter one or more values</div>
                    <form id="advanced-form" action="advanced">
                        <div class="criteria-container">
                            <div class="criteria-label">
                                <div>Search text</div>
                            </div>
                            <div class="criteria-value">
                                <div><input id="qInput" type="text" name="q" value="" onKeyUp="checkAdvancedEnter(event);" size="18"/></div>
                            </div>
                        </div>
                        <div class="criteria-container">
                            <div class="criteria-label">
                                <div>From age</div>
                            </div>
                            <div class="criteria-value">
                                <div><input id="fromBirthYearInput" type="text" name="fromAge" value="" onKeyUp="checkAdvancedEnter(event);" size="10"/><span id="fromValidImg" style="display:none;">&nbsp;<img style="vertical-align:middle;" src="${resource(dir:'images',file:'invalid.png')}" width="16px" height="16px" /></span></div>
                            </div>
                        </div>
                        <div class="criteria-container">
                            <div class="criteria-label">
                                <div>To age</div>
                            </div>
                            <div class="criteria-value">
                                <div><input id="toBirthYearInput" type="text" name="toAge" value="" onKeyUp="checkAdvancedEnter(event);" size="10"/><span id="toValidImg" style="display:none;">&nbsp;<img style="vertical-align:middle;" src="${resource(dir:'images',file:'invalid.png')}" width="16px" height="16px" /></span></div>
                            </div>
                        </div>
                    </form>
                    <div id="searchDescription" style="font-size:smaller;margin-bottom:15px;margin-top:15px;min-height:30px;"></div>
                    <div id="search-button" onclick="doAdvancedSearch();">Search</div>
                </div>
            </div>
    </body>
</html>