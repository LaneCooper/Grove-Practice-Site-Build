var g_recaptchaKey = '';
var g_recaptchaID = '';

function setupForm(formName, recaptchaKey, recaptchaID) {
	g_recaptchaKey = recaptchaKey;
	g_recaptchaID = recaptchaID;
	var v = $("#" + formName).validate({
		submitHandler: function (form) {
			//Function for when the form passes validation
			var formID = "#" + formName;
			//Hide the submit and disable all the items
			$(formID + " input.submit").hide();
			$(formID + "_messages").html('<img class="ajaxloadimg" src="prebuilt/form/images/loading.gif" />');
			try {
				$(formID).ajaxSubmit({
					dataType: 'json',
					success: function (data) {
						if (data.Error)
							alert("Error processing form: " + data.Error);
						else if (data.code == 1) {
							$('<div>Error posting comment: <p>' + data.message + '</p></div>').dialog({
								title: 'Comment not posted'
							});
						}
						else if (data.Success) {
							alert(data.Success);
							$(formID).clearForm();
						}
						//Either way, recreate the recaptcha - you only get 1 chance at it.
						if (g_recaptchaKey != '') {
							Recaptcha.reload();
						}
						$(formID + " input.submit").show();
						$(formID + "_messages").html('');
					}
				});
			} catch (e) {
				alert("Unable to submit form: " + e);
				return false;
			}

			return false;
		}
	});
}

function createRecaptcha(key, recaptchaID) {
	if (key != '' && recaptchaID != '') {
		Recaptcha.create(key,
		recaptchaID, {
			theme: "clean"
		});
	}
}

function triggerDiv(formId, divId, method, sourceURL) {
	//add the trigger data in
	triggerData = {};
	$(".trigger").each(function (i) {
		triggerData[this.name] = this.value;
		if (this.checked != null) {
			triggerData[this.name] = this.checked;
		}
	});
	//Check if this div has inputs; if so, add in their current values
	$("#" + divId + " input, #" + divId + " select").each(function (i) {
		triggerData[this.name] = this.value;
	});
	if (method == 'post') {
		$.post(sourceURL, triggerData, function (data) {
			$("#" + divId).html(data);
			updateFormValidation(formId, divId);
		});
	} else { //default to get
		$.get(sourceURL, triggerData, function (data) {
			$("#" + divId).html(data);
			updateFormValidation(formId, divId);
		});
	}

}

function updateFormValidation(formId, divId) {
	//hide the errors on the new fields
	$("#" + divId + " label.error").hide();
	//once you've replaced the data, re-initialize the form to get the new fields to validate.
	$("#" + formId).validate();
}

function triggerInput(inputId, method, sourceURL) {
	alert('not implemented');
}