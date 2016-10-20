function dismissCopyModal(copydivid) {
    document.getElementById("transparent-overlay").style.visibility='hidden';
    var copydiv = document.getElementById(copydivid);
    copydiv.style.visibility='hidden';
}



function presentForCopy(copydivid,copyContent,numRows,title,description,copyContentTitle) {

    var isMacPlatform = navigator.platform.indexOf('Mac') != -1;

    var copydiv = document.getElementById(copydivid);

    var copydivHTML = '<div class="modal-title">'+title+'</div><div class="modal-row small-text">'+description+'</div><div class="modal-row">'+copyContentTitle+': <textarea id="copy-textarea" class="note-style small-text" style="resize:none;overflow-y:scroll;" cols=80 rows='+numRows+'>'+copyContent+'</textarea></div><div class="modal-row footnote">Choose Copy from the Edit menu or press ';

    if (isMacPlatform) {
        copydivHTML = copydivHTML + '&#8984;-C';
    } else {
        copydivHTML = copydivHTML + 'ctrl-C';
    }

    copydivHTML = copydivHTML + ' to copy to the clipboard.</div><div class="button-row"><div class="button" onclick="JavaScript:dismissCopyModal(' + "'" + copydivid + "'" + ');">Done</div></div>';

    copydiv.innerHTML = copydivHTML;

    var pagecontainerDiv = document.getElementById("pagecontainer");
    document.getElementById("transparent-overlay").setAttribute("style","height:"+pagecontainerDiv.clientHeight+"px;");
    document.getElementById("transparent-overlay").style.visibility='visible';
    copydiv.style.visibility='visible';

    document.getElementById('copy-textarea').focus();
    document.getElementById('copy-textarea').select();

}
