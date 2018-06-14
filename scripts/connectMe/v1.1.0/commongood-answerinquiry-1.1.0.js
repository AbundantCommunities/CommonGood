var CGAnonRequestVersion = '1.0';

var CGCurrentlyInquiringRow = -1;

var CGTimerlen = 5;
var CGSlideAniLen = 250;

var CGTimerID = new Array();
var CGStartTime = new Array();
var CGObj = new Array();
var CGEndHeight = new Array();
var CGMoving = new Array();
var CGDirection = new Array();
var CGSlideDownWhenDone = new Array();

function CGSlidedown(objname){
        if(CGMoving[objname])
                return;

        if(document.getElementById(objname).style.display != "none")
                return; // cannot slide down something that is already visible

        CGMoving[objname] = true;
        CGDirection[objname] = "down";
        CGStartslide(objname);
}

function CGSlideup(objname,slidedownwhendone){
        if(CGMoving[objname])
                return;

        if(document.getElementById(objname).style.display == "none")
                return; // cannot slide up something that is already hidden

        CGMoving[objname] = true;
        CGDirection[objname] = "up";
        CGSlideDownWhenDone[objname] = slidedownwhendone;
        CGStartslide(objname);
}

function CGStartslide(objname){
        CGObj[objname] = document.getElementById(objname);

        CGObj[objname].style.display = "block";

		var CGCommentTextareaWidth = document.getElementById("CGCommentTextarea").clientWidth;
		document.getElementById("CGErrorMessageDiv").style.width = CGCommentTextareaWidth+'px';

        // CGEndHeight[objname] = parseInt(CGObj[objname].style.height);
        CGEndHeight[objname] = parseInt(CGObj[objname].clientHeight);
        CGStartTime[objname] = (new Date()).getTime();

        if(CGDirection[objname] == "down"){
                CGObj[objname].style.height = "1px";
        }

        CGTimerID[objname] = setInterval('CGSlidetick(\'' + objname + '\');',CGTimerlen);
}

function CGSlidetick(objname){
        var elapsed = (new Date()).getTime() - CGStartTime[objname];

        if (elapsed > CGSlideAniLen)
                CGEndSlide(objname)
        else {
                var d =Math.round(elapsed / CGSlideAniLen * CGEndHeight[objname]);
                if(CGDirection[objname] == "up")
                        d = CGEndHeight[objname] - d;

                CGObj[objname].style.height = d + "px";
        }

        return;
}

function CGEndSlide(objname){
        clearInterval(CGTimerID[objname]);

        if(CGDirection[objname] == "up") {
            CGObj[objname].style.display = "none";
            CGObj[objname].innerHTML = "";
        }

        CGObj[objname].style.height = CGEndHeight[objname] + "px";

        delete(CGMoving[objname]);
        delete(CGTimerID[objname]);
        delete(CGStartTime[objname]);
        delete(CGEndHeight[objname]);
        delete(CGObj[objname]);
        delete(CGDirection[objname]);
        if (CGSlideDownWhenDone[objname] != null) {
        	CGInquireAboutAnswer(CGSlideDownWhenDone[objname]);
        }
        delete(CGSlideDownWhenDone[objname]);
        return;
}


var CGAnswerArray;

function CGSubmitRequest(row) {

	function validateInput(messageElement,residentName,emailAddress,homeAddress,phoneNumber,comment) {

	    function emailOk(email) {
	        if (email.length > 0) {
	            var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
	            return re.test(email);
	        }
	        return true;
	    }

		if (residentName != "") {
			if (emailAddress != "" || phoneNumber != "" || homeAddress != "") {
				if (emailOk(emailAddress)) {
					return true;
				} else {
					messageElement.style.color = "red";
					messageElement.innerHTML = CGInvalidEmailErrorText;
				}
			} else {
				messageElement.style.color = "red";
				messageElement.innerHTML = CGMissingDataErrorText;
			}
		} else {
			messageElement.style.color = "red";
			messageElement.innerHTML = CGNameIsBlankErrorText;
		}
		return false;
	}

	var CGResidentName = document.getElementById("CGResidentNameInput").value;
	var CGEmailAddress = document.getElementById("CGEmailAddressInput").value;
	var CGHomeAddress = document.getElementById("CGHomeAddressInput").value;
	var CGPhoneNumber = document.getElementById("CGPhoneNumberInput").value;
	var CGComment = document.getElementById("CGCommentTextarea").value;

	if (validateInput(document.getElementById("CGErrorMessageDiv"),CGResidentName,CGEmailAddress,CGHomeAddress,CGPhoneNumber,CGComment)) {
		var xmlhttp = new XMLHttpRequest( );

		CGRequestReference = "answer: "+CGAnswerArray[row][0];

		var params = "neighbourhoodId="+CGNeighbourhoodID+"&residentName="+CGResidentName+"&emailAddress="+CGEmailAddress+"&homeAddress="+CGHomeAddress+"&phoneNumber="+CGPhoneNumber+"&comment="+CGComment+"&requestContext="+CGRequestContext+"&requestReference="+CGRequestReference+"&requestVersion="+CGAnonRequestVersion;

		xmlhttp.open("POST", CGURL+'anonymous/hello', true);

		//Send the proper header information along with the request
		xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

		xmlhttp.onreadystatechange = function() {//Call a function when the state changes.
			if(xmlhttp.readyState == 4 && xmlhttp.status == 200) {

	            var theResult = JSON.parse( xmlhttp.responseText );
	            if (theResult.status == "0") {
	            	// Clear input.
					document.getElementById("CGResidentNameInput").value = "";
					document.getElementById("CGEmailAddressInput").value = "";
					document.getElementById("CGHomeAddressInput").value = "";
					document.getElementById("CGPhoneNumberInput").value = "";
					document.getElementById("CGCommentTextarea").value = "";
					document.getElementById("CGErrorMessageDiv").style.color = "blue";
					document.getElementById("CGErrorMessageDiv").innerHTML = "";

					document.getElementById('CGConfirmationDiv').style.height = document.getElementById('CGInputDiv').clientHeight+"px";
					document.getElementById('CGConfirmationDiv').style.width = document.getElementById('CGInputDiv').clientWidth+"px";

					document.getElementById("CGInputDiv").style.display = "none";
					document.getElementById("CGConfirmationDiv").style.display = "table-cell";

	            } else {
					document.getElementById("CGErrorMessageDiv").style.color = "red";
					document.getElementById("CGErrorMessageDiv").innerHTML = CGSubmitErrorText+" ("+theResult.text+")";
	            }
			}
		}

		xmlhttp.send(params);

	}
}


