model = {
	name: "Alice",
	password: "",
	notes: "function hello() {\n\treturn 1;\n}"
};

box_name = QuillSingle("Name", "Enter name")
	.BindText(model, "name")
	.SetSelectAllOnFocus(true)
	.SetLabelPlacement(eQuillLabelPlacement.Above)
	.SetLabelAlign(eQuillLabelAlign.Start)
	.SetLabelOverflow(eQuillLabelOverflow.Wrap);

box_password = QuillSingle("Password", "Enter password")
	.BindText(model, "password")
	.SetInputMode(QUILL_TEXTMODE_PASSWORD)
	.SetPasswordMask(true, "*", false)
	.SetLabelPlacement(eQuillLabelPlacement.Above)
	.SetLabelAlign(eQuillLabelAlign.Start);

box_notes = QuillMulti("Notes", "Code notes")
	.BindText(model, "notes")
	.SetInputMode(QUILL_TEXTMODE_CODE)
	.SetWrap(false)
	.SetTabInserts(true)
	.SetTabUsesSpaces(false)
	.SetTabSpaces(4)
	.SetLabelPlacement(eQuillLabelPlacement.Leading)
	.SetLabelAlign(eQuillLabelAlign.Center)
	.SetLabelOverflow(eQuillLabelOverflow.Ellipsis)
	.SetLabelOffset(12);
	
themes = [
	new QuillTheme(),
	new QuillTheme_NeonCircuit(),
	new QuillTheme_ChunkyCandy(),
	new QuillTheme_VoidMango()
];