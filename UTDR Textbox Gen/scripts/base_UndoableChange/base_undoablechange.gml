/// @func UndoableChange()
/// @desc Base constructor for an undoable change.
///       It should never be created directly, but inherited instead.
function UndoableChange() constructor {
    
    /// @func can_apply()
    /// @desc Determines whether a given change can be applied or not.
    /// @returns {Bool}
    static can_apply = function() {
        return true;
    }
    
    /// @func apply()
    /// @desc Applies the given undoable change.
    /// @returns {Undefined}
    static apply = function() {
        throw not_implemented_exception("perform()");
    }
    
    /// @func undo()
    /// @desc Undoes the given undoable change.
    /// @returns {Undefined}
    static undo = function() {
        throw not_implemented_exception("undo()");
    }
    
    /// @func cleanup()
    /// @desc Frees the manually managed memory items stored by the change (e.g. ds_* data structures).
    /// @returns {Undefined}
    static cleanup = function() {
        // usually undoable changes won't store manually managed memory items
        // so the implementation is empty by default
    }
}