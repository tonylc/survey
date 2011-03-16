// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function showFamilyDiv() {
    var result = getStyleClass("family-results");
    if (!result) return;
    
    if (result.style.display == "") {
        result.style.display = "none";
        $('family-score-title').style.visibility = "hidden";

    }
    else {
        result.style.display = "";
        $('family-score-title').style.visibility = "visible";
    }
}

function getStyleClass (className) {
    if (document.all) {
	  cssRules = 'rules';
	 }
	 else if (document.getElementById) {
	  cssRules = 'cssRules';
	 }

    var sheets = document.styleSheets;
    var length = sheets.length;
    for (s = 0; s < length; s++) {
        for (var r = 0; r < sheets[s][cssRules].length; r++)
        {
            if (sheets[s][cssRules][r].selectorText == '.' + className)
            {
                return sheets[s][cssRules][r];
            }
        }
	}
	
	return null;
}