function CGDoneRequest(row) {

	CGSlideup("CGAnswer"+row, null);
	CGCurrentlyInquiringRow = -1;

}


var xmlhttp = new XMLHttpRequest( );

function CGInquireAboutAnswer(row) {

	if (CGCurrentlyInquiringRow >= 0 && CGCurrentlyInquiringRow != row) {
		CGSlideup("CGAnswer"+CGCurrentlyInquiringRow, row);
		CGCurrentlyInquiringRow = -1;
	} else {
		var inquiryHTML = '<div id="CGInputDiv" style="display:inline-block;">';
		inquiryHTML += '<br>';
		inquiryHTML += '	<div style="padding-left:'+CGLeftMargin+'px;padding-top:15px;padding-right:15px;padding-bottom:5px;vertical-align:top;">';
		inquiryHTML += '		To inquire about "'+CGAnswerArray[row][0]+'", fill the form below and click '+CGSubmitButtonText+'.';
		inquiryHTML += '	</div>';
		inquiryHTML += '	<div style="padding-left:'+CGLeftMargin+'px;padding-top:15px;padding-right:15px;padding-bottom:5px;vertical-align:top;">';
		inquiryHTML += '		<div style="display:inline-block;width:'+CGLabelWidth+'px;">'+CGNameLabelText+'</div>';
		inquiryHTML += '		<div style="display:inline-block;"><input id="CGResidentNameInput" type="text" name="residentName" size="'+CGInputSize+'" value=""/></div>';
		inquiryHTML += '	</div>';
		inquiryHTML += '	<div style="padding-left:'+CGLeftMargin+'px;padding-right:15px;padding-bottom:5px;vertical-align:top;">';
		inquiryHTML += '		<div style="display:inline-block;width:'+CGLabelWidth+'px;">'+CGEmailLabelText+'</div>';
		inquiryHTML += '		<div style="display:inline-block;"><input id="CGEmailAddressInput" type="text" name="emailAddress" size="'+CGInputSize+'" value=""/></div>';
		inquiryHTML += '	</div>';
		inquiryHTML += '	<div style="padding-left:'+CGLeftMargin+'px;padding-right:15px;padding-bottom:5px;vertical-align:top;">';
		inquiryHTML += '		<div style="display:inline-block;width:'+CGLabelWidth+'px;">'+CGHomeAddressLabelText+'</div>';
		inquiryHTML += '		<div style="display:inline-block;"><input id="CGHomeAddressInput" type="text" name="homeAddress" size="'+CGInputSize+'" value=""/></div>';
		inquiryHTML += '	</div>';
		inquiryHTML += '	<div style="padding-left:'+CGLeftMargin+'px;padding-right:15px;padding-bottom:5px;vertical-align:top;">';
		inquiryHTML += '		<div style="display:inline-block;width:'+CGLabelWidth+'px;">'+CGPhoneNumberLabelText+'</div>';
		inquiryHTML += '		<div style="display:inline-block;"><input id="CGPhoneNumberInput" type="text" name="phoneNumber" size="'+CGInputSize+'" value=""/></div>';
		inquiryHTML += '	</div>';
		inquiryHTML += '	<div style="padding-left:'+CGLeftMargin+'px;padding-right:15px;padding-bottom:10px;vertical-align:top;">';
		inquiryHTML += '		<div style="display:inline-block;width:'+CGLabelWidth+'px;">'+CGCommentLabelText+'</div>';
		inquiryHTML += '		<div style="display:inline-block;"><textarea id="CGCommentTextarea" rows="'+CGCommentRows+'" cols="'+CGCommentCols+'" style="resize:none;"></textarea></div>';
		inquiryHTML += '	</div>';
		inquiryHTML += '	<div style="padding-left:'+CGLeftMargin+'px;padding-right:15px;padding-bottom:5px;vertical-align:top;">';
		inquiryHTML += '		<div style="display:inline-block;width:'+CGLabelWidth+'px;"></div>';
		inquiryHTML += '		<div style="display:inline-block;"><input style="padding:6px;" type="submit" value="'+CGSubmitButtonText+'" onclick="JavaScript:CGSubmitRequest('+row+');"/><div style="display:inline-block;width:10px;"></div><input style="padding:6px;" type="submit" value="'+CGSubmitCancelButtonText+'" onclick="JavaScript:CGDoneRequest('+row+');"/></div>';
		inquiryHTML += '	</div>';
		inquiryHTML += '	<div style="padding-left:'+CGLeftMargin+'px;padding-right:15px;padding-bottom:15px;vertical-align:top;">';
		inquiryHTML += '		<div style="display:inline-block;width:'+CGLabelWidth+'px;"></div>';
		inquiryHTML += '		<div id="CGErrorMessageDiv" style="display:inline-block;width:100px;"></div>';
		inquiryHTML += '	</div>';
		inquiryHTML += '</div>';
		inquiryHTML += '<div id="CGConfirmationDiv" style="display:none;vertical-align:middle;text-align:center;">';
		inquiryHTML += '	<div style="display:inline-block;">';
		inquiryHTML += '		<div style="padding-left:'+CGLeftMargin+'px;padding-bottom:20px;"><img src="data:image/png;base64,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" width="40px" height="40px" /></div>';
		inquiryHTML += '		<div style="padding-left:'+CGLeftMargin+'px;padding-bottom:10px;">'+CGSubmitSuccessText1+'</div>';
		inquiryHTML += '		<div style="padding-left:'+CGLeftMargin+'px;padding-bottom:20px;">'+CGSubmitSuccessText2+'</div>';
		inquiryHTML += '		<input style="padding-left:'+CGLeftMargin+'px;padding:6px;" type="submit" value="'+CGSubmitSuccessButtonLabelText+'" onclick="JavaScript:CGDoneRequest('+row+');"/>';
		inquiryHTML += '	</div>';
		inquiryHTML += '</div>';

		document.getElementById("CGAnswer"+row).innerHTML = inquiryHTML;

		CGCurrentlyInquiringRow = row;
		CGSlidedown("CGAnswer"+row);
	}



}


