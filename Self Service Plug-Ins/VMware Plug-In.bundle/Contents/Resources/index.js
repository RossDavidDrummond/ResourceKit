
function launch(path) {
    var webView = window.WebView;
    webView.launchVM(path);
}

var rowbackground = "white";
var num = 0;

function addPanel(title, os, cpu, memory, networktype, mac, uuid, vmpath) {
    var VMDataTitles = new Array("OS Type:","Number of CPUs:","Memory:","Network Type:","MAC:", "UUID:", "VM Path:");
    var VMData = new Array(os, cpu, memory, networktype, mac, uuid, vmpath)
    
    var panelHTML = '<tr id="mainRows'+num+'" ><td><div class="toggle_container"><div class="trigger"><a href="#"><div id="arrowicon" ></div>' + title + '</a></div><div class="block"><table id="dataTable">';
    
    
    var j = VMDataTitles.length;  
    for(i = 0; i < j; i++) {        
        if (i == (j - 1)) 
        {
            panelHTML += '<tr><td>' + VMDataTitles[i] + '</td><td>' + VMData[i] + '</td></tr>';
            panelHTML += '</table><br/><div id="launchbuttondiv"><button  type="button" onClick="launch(\'' + vmpath + '\');" >Launch ' + title + '</button></div></div></div><tr><td>';
        } 
        else if (VMDataTitles[i] == "Memory:") 
        {
            panelHTML += '<tr><td>' + VMDataTitles[i] + '</td><td>' + VMData[i] + ' MB</td></tr>';
        } 
        else 
        {
            panelHTML += '<tr><td>' + VMDataTitles[i] + '</td><td>' + VMData[i] + '</td></tr>';
        }  
    }
    
    // Appends HTML to container class
    $('#mainTable').append(panelHTML); 
    if(rowbackground == "white"){
		$('#mainRows'+num+'').addClass('white');
		rowbackground = "grey";
	}else{
		$('#mainRows'+num+'').addClass('grey');
		rowbackground = "white"
	}
	num++;
    
    // Hides the toggle container class
    $('.block').hide();
    
}