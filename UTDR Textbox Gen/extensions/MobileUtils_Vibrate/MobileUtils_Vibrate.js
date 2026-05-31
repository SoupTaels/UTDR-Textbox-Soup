function MobileUtils_Vibrate_Is_Available() {
	if (navigator.vibrate) {
		return 1.0;
	} else {
		return 0.0;
	}
}


function MobileUtils_Vibrate_Shot(milliseconds) {
    navigator.vibrate(milliseconds);
}

function MobileUtils_Vibrate_Predefined(kind) {
	console.log("MobileUtils_Vibrate_Predefined: Function Not Available on HTML Export");
}