xmlhttp.onreadystatechange = function( ) {
    if( xmlhttp.readyState == 4 ) {
        CGAnswerArray = JSON.parse( xmlhttp.responseText );
        buildTable( CGAnswerArray );
    }
};

xmlhttp.open("GET", CGURL+'answer/frequencies/'+CGQuestionID+'?json=yes', true);
xmlhttp.send( );

function buildTable( arr ) {
    var out = '<div>';
    var i;
    var maxAnswerCount = 0;

    if (CGIncludeCounts || CGIncludeBars) {
    	// sort by count, which is how arr is sorted by default
    	if (CGIncludeBars) {
	    	// find maximum count so bar can be displayed properly
		    for(i = 0; i < arr.length; i++) {
		    	if (arr[i][1] > maxAnswerCount) {
		    		maxAnswerCount = arr[i][1];
		    	}
		    }
    	}
    } else {
    	// not displaying counts or bars, so sort by answer text
    	arr.sort();
    }

    for(i = 0; i < arr.length; i++) {
    	var barWidth = 0;
    	if (CGIncludeBars) {
	    	barWidth = Math.round(CGAnswerBarWidth * arr[i][1] / maxAnswerCount);
    	}
    	if (CGAllowAnswerInquiry) {
    		out += '<a href="javascript:CGInquireAboutAnswer('+i+');">';
    	}

        out += '<div style="margin-bottom:5px;"><div style="display:inline-block;width:'+CGAnswerWidth+'px;';

        if (CGAnswerTextColor != "") {
        	out += '">' + arr[i][0] + '</div>'
        } else {
        	out += 'color:'+CGAnswerTextColor+';">' + arr[i][0] + '</div>';
        }

        if (CGIncludeCounts) {
        	out += '<div style="display:inline-block;width:'+CGAnswerCountWidth+'px;">' + arr[i][1] + '</div>';
        }
        
        if (CGIncludeBars) {
        	out += '<div style="display:inline-block;background-color:'+CGAnswerBarColor+';border-radius:10px;width:'+barWidth+'px;">&nbsp;</div>';
        }

        out += '</div>';

        if (CGAllowAnswerInquiry) {
        	out += '</a>';
	        out += '<div id="CGAnswer'+i+'" style="display:none;overflow:hidden;"></div>';
        }
    }
    out += '</div>'
    document.getElementById("CGAnswers").innerHTML = out;
}

