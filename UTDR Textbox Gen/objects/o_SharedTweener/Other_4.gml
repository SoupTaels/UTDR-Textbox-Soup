/// @desc Handle Persistence
/// Feather ignore all

// Reset auto-cleaner index
autoCleanIndex = 0;

// IF the entered room is persistent
if (room_persistent)
{   
    var _tweens = tweens;               // Cache tweens list
    var _delayedTweens = delayedTweens; // Cache delayed tweens
    var _key = room;                    // Cache room name for map key
    
    // IF stored tween data exists for persistent room
    if (ds_map_exists(pRoomTweens, _key))
    {
        // Cache queue of room's tweens
        var _queuedTweens = pRoomTweens[? _key];
        
		// Iterate through queue, adding stored tweens back to main tween list
        repeat(ds_queue_size(_queuedTweens)) 
		{ 
			ds_list_add(_tweens, ds_queue_dequeue(_queuedTweens)); 
		}
    }
    
    // IF stored tween delay data exists for persistent room
    if (ds_map_exists(pRoomDelays, _key))
    {
        // Cache queue of room's delayed tweens
        var _queuedDelays = pRoomDelays[? _key];
        
		// Iterate through queue, adding stored tween delays back to main tween delay list
        repeat(ds_queue_size(_queuedDelays)) 
		{ 
			ds_list_add(_delayedTweens, ds_queue_dequeue(_queuedDelays)); 
		}
    }

    // Update process counts
    tweensProcessNumber = ds_list_size(tweens);
    delaysProcessNumber = ds_list_size(delayedTweens);
}
