if (instance_number(ctrl_UndoStack) > 1)
    throw "There can be only one instance of ctrl_UndoStack at a time.";

inner_stack = new UndoStack();